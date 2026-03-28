#include "webserver.h"
#include <DynamicOutput/DynamicOutput.hpp>
#include <Helpers/String.hpp>
#include <Unreal/UObjectGlobals.hpp>
#include <format>
#include "statics.h"
#include "EventsRoute.h"
#include "EventManager.h"

// Workaround against multiple check definitions
#pragma push_macro("check")
#undef check
#include <boost/beast.hpp>
#include <boost/json.hpp>
#pragma pop_macro("check")

using namespace RC;
using namespace RC::Unreal;
namespace json = boost::json;


Webserver* _localServer = nullptr;

Webserver::Webserver() {
	ModName = ModStatics::GetModName();
	if (const char* val = getenv("MOD_MANAGEMENT_PORT"))
	{
		Port = atoi(val);
	}

	responses.push_back(std::make_shared<EventsRoute>());

	serverThread = boost::thread(&Webserver::run_server, this, Port);
	serverThread.detach();

	Output::send<LogLevel::Verbose>(STR("[{}] API server listening at {}\n"), ModName, Port);
}

Webserver::~Webserver() {
	// Signal SSE threads to stop (they'll wake and exit)
	EventManager::Get().Shutdown();

	// Wait for all pool threads to finish
	m_pool.join();

	serverThread.interrupt();
	delete _localServer;
	_localServer = NULL;
}

Webserver* Webserver::Get() {
	if (_localServer == nullptr) {
		_localServer = new Webserver();
	}
	return _localServer;
}

bool Webserver::isServerRunning()
{
	return serverThread.joinable();
}



// HTTP Server function — accepts connections and dispatches to thread pool
void Webserver::run_server(unsigned short port) {
	try
	{
		asio::io_context accept_ioc;
		tcp::acceptor acceptor(accept_ioc, tcp::endpoint(tcp::v4(), port));

		while (true) {
			tcp::socket socket(accept_ioc);
			acceptor.accept(socket);

			// Dispatch to fixed thread pool instead of spawning unbounded threads.
			// This caps Wine pipe FD growth to pool_size * ~4 pipes.
			boost::asio::post(m_pool, [this, s = std::move(socket)]() mutable {
				handle_connection(std::move(s));
			});
		}
	}
	catch (const std::exception& e)
	{
		Output::send<LogLevel::Error>(
			STR("[{}] Unexpected server failure: {}\n"),
			ModName,
			to_wstring(e.what()));
		return;
	}
}

// Handle a single connection on its own thread
void Webserver::handle_connection(tcp::socket socket)
{
	try
	{
		beast::flat_buffer buffer;
		http::request<http::string_body> req;
		http::read(socket, buffer, req);

		Output::send<LogLevel::Verbose>(
			STR("[{}] Processing {} request {}\n"),
			ModName,
			to_wstring(static_cast<std::string>(req.method_string())),
			to_wstring(static_cast<std::string>(req.target())));

		// Check if this is an SSE request
		if (req.method() == http::verb::get && req.target() == "/events/stream")
		{
			// Limit SSE connections to prevent pool thread exhaustion
			if (m_sse_count >= MAX_SSE_CONNECTIONS)
			{
				Output::send<LogLevel::Warning>(
					STR("[{}] SSE connection rejected: {} active (max {})\n"),
					ModName, m_sse_count.load(), MAX_SSE_CONNECTIONS);
				http::response<http::string_body> err_res;
				err_res.result(http::status::service_unavailable);
				err_res.set(http::field::content_type, "text/plain");
				err_res.body() = "Too many SSE connections";
				err_res.prepare_payload();
				http::write(socket, err_res);
				return;
			}

			// RAII SSE counter
			m_sse_count++;
			try {
				handle_sse_connection(socket, req);
			} catch (...) {}
			m_sse_count--;
			return;
		}

		// Normal request handling
		http::response<http::string_body> res;
		res.body() = handle_request(req, res);
		res.set(http::field::content_type, "application/json");
		res.prepare_payload();
		http::write(socket, res);
	}
	catch (const beast::system_error& se)
	{
		// Connection closed or reset — normal for SSE disconnects
		if (se.code() != beast::errc::not_connected &&
			se.code() != asio::error::connection_reset &&
			se.code() != asio::error::broken_pipe)
		{
			Output::send<LogLevel::Warning>(
				STR("[{}] Connection error: {}\n"),
				ModName,
				to_wstring(se.code().message()));
		}
	}
	catch (const std::exception& e)
	{
		Output::send<LogLevel::Error>(
			STR("[{}] Connection handler error: {}\n"),
			ModName,
			to_wstring(e.what()));
	}
}

