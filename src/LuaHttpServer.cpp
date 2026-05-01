#include "LuaHttpServer.h"
#include "TickProfiler.h"
#include <DynamicOutput/DynamicOutput.hpp>
#include <Helpers/String.hpp>
#include <Unreal/Hooks/Hooks.hpp>
#include <Mod/LuaMod.hpp>
#include <boost/url.hpp>
#include <algorithm>
#include <chrono>

using namespace RC;

// ---------------------------------------------------------------------------
// Lua table → boost::json::value conversion (game thread).
// Replaces Lua-side json.stringify — avoids the intermediate Lua string
// allocation.  The resulting json::value is serialized to a string later
// (on the async thread in HandleConnection, or immediately here).
// ---------------------------------------------------------------------------

static json::value lua_value_to_json(lua_State* L, int idx);
static json::value lua_table_to_json_value(lua_State* L, int table_idx);

static json::value lua_table_to_json_value(lua_State* L, int table_idx)
{
	int abs_idx = lua_absindex(L, table_idx);

	// First pass: determine if this is an array (consecutive integer keys starting from 1)
	bool is_array = true;
	lua_Integer expected_key = 1;
	lua_Integer array_len = 0;

	lua_pushnil(L);
	while (lua_next(L, abs_idx) != 0) {
		if (lua_type(L, -2) != LUA_TNUMBER || !lua_isinteger(L, -2) || lua_tointeger(L, -2) != expected_key) {
			is_array = false;
			lua_pop(L, 2); // pop value and key
			break;
		}
		expected_key++;
		array_len++;
		lua_pop(L, 1); // pop value, keep key for lua_next
	}

	if (is_array && array_len > 0) {
		json::array arr;
		arr.reserve(static_cast<size_t>(array_len));

		lua_pushnil(L);
		while (lua_next(L, abs_idx) != 0) {
			arr.push_back(lua_value_to_json(L, -1));
			lua_pop(L, 1); // pop value
		}

		return arr;
	} else {
		json::object obj;

		lua_pushnil(L);
		while (lua_next(L, abs_idx) != 0) {
			std::string key;
			int key_type = lua_type(L, -2);
			if (key_type == LUA_TSTRING) {
				key = lua_tostring(L, -2);
			} else if (key_type == LUA_TNUMBER && lua_isinteger(L, -2)) {
				key = std::to_string(lua_tointeger(L, -2));
			} else {
				lua_pop(L, 1);
				continue;
			}

			obj[key] = lua_value_to_json(L, -1);
			lua_pop(L, 1); // pop value
		}

		return obj;
	}
}

