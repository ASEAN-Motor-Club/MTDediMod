#include "LocationBroadcaster.h"

LocationBroadcaster& LocationBroadcaster::Get()
{
    static LocationBroadcaster instance;
    return instance;
}

void LocationBroadcaster::Publish(std::shared_ptr<const LocationSnapshot> snap)
{
    if (!snap) return;

    {
        std::lock_guard<std::mutex> lock(m_latest_mtx);
        m_latest = std::move(snap);
    }

    // Wake every SSE connection blocked in WaitForNewer.
    // Holding m_cv_mtx briefly is necessary to avoid a lost-wakeup between
    // the reader's predicate check and its wait.
    {
        std::lock_guard<std::mutex> lock(m_cv_mtx);
    }
    m_cv.notify_all();
}

std::shared_ptr<const LocationSnapshot> LocationBroadcaster::GetLatest() const
{
    std::lock_guard<std::mutex> lock(m_latest_mtx);
    return m_latest;
}

std::shared_ptr<const LocationSnapshot> LocationBroadcaster::WaitForNewer(
    uint64_t last_seq,
    std::chrono::milliseconds timeout)
{
    {
        auto snap = GetLatest();
        if (snap && snap->seq > last_seq) return snap;
        if (m_shutdown.load(std::memory_order_acquire)) return snap;
    }

    std::unique_lock<std::mutex> lock(m_cv_mtx);
    m_cv.wait_for(lock, timeout, [&] {
        if (m_shutdown.load(std::memory_order_acquire)) return true;
        auto s = GetLatest();
        return s && s->seq > last_seq;
    });

    return GetLatest();
}

void LocationBroadcaster::Shutdown()
{
    m_shutdown.store(true, std::memory_order_release);
    {
        std::lock_guard<std::mutex> lock(m_cv_mtx);
    }
    m_cv.notify_all();
}
