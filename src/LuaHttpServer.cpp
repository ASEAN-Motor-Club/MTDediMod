#include "LuaHttpServer.h"
#include <DynamicOutput/DynamicOutput.hpp>
#include <Helpers/String.hpp>
#include <Unreal/Hooks/Hooks.hpp>
#include <Mod/LuaMod.hpp>
#include <boost/url.hpp>
#include <algorithm>
#include <chrono>

using namespace RC;

static LuaHttpServer* _luaHttpServer = nullptr;

LuaHttpServer* LuaHttpServer::Get()
{
	if (_luaHttpServer == nullptr)
	{
		_luaHttpServer = new LuaHttpServer();
	}
	return _luaHttpServer;
}

LuaHttpServer::~LuaHttpServer()
{
	Stop();
	UnregisterEngineTickHook();
}

void LuaHttpServer::Start(int port)
{
	if (started_.exchange(true))
		return;

	shutdown_ = false;
	acceptor_thread_ = std::thread(&LuaHttpServer::RunAcceptor, this, port);

	Output::send<LogLevel::Verbose>(STR("[LuaHttpServer] Listening on port {}\n"), port);
}

void LuaHttpServer::Stop()
{
	if (!started_.exchange(false))
		return;

	shutdown_ = true;
	{
		std::lock_guard<std::mutex> lock(mtx_);
		cv_.notify_all();
	}
	if (acceptor_thread_.joinable())
	{
		acceptor_thread_.join();
	}
	pool_.stop();
	pool_.join();
}

void LuaHttpServer::SetLuaState(lua_State* L)
{
	lua_state_ = L;
}

void LuaHttpServer::RegisterEngineTickHook()
{
	if (tick_hook_registered_.exchange(true))
		return;

	using namespace RC::Unreal::Hook;

	auto callback = [this](TCallbackIterationData<void>&, RC::Unreal::UEngine*, float, bool) {
		DispatchOnGameThread();
	};

	tick_callback_id_ = RegisterEngineTickPreCallback(
		callback,
		FCallbackOptions{
			.bOnce = false,
			.bReadonly = true,
			.OwnerModName = STR("MotorTownMods"),
			.HookName = STR("LuaHttpDispatch")
		}
	);

	if (tick_callback_id_ == ERROR_ID)
	{
		Output::send<LogLevel::Error>(
			STR("[LuaHttpServer] Failed to register engine tick hook\n"));
		tick_hook_registered_ = false;
	}
	else
	{
		Output::send<LogLevel::Verbose>(
			STR("[LuaHttpServer] Engine tick hook registered (id={})\n"),
			tick_callback_id_);
	}
}

void LuaHttpServer::UnregisterEngineTickHook()
{
	if (!tick_hook_registered_.exchange(false))
		return;

	if (tick_callback_id_ != RC::Unreal::Hook::ERROR_ID)
	{
		RC::Unreal::Hook::UnregisterCallback(tick_callback_id_);
		tick_callback_id_ = RC::Unreal::Hook::ERROR_ID;
	}
}

void LuaHttpServer::RunAcceptor(int port)
{
	try
	{
		asio::io_context accept_ioc;
		tcp::acceptor acceptor(accept_ioc, tcp::endpoint(tcp::v4(), port));
		acceptor_ptr_ = &acceptor;

		while (!shutdown_)
		{
			tcp::socket socket(accept_ioc);
			acceptor.accept(socket);
			if (shutdown_)
				break;

			asio::post(pool_, [this, s = std::move(socket)]() mutable {
				HandleConnection(std::move(s));
			});
		}
		acceptor_ptr_ = nullptr;
	}
	catch (const std::exception& e)
	{
		acceptor_ptr_ = nullptr;
		if (!shutdown_)
		{
			Output::send<LogLevel::Error>(
				STR("[LuaHttpServer] Acceptor error: {}\n"),
				to_wstring(e.what()));
		}
	}
}

