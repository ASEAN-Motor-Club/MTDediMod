#pragma once

#include <boost/asio.hpp>
#include <boost/beast.hpp>
#include <boost/json.hpp>
#include <lua.hpp>
#include <atomic>
#include <chrono>
#include <condition_variable>
#include <cstdint>
#include <mutex>
#include <string>
#include <thread>
#include <unordered_map>
#include <vector>

namespace asio = boost::asio;
namespace beast = boost::beast;
namespace http = beast::http;
using tcp = asio::ip::tcp;
namespace json = boost::json;

// Non-blocking HTTP server that delegates request handling to Lua on the game thread.
// C++ owns all socket I/O; Lua only sees __CppDispatchRequest() called from the
// UE4SS engine tick hook (game thread) while holding LuaMod::m_thread_actions_mutex.
class LuaHttpServer
{
public:
	static LuaHttpServer* Get();
	~LuaHttpServer();

	void Start(int port);
	void Stop();
	void SetLuaState(lua_State* L);
	void RegisterEngineTickHook();
	void UnregisterEngineTickHook();

private:
	struct Request
	{
		uint64_t id;
		std::string method;
		std::string path;
		json::object query;
		json::object headers;
		std::string body;
	};

	struct Response
	{
		int status_code = 200;
		std::string body;
		std::string content_type = "application/json";
	};

	static constexpr size_t MAX_BODY_SIZE = 1024 * 1024; // 1 MiB
	static constexpr size_t MAX_PER_TICK = 1;
	static constexpr size_t MAX_PENDING = 64;
	static constexpr std::chrono::milliseconds MAX_TICK_BUDGET{2}; // warn if a handler exceeds this

	std::mutex mtx_;
	std::condition_variable cv_;
	std::vector<Request> pending_;
	std::unordered_map<uint64_t, Response> completed_;
	std::atomic<uint64_t> next_id_{1};
	std::atomic<bool> shutdown_{false};
	std::atomic<bool> started_{false};

	// Accepting state: acceptor_ptr_ is non-null while running.
	// The actual acceptor lives on the stack of RunAcceptor() so it is always valid.
	tcp::acceptor* acceptor_ptr_ = nullptr;
	std::thread acceptor_thread_;
	asio::thread_pool pool_{8};

	// Lua state and tick hook state
	lua_State* lua_state_ = nullptr;
	uint64_t tick_callback_id_ = 0;
	std::atomic<bool> tick_hook_registered_{false};

	void RunAcceptor(int port);
	void HandleConnection(tcp::socket socket);
	void DispatchOnGameThread();
};
