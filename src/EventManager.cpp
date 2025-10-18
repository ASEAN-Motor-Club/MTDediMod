#include "EventManager.h"

// Provides a single global instance
EventManager& EventManager::Get()
{
    static EventManager instance;
    return instance;
}

// Adds an event to the queue, locking the mutex to prevent race conditions
void EventManager::AddEvent(json::object event)
{
    std::lock_guard<std::mutex> lock(m_queue_mutex);
    m_event_queue.push_back(std::move(event));
}

// Retrieves all events and clears the queue, all within a single lock
json::array EventManager::GetAndClearEvents()
{
    std::lock_guard<std::mutex> lock(m_queue_mutex);
    json::array events;
    for (const auto& evt : m_event_queue)
    {
        events.push_back(evt);
    }
    m_event_queue.clear();
    return events;
}