// Handle SSE stream — blocks until client disconnects or shutdown
void Webserver::handle_sse_connection(tcp::socket& socket, http::request<http::string_body>& req)
{
	Output::send<LogLevel::Verbose>(STR("[{}] SSE client connected\n"), ModName);

	// Send SSE response headers
	http::response<http::empty_body> res;
	res.result(http::status::ok);
	res.set(http::field::content_type, "text/event-stream");
	res.set(http::field::cache_control, "no-cache");
	res.set(http::field::connection, "keep-alive");
	res.set("X-Accel-Buffering", "no"); // Disable proxy buffering
	res.keep_alive(true);

	http::response_serializer<http::empty_body> sr{res};
	http::write_header(socket, sr);

	auto boot_epoch = EventManager::Get().GetBootEpoch();

	// Check for Last-Event-ID for replay.
	// Format is "epoch:seq". We must verify the epoch matches our current boot_epoch.
	uint64_t last_seq = 0;
	uint64_t request_epoch = 0;
	auto it = req.find("Last-Event-ID");
	if (it != req.end())
	{
		try
		{
			auto val = std::string(it->value());
			auto colon = val.find(':');
			if (colon != std::string::npos)
			{
				request_epoch = std::stoull(val.substr(0, colon));
				last_seq = std::stoull(val.substr(colon + 1));
			}
			else
			{
				last_seq = std::stoull(val);  // backward compat: plain integer
			}
			Output::send<LogLevel::Verbose>(
				STR("[{}] SSE client reconnecting from seq {}\n"), ModName, last_seq);
		}
		catch (...)
		{
			// Invalid Last-Event-ID, start from beginning of buffer
			last_seq = 0;
		}
	}

	// If the client's epoch doesn't match our boot epoch, it's asking for a sequence
	// from a previous server run. Ignore it and replay from our current buffer.
	if (request_epoch > 0 && request_epoch != boot_epoch)
	{
		Output::send<LogLevel::Verbose>(
			STR("[{}] SSE client epoch mismatch. Expected {}, got {}. Resetting sequence to 0.\n"), 
			ModName, boot_epoch, request_epoch);
		last_seq = 0;
	}

	// Replay any buffered events
	auto buffered = EventManager::Get().GetEventsSince(last_seq);
	if (!buffered.empty() && last_seq > 0)
	{
		// Check if we may have missed events (gap between last_seq and oldest buffered)
		if (buffered.front().seq > last_seq + 1)
		{
			std::string comment = ": missed_events\n\n";
			boost::system::error_code ec;
			asio::write(socket, asio::buffer(comment), ec);
			if (ec) return;
		}
	}
	for (const auto& entry : buffered)
	{
		std::string sse_frame = std::format("id: {}:{}\ndata: {}\n\n",
			boot_epoch, entry.seq, json::serialize(entry.data));

		boost::system::error_code ec;
		asio::write(socket, asio::buffer(sse_frame), ec);
		if (ec)
		{
			Output::send<LogLevel::Verbose>(
				STR("[{}] SSE client disconnected during replay\n"), ModName);
			return;
		}
		last_seq = entry.seq;
	}

	// Main SSE loop — wait for new events and push them
	while (true)
	{
		auto events = EventManager::Get().WaitForEvents(last_seq);

		if (events.empty())
		{
			if (EventManager::Get().IsShutdown())
			{
				Output::send<LogLevel::Verbose>(
					STR("[{}] SSE connection closing (shutdown)\n"), ModName);
				return;
			}

			// Timeout — send heartbeat to keep connection alive
			std::string heartbeat = ": heartbeat\n\n";
			boost::system::error_code ec;
			asio::write(socket, asio::buffer(heartbeat), ec);
			if (ec)
			{
				Output::send<LogLevel::Verbose>(
					STR("[{}] SSE client disconnected during heartbeat\n"), ModName);
				return;
			}
			continue;
		}

		for (const auto& entry : events)
		{
			std::string sse_frame = std::format("id: {}:{}\ndata: {}\n\n",
				boot_epoch, entry.seq, json::serialize(entry.data));

			boost::system::error_code ec;
			asio::write(socket, asio::buffer(sse_frame), ec);
			if (ec)
			{
				Output::send<LogLevel::Verbose>(
					STR("[{}] SSE client disconnected\n"), ModName);
				return;
			}
			last_seq = entry.seq;
		}
	}
}

// Function to handle incoming HTTP requests (non-SSE routes)
std::string Webserver::handle_request(http::request<http::string_body> req, http::response<http::string_body>& res) {

	json::object response_json;
	http::status statusCode = http::status::ok;

	for (auto response : responses)
	{
		if (response->IsMatchingRequest(req)) {
			response_json = response->GetResponseJson(req, statusCode);
			res.result(statusCode);
			return json::serialize(response_json);
		}
	}

	if (req.target() == "/status") {
		response_json["message"] = "mods management server is running";
		res.result(statusCode);
		return json::serialize(response_json);
	}

	response_json["error"] = std::format("Route not found: {} {}",
		std::string(req.method_string()),
		std::string(req.target()));
	statusCode = http::status::not_found;
	res.result(statusCode);
	return json::serialize(response_json);
}
