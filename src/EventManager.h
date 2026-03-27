#pragma once
#include <boost/json.hpp>
#include <chrono>
#include <condition_variable>
#include <cstdint>
#include <ctime>
#include <deque>
#include <mutex>
#include <vector>

namespace json = boost::json;

struct BufferedEvent
{
    uint64_t seq;
    json::object data;
};

// Thread-safe singleton managing event buffering and SSE broadcast
class EventManager
{
public:
    static constexpr size_t MAX_BUFFER_SIZE = 256;

    static EventManager& Get();

    // Boot epoch: seconds since Unix epoch when this EventManager was created.
    // Used to prefix SSE event IDs so clients can detect server restarts.
    uint64_t GetBootEpoch() const { return m_boot_epoch; }

    // Add an event to the ring buffer and wake SSE listeners.
    // Called from UE4 game thread (hook callbacks).
    void AddEvent(json::object event);

    // Return all buffered events with seq > last_seq.
    // Non-blocking snapshot — used by GET /events and SSE replay.
    std::vector<BufferedEvent> GetEventsSince(uint64_t last_seq);

    // Block until new events arrive with seq > last_seq, or timeout expires.
    // Returns the new events. Used by SSE connection threads.
    // Returns empty vector on timeout or shutdown.
    std::vector<BufferedEvent> WaitForEvents(uint64_t last_seq, std::chrono::seconds timeout = std::chrono::seconds(30));

    // Check if shutdown has been signaled.
    bool IsShutdown() const { return m_shutdown; }

    // Legacy: retrieve all buffered events as a JSON array (non-destructive).
    // Unlike the old GetAndClearEvents(), this does NOT drain the buffer.
    json::array GetBufferedEventsJson();

    // Signal all waiting SSE threads to stop (for shutdown).
    void Shutdown();

private:
    EventManager() : m_boot_epoch(static_cast<uint64_t>(std::time(nullptr))) {}

    std::deque<BufferedEvent> m_ring_buffer;
    uint64_t m_next_seq = 1;
    uint64_t m_boot_epoch;
    bool m_shutdown = false;

    std::mutex m_mutex;
    std::condition_variable m_cv;
};