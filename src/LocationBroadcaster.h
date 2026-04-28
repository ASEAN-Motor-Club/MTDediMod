#pragma once
#include <atomic>
#include <chrono>
#include <condition_variable>
#include <cstdint>
#include <ctime>
#include <memory>
#include <mutex>
#include <string>
#include <vector>

// Single-entry player location record sampled each tick.
// Coordinates are Unreal world units (centimeters).
struct PlayerLocation
{
    std::string character_guid; // 32-char uppercase hex; empty if resolution failed
    float x = 0.0f;
    float y = 0.0f;
    float z = 0.0f;
    float yaw = 0.0f;           // degrees in [-180, 180]; 0 if pawn is null
    std::string vehicle_key;    // empty = on foot
    float rpm = 0.0f;           // 0 when on foot or engine not available
    int8_t gear = 0;            // 0 = neutral / on foot
    float vx = 0.0f;            // velocity X (Unreal cm/s); 0 when on foot
    float vy = 0.0f;            // velocity Y
    float vz = 0.0f;            // velocity Z
};

struct LocationSnapshot
{
    uint64_t seq = 0;              // monotonic, per-broadcaster
    uint64_t timestamp_ms = 0;     // wall-clock ms at capture time
    uint64_t boot_epoch = 0;       // inherited from broadcaster; constant across a run
    std::vector<PlayerLocation> entries;
};

// Thread-safe singleton that holds the latest LocationSnapshot and wakes
// blocked SSE readers when a new snapshot is published.
//
// Writer (game thread, LocationSampler::Tick) calls Publish once per
// sampling interval. Readers (asio HTTP threads) call GetLatest() for a
// non-blocking snapshot or WaitForNewer() to block until a new snapshot is
// available or the timeout expires.
class LocationBroadcaster
{
public:
    static LocationBroadcaster& Get();

    uint64_t GetBootEpoch() const { return m_boot_epoch; }

    // Called from game thread. Takes ownership of `snap` and notifies readers.
    // `snap` must be non-null; seq / timestamp_ms / boot_epoch must already be set.
    void Publish(std::shared_ptr<const LocationSnapshot> snap);

    // Lock-free latest-snapshot load (may return nullptr before first publish).
    std::shared_ptr<const LocationSnapshot> GetLatest() const;

    // Reserve and return the next sequence number. Used by the sampler so the
    // snapshot carries a seq before Publish is called.
    uint64_t NextSeq() { return m_next_seq.fetch_add(1, std::memory_order_relaxed); }

    // Block until a snapshot with seq > last_seq is available, or timeout,
    // or Shutdown. Returns the current latest snapshot (may still have
    // seq <= last_seq on timeout or shutdown — caller checks).
    std::shared_ptr<const LocationSnapshot> WaitForNewer(
        uint64_t last_seq,
        std::chrono::milliseconds timeout);

    // Wake all SSE connections so they drop out of WaitForNewer before teardown.
    void Shutdown();
    bool IsShutdown() const { return m_shutdown.load(std::memory_order_acquire); }

private:
    LocationBroadcaster()
        : m_boot_epoch(static_cast<uint64_t>(std::time(nullptr)))
    {}

    // std::atomic<std::shared_ptr<T>> (C++20) gives a lock-free pointer
    // load/store. If the toolchain does not support it we fall back to a
    // mutex-guarded shared_ptr in .cpp.
    mutable std::mutex m_latest_mtx;
    std::shared_ptr<const LocationSnapshot> m_latest;

    std::mutex m_cv_mtx;
    std::condition_variable m_cv;

    uint64_t m_boot_epoch;
    std::atomic<uint64_t> m_next_seq{1};
    std::atomic<bool> m_shutdown{false};
};
