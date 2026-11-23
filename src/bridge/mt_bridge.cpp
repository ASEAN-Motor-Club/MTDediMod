// mt_bridge.cpp — implementation of the C ABI declared in mt_bridge.h.
//
// Deliberately dependency-free: plain Win32/STL, no UE4SS headers, no Lua.
// Anything that touches Lua lives in BridgeHost.cpp (the UE4SS host mod);
// this module only owns the thread-safe queue + state snapshot that Rust and
// the host mod share.

#include "mt_bridge.h"

#include <cstddef>
#include <cstdio>
#include <deque>
#include <mutex>
#include <new>
#include <string>

namespace
{
    // One mutex guards both the command queue and the state snapshot. All
    // critical sections are short (string moves only), so contention between
    // the Rust render thread and the game-thread drain is negligible.
    std::mutex g_mutex;
    std::deque<std::string> g_queue;
    std::string g_state;

    constexpr size_t kMaxCommandBytes = 16 * 1024;
    constexpr size_t kMaxQueueItems = 256;

    int clamp_len(const char* json, int len, size_t& out_len)
    {
        if (!json) return -1;
        size_t n;
        if (len < 0) return -1;
        if (len == 0)
        {
            n = std::char_traits<char>::length(json);
        }
        else
        {
            n = static_cast<size_t>(len);
        }
        if (n == 0) return -1;
        if (n > kMaxCommandBytes) return -1;
        out_len = n;
        return 0;
    }
} // namespace

MT_BRIDGE_API int mt_bridge_ready(void)
{
    return 1;
}

MT_BRIDGE_API int mt_bridge_submit(const char* json, int len)
{
    try
    {
        size_t n = 0;
        if (clamp_len(json, len, n) != 0) return -1;
        std::string item(json, n);
        std::lock_guard<std::mutex> lock(g_mutex);
        if (g_queue.size() >= kMaxQueueItems)
        {
            // The game thread is not draining (handler not registered yet, or
            // wedged). Drop the OLDEST command so fresh UI input still flows.
            g_queue.pop_front();
        }
        g_queue.push_back(std::move(item));
        return 0;
    }
    catch (...)
    {
        return -1;
    }
}

MT_BRIDGE_API int mt_bridge_set_state(const char* json, int len)
{
    try
    {
        size_t n = 0;
        if (clamp_len(json, len, n) != 0) return -1;
        std::string snapshot(json, n);
        std::lock_guard<std::mutex> lock(g_mutex);
        g_state = std::move(snapshot);
        return 0;
    }
    catch (...)
    {
        return -1;
    }
}

MT_BRIDGE_API int mt_bridge_get_state(char* out, int cap)
{
    try
    {
        if (!out || cap <= 0) return -1;
        std::lock_guard<std::mutex> lock(g_mutex);
        const size_t needed = g_state.size() + 1;
        if (g_state.empty()) return 0;
        if (static_cast<size_t>(cap) < needed) return -static_cast<int>(needed);
        g_state.copy(out, g_state.size());
        out[g_state.size()] = '\0';
        return static_cast<int>(g_state.size());
    }
    catch (...)
    {
        return -1;
    }
}

MT_BRIDGE_API void mt_bridge_set_cursor(int visible)
{
    try
    {
        std::string cmd = visible ? R"({"op":"set_cursor_visible","value":true})"
                                  : R"({"op":"set_cursor_visible","value":false})";
        std::lock_guard<std::mutex> lock(g_mutex);
        if (g_queue.size() >= kMaxQueueItems) g_queue.pop_front();
        g_queue.push_back(std::move(cmd));
    }
    catch (...)
    {
        // Swallow: a lost cursor toggle is recoverable on the next toggle.
    }
}

MT_BRIDGE_API int mt_bridge_internal_pop(char* out, int cap)
{
    try
    {
        if (!out || cap <= 0) return -1;
        std::lock_guard<std::mutex> lock(g_mutex);
        if (g_queue.empty()) return 0;
        std::string& front = g_queue.front();
        if (front.size() + 1 > static_cast<size_t>(cap))
        {
            // Too small a buffer would corrupt the dispatcher contract;
            // drop the oversized item and report the required size.
            int needed = static_cast<int>(front.size()) + 1;
            g_queue.pop_front();
            return -needed;
        }
        int n = static_cast<int>(front.size());
        front.copy(out, front.size());
        out[front.size()] = '\0';
        g_queue.pop_front();
        return n;
    }
    catch (...)
    {
        return -1;
    }
}

#ifdef MT_BRIDGE_ADMIN
MT_BRIDGE_API int mt_bridge_admin_build(void)
{
    return 1;
}
#endif