void LuaHttpServer::HandleConnection(tcp::socket socket)
{
	auto conn_start = std::chrono::steady_clock::now();
	int response_status = 500;
	bool wrote_response = false;
	std::string log_method;
	std::string log_path;

	try
	{
		beast::flat_buffer buffer;
		http::request<http::string_body> req;
		http::read(socket, buffer, req);

		// Reject oversized bodies immediately.
		if (req.body().size() > MAX_BODY_SIZE)
		{
			http::response<http::string_body> res;
			res.result(http::status::payload_too_large);
			res.set(http::field::content_type, "application/json");
			res.body() = "{\"error\":\"Payload too large\"}";
			res.set(http::field::server, "MotorTownMods LuaHTTP/1.0");
			res.set(http::field::connection, "close");
			res.prepare_payload();
			http::write(socket, res);
			response_status = 413;
			wrote_response = true;
			return;
		}

		uint64_t req_id = next_id_.fetch_add(1, std::memory_order_relaxed);
		Request request;
		request.id = req_id;
		request.method = std::string(req.method_string());

		auto target = std::string(req.target());
		auto r = boost::urls::parse_uri_reference(target);
		if (r)
		{
			request.path = std::string(r->path());
			for (const auto& p : r->params())
			{
				request.query[std::string(p.key)] = std::string(p.value);
			}
		}
		else
		{
			request.path = target;
		}

		for (const auto& field : req.base())
		{
			std::string name = std::string(field.name_string());
			std::transform(name.begin(), name.end(), name.begin(),
				[](unsigned char c) { return static_cast<char>(std::tolower(c)); });
			request.headers[name] = std::string(field.value());
		}

		request.body = req.body();

		// Keep copies for logging after the move.
		log_method = request.method;
		log_path = request.path;

		// Fast-reject if the pending backlog is too large.
		{
			std::lock_guard<std::mutex> lock(mtx_);
			if (pending_.size() >= MAX_PENDING)
			{
				http::response<http::string_body> res;
				res.result(http::status::service_unavailable);
				res.set(http::field::content_type, "application/json");
				res.body() = "{\"error\":\"Server busy\"}";
				res.set(http::field::server, "MotorTownMods LuaHTTP/1.0");
				res.set(http::field::connection, "close");
				res.prepare_payload();
				http::write(socket, res);
				response_status = 503;
				wrote_response = true;
				return;
			}
			pending_.push_back(std::move(request));
		}
		cv_.notify_one();

		Response response;
		bool got = false;
		{
			std::unique_lock<std::mutex> lock(mtx_);
			auto deadline = std::chrono::steady_clock::now() + std::chrono::seconds(30);
			while (!shutdown_ && completed_.find(req_id) == completed_.end())
			{
				if (cv_.wait_until(lock, deadline) == std::cv_status::timeout)
					break;
			}
			auto it = completed_.find(req_id);
			if (it != completed_.end())
			{
				response = std::move(it->second);
				completed_.erase(it);
				got = true;
			}
		}

		http::response<http::string_body> res;
		if (!got)
		{
			res.result(http::status::gateway_timeout);
			res.set(http::field::content_type, "application/json");
			res.body() = "{\"error\":\"Gateway timeout\"}";
			response_status = 504;
		}
		else
		{
			res.result(static_cast<http::status>(response.status_code));
			res.set(http::field::content_type, response.content_type);
			res.body() = response.body;
			response_status = response.status_code;
		}
		res.set(http::field::server, "MotorTownMods LuaHTTP/1.0");
		res.set(http::field::connection, "close");
		res.prepare_payload();
		http::write(socket, res);
		wrote_response = true;
	}
	catch (const beast::system_error& se)
	{
		if (se.code() != beast::errc::not_connected &&
			se.code() != asio::error::connection_reset &&
			se.code() != asio::error::broken_pipe)
		{
			Output::send<LogLevel::Warning>(
				STR("[LuaHttpServer] Connection error: {}\n"),
				to_wstring(se.code().message()));
		}
	}
	catch (const std::exception& e)
	{
		Output::send<LogLevel::Error>(
			STR("[LuaHttpServer] Handler error: {}\n"),
			to_wstring(e.what()));
	}

	auto duration_ms = std::chrono::duration_cast<std::chrono::milliseconds>(
		std::chrono::steady_clock::now() - conn_start).count();

	if (wrote_response)
	{
		Output::send<LogLevel::Verbose>(
			STR("[LuaHttpServer] {} {} {} ({} ms)\n"),
			to_wstring(std::to_string(response_status)),
			to_wstring(log_method),
			to_wstring(log_path),
			duration_ms);
	}
}

