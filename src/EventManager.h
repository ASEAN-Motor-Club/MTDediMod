#pragma once
#include <boost/json.hpp>
#include <mutex>
#include <vector>

namespace json = boost::json;

// A thread-safe singleton to manage the event queue
class EventManager
{
public:
    static EventManager& Get();
    void AddEvent(json::object event);
    json::array GetAndClearEvents();

private:
    EventManager() = default; // Private constructor for singleton
    std::vector<json::object> m_event_queue;
    std::mutex m_queue_mutex;
};