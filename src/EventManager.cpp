#include "EventManager.h"

EventManager& EventManager::Get()
{
    static EventManager instance;
    return instance;
}

void EventManager::AddEvent(json::object event)
{
    {
        std::lock_guard<std::mutex> lock(m_mutex);

        BufferedEvent entry{m_next_seq++, std::move(event)};
        m_ring_buffer.push_back(std::move(entry));

        // Evict oldest if over capacity
        while (m_ring_buffer.size() > MAX_BUFFER_SIZE)
        {
            m_ring_buffer.pop_front();
        }
    }
    // Wake all SSE threads waiting for events
    m_cv.notify_all();
}

std::vector<BufferedEvent> EventManager::GetEventsSince(uint64_t last_seq)
{
    std::lock_guard<std::mutex> lock(m_mutex);

    std::vector<BufferedEvent> result;
    for (const auto& entry : m_ring_buffer)
    {
        if (entry.seq > last_seq)
        {
            result.push_back(entry);
        }
    }
    return result;
}

std::vector<BufferedEvent> EventManager::WaitForEvents(uint64_t last_seq)
{
    std::unique_lock<std::mutex> lock(m_mutex);

    m_cv.wait(lock, [&] {
        return m_shutdown || m_next_seq > last_seq + 1;
    });

    if (m_shutdown)
    {
        return {};
    }

    std::vector<BufferedEvent> result;
    for (const auto& entry : m_ring_buffer)
    {
        if (entry.seq > last_seq)
        {
            result.push_back(entry);
        }
    }
    return result;
}

json::array EventManager::GetBufferedEventsJson()
{
    std::lock_guard<std::mutex> lock(m_mutex);

    json::array events;
    for (const auto& entry : m_ring_buffer)
    {
        events.push_back(entry.data);
    }
    return events;
}

void EventManager::Shutdown()
{
    {
        std::lock_guard<std::mutex> lock(m_mutex);
        m_shutdown = true;
    }
    m_cv.notify_all();
}