static json::value lua_value_to_json(lua_State* L, int idx)
{
	int abs_idx = lua_absindex(L, idx);
	int type = lua_type(L, abs_idx);

	switch (type) {
	case LUA_TNIL:
		return json::value();
	case LUA_TBOOLEAN:
		return json::value(static_cast<bool>(lua_toboolean(L, abs_idx)));
	case LUA_TNUMBER:
		if (lua_isinteger(L, abs_idx)) {
			return json::value(lua_tointeger(L, abs_idx));
		}
		return json::value(lua_tonumber(L, abs_idx));
	case LUA_TSTRING: {
		size_t len;
		const char* str = lua_tolstring(L, abs_idx, &len);
		return json::string(str ? str : "");
	}
	case LUA_TTABLE:
		return lua_table_to_json_value(L, abs_idx);
	default:
		return json::value();
	}
}

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
	// TODO [MEDIUM PRIORITY, LOW EFFORT]: pre-serialize query/headers JSON here
	// (and/or on this worker thread) instead of on the game thread in DispatchOnGameThread.
	// `req.query`/`req.headers` are built here and never touched elsewhere, so the
	// `json::serialize(req.query)` / `json::serialize(req.headers)` calls currently done
	// under LuaMod::m_thread_actions_mutex (lines ~437/440) can be hoisted up to the
	// HTTP worker. Even better: stash the serialized strings on the Request struct so
	// the game thread just does lua_pushlstring().
	//
	// TODO [MEDIUM PRIORITY, MEDIUM EFFORT]: push query/headers as Lua tables directly
	// (lua_createtable + lua_setfield) rather than going through a JSON string the Lua
	// side has to re-decode. Eliminates one C++ serialize + one Lua json.decode per
	// request. Scales with header count on header-heavy endpoints.

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

		// TODO [LOW PRIORITY, TRIVIAL EFFORT]: move-construct the body instead of copying.
		// `req` is local to this function; `req.body()` returns a reference to its string_body,
		// so `std::move(req.body())` avoids one allocation+copy for large bodies. Minor win,
		// HTTP-worker-thread only — does not affect game-thread stalls.

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
			// TODO [HIGH PRIORITY, LOW EFFORT]: replace completed_ map + cv_.notify_all()
			// with a per-request std::promise<Response> / std::future<Response>.
			//
			// Current design:
			//   - HTTP thread parks on cv_.wait_until() holding mtx_.
			//   - Game thread does `completed_[req.id] = ...; cv_.notify_all();` for EVERY
			//     finished request (see DispatchOnGameThread line ~500–503).
			//   - Every waiting HTTP handler wakes, re-locks mtx_, scans completed_, and
			//     99% of the time goes right back to sleep. Thundering herd that also
			//     serializes game-thread publish against HTTP-thread enqueue.
			//
			// Target design:
			//   - Request holds a std::promise<Response>.
			//   - HTTP thread keeps the future locally and calls future.wait_for(30s).
			//   - Game thread calls req.promise.set_value(std::move(response)) — no mtx_,
			//     no notify_all, no map lookup inside the hot Lua loop.
			//
			// This directly removes the per-request `std::lock_guard<std::mutex> lock(mtx_)`
			// currently held inside the Lua dispatch loop on the game thread.
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
			// TODO [HIGH PRIORITY, LOW EFFORT]: serialize the response body here, on the
			// HTTP worker thread, rather than on the game thread in DispatchOnGameThread
			// (see the json::serialize call near line ~477). The Lua→json::value walk MUST
			// stay on the game thread (it touches lua_State), but json::serialize() is a
			// pure function over the already-built json::value and can run anywhere.
			//
			// Plan:
			//   - Change Response::body from std::string to
			//     std::variant<std::string, json::value> (or add an optional<json::value>).
			//   - Game thread stores the json::value directly.
			//   - Here, if the variant holds a json::value, json::serialize(jv) into
			//     res.body(). Strings go through unchanged.
			//
			// For /player_vehicles/*/list?complete=1 and similar, serialization can easily
			// match the Lua walk in CPU time — moving it out of the Lua mutex is the single
			// biggest game-thread win available.
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
	// TODO [HIGH PRIORITY, LOW EFFORT]: enforce MAX_TICK_BUDGET as a hard cutoff, not a warning.
	// Today the per-request elapsed check near the end of the loop only *logs* when a batch
	// exceeds budget, then keeps processing until MAX_PER_TICK is drained. A single batch of
	// several slow handlers can easily blow well past the frame budget before the warning even
	// fires. Change to: if the cumulative elapsed time since func_start exceeds MAX_TICK_BUDGET
	// and there are still items left, re-insert them at the front of pending_ and break out.
	// That turns pathological handlers into a bounded stall and makes MAX_PER_TICK safely
	// raisable (budget becomes the real limiter).

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

	auto func_start = std::chrono::steady_clock::now();
	auto tick_start = func_start;
	for (size_t i = 0; i < local_pending.size(); ++i)
	{
		auto& req = local_pending[i];

		Response response;
		response.status_code = 500;
		response.body = "{\"error\":\"Internal server error\"}";
		response.content_type = "application/json";

		lua_getglobal(lua_state_, "__CppDispatchRequest");
		// TODO [LOW PRIORITY, TRIVIAL EFFORT]: cache __CppDispatchRequest as a Lua registry ref.
		// lua_getglobal is a hash lookup + string intern check on every request. Do it once
		// (lazily, or on SetLuaState) via `dispatch_ref_ = luaL_ref(L, LUA_REGISTRYINDEX)` and
		// replace this call with `lua_rawgeti(L, LUA_REGISTRYINDEX, dispatch_ref_)` — O(1) with
		// no hashing. Small per-request win but pays for itself on every tick. Remember to
		// invalidate the ref in SetLuaState() and re-acquire on next dispatch.
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

			// TODO [MEDIUM PRIORITY, LOW EFFORT]: these two serializations are happening on
			// the game thread while holding LuaMod::m_thread_actions_mutex. They do not touch
			// lua_State — hoist them to HandleConnection on the HTTP worker and store the
			// resulting strings on the Request struct (see the matching TODO at the top of
			// HandleConnection). Bonus variant: build Lua tables directly instead of JSON.
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
				// TODO [LOW PRIORITY, LOW EFFORT]: pass a message-handler index to lua_pcall
				// (e.g. debug.traceback pushed below the function) so error traces include
				// the Lua stack rather than just the raw error string. Helps diagnose slow
				// or broken handlers without measurable runtime cost.
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

				// Body: table → C++ JSON conversion (avoids Lua-side json.stringify);
				//       string → use directly; nil → empty.
				if (lua_istable(lua_state_, -2))
				{
					// TODO [HIGH PRIORITY, LOW EFFORT]: move json::serialize off the game thread.
					// The lua_value_to_json walk below MUST stay here (it reads lua_State), but
					// json::serialize(jv) is a pure function over the already-built tree. Store
					// the json::value on Response (e.g. std::variant<std::string, json::value>)
					// and serialize in HandleConnection on the HTTP worker thread. For large
					// payloads (e.g. /player_vehicles/*/list?complete=1) serialization cost can
					// rival the walk itself — removing it from under the Lua mutex is the single
					// biggest game-thread win available here.
					//
					// TODO [MEDIUM PRIORITY, MEDIUM EFFORT]: alternatively (only worth it if the
					// above is NOT done) skip the intermediate json::value entirely and serialize
					// directly into a std::string while walking the Lua table via a small
					// recursive emitter. Avoids the per-node json::value allocations. Don't
					// combine with the hoist above — pick one.
					auto json_start = std::chrono::steady_clock::now();
					json::value jv = lua_value_to_json(lua_state_, -2);
					response.body = json::serialize(jv);
					auto json_elapsed = std::chrono::steady_clock::now() - json_start;
					TickProfiler::Get().ReportModTime(
						TickProfiler::COMP_HTTP,
						std::chrono::duration_cast<std::chrono::microseconds>(json_elapsed).count());
				}
				else if (lua_isstring(lua_state_, -2))
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

		// Warn if a single handler took an unexpectedly long time.
		auto elapsed = std::chrono::steady_clock::now() - tick_start;
		if (elapsed > MAX_TICK_BUDGET)
		{
			auto elapsed_ms = std::chrono::duration_cast<std::chrono::milliseconds>(elapsed).count();
			Output::send<LogLevel::Warning>(
				STR("[LuaHttpServer] Slow handler: {} {} took {} ms\n"),
				to_wstring(req.method),
				to_wstring(req.path),
				elapsed_ms);
		}
	}

	auto func_elapsed = std::chrono::steady_clock::now() - func_start;
	TickProfiler::Get().ReportModTime(
		TickProfiler::COMP_HTTP,
		std::chrono::duration_cast<std::chrono::microseconds>(func_elapsed).count());
}
