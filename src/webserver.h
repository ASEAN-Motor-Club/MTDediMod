// Workaround against multiple check definitions
#pragma push_macro("check")
#undef check
#include <boost/beast.hpp>
#pragma pop_macro("check")
#include <boost/asio.hpp>
#include <boost/thread.hpp>
#include <atomic>
#include <list>
#include <memory>

namespace asio = boost::asio;
namespace beast = boost::beast;
namespace http = beast::http;
using tcp = asio::ip::tcp;

class Route;

// Simple HTTP server with fixed thread pool
class Webserver
{
	std::wstring ModName;
	int Port = 5000;
	boost::thread serverThread;
	std::list<std::shared_ptr<Route>> responses;

	// Fixed thread pool to bound Wine pipe FD growth.
	// 4 workers: 1 for SSE + 3 for burst HTTP requests.
	asio::thread_pool m_pool{4};

	// Track active SSE connections to prevent pool exhaustion
	std::atomic<int> m_sse_count{0};
	static constexpr int MAX_SSE_CONNECTIONS = 2;

public:
	Webserver();
	~Webserver();

	// Get current instance of webserver
	static Webserver* Get();

	// Check if the server is still running
	bool isServerRunning();

private:
	// HTTP Server function
	void run_server(unsigned short port);

	// Handle a single connection on its own thread
	void handle_connection(tcp::socket socket);

	// Function to handle incoming HTTP requests (non-SSE)
	std::string handle_request(http::request<http::string_body> req, http::response<http::string_body>& res);

	// Handle SSE stream connection (blocks until client disconnects or shutdown)
	void handle_sse_connection(tcp::socket& socket, http::request<http::string_body>& req);
};