void LuaHttpServer::DispatchOnGameThread()
{
	if (!lua_state_)
		return;

	// Early exit when idle: avoid acquiring LuaMod::m_thread_actions_mutex
	// when there is no work to do. pending_ is independent of LuaMod state.
	std::vector<Request> local_pending;
	{
		std::lock_guard<std::mutex> lock(mtx_);
		if (pending_.empty())
			return;
		size_t n = std::min(pending_.size(), MAX_PER_TICK);
		local_pending.assign(pending_.begin(), pending_.begin() + n);
		pending_.erase(pending_.begin(), pending_.begin() + n);
	}

	// Serialize with all other UE4SS Lua operations on the game thread.
	std::lock_guard<std::recursive_mutex> guard{LuaMod::m_thread_actions_mutex};

	auto tick_start = std::chrono::steady_clock::now();
	for (size_t i = 0; i < local_pending.size(); ++i)
	{
		auto& req = local_pending[i];

		Response response;
		response.status_code = 500;
		response.body = "{\"error\":\"Internal server error\"}";
		response.content_type = "application/json";

		lua_getglobal(lua_state_, "__CppDispatchRequest");
		if (!lua_isfunction(lua_state_, -1))
		{
			lua_pop(lua_state_, 1);
			Output::send<LogLevel::Warning>(
				STR("[LuaHttpServer] __CppDispatchRequest not found in Lua\n"));
		}
		else
		{
			lua_pushlstring(lua_state_, req.method.c_str(), req.method.size());
			lua_pushlstring(lua_state_, req.path.c_str(), req.path.size());

			std::string query_json = json::serialize(req.query);
			lua_pushlstring(lua_state_, query_json.c_str(), query_json.size());

			std::string headers_json = json::serialize(req.headers);
			lua_pushlstring(lua_state_, headers_json.c_str(), headers_json.size());

			if (!req.body.empty())
			{
				lua_pushlstring(lua_state_, req.body.c_str(), req.body.size());
			}
			else
			{
				lua_pushnil(lua_state_);
			}

			if (lua_pcall(lua_state_, 5, 3, 0) != LUA_OK)
			{
				const char* err = lua_tostring(lua_state_, -1);
				Output::send<LogLevel::Error>(
					STR("[LuaHttpServer] Lua error: {}\n"),
					to_wstring(err ? err : "unknown"));
				lua_pop(lua_state_, 1);
			}
			else
			{
				if (lua_isinteger(lua_state_, -3))
				{
					response.status_code = static_cast<int>(lua_tointeger(lua_state_, -3));
				}
				else if (lua_isnumber(lua_state_, -3))
				{
					response.status_code = static_cast<int>(lua_tonumber(lua_state_, -3));
				}

				if (lua_isstring(lua_state_, -2))
				{
					size_t len;
					const char* s = lua_tolstring(lua_state_, -2, &len);
					response.body = std::string(s, len);
				}

				if (lua_isstring(lua_state_, -1))
				{
					response.content_type = lua_tostring(lua_state_, -1);
				}

				lua_pop(lua_state_, 3);
			}
		}

		{
			std::lock_guard<std::mutex> lock(mtx_);
			completed_[req.id] = std::move(response);
		}
		cv_.notify_all();

		// Time budget: if we've exceeded the per-tick allowance, stop and
		// put the remaining requests back at the front of the queue.
		if (i + 1 < local_pending.size())
		{
			auto elapsed = std::chrono::steady_clock::now() - tick_start;
			if (elapsed > MAX_TICK_BUDGET)
			{
				std::lock_guard<std::mutex> lock(mtx_);
				pending_.insert(
					pending_.begin(),
					std::make_move_iterator(local_pending.begin() + i + 1),
					std::make_move_iterator(local_pending.end()));
				break;
			}
		}
	}
}
