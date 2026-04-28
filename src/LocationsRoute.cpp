#include "LocationsRoute.h"
#include "LocationBroadcaster.h"
#include <format>

// Serialize a LocationSnapshot into the canonical JSON shape used by both the
// /players/locations snapshot GET and the /players/locations/stream SSE frame.
// Kept as a free function so webserver.cpp can emit identical frames.
json::object LocationSnapshotToJson(const LocationSnapshot& snap)
{
    json::object obj;
    obj["seq"] = snap.seq;
    obj["timestamp_ms"] = snap.timestamp_ms;
    obj["boot_epoch"] = snap.boot_epoch;
    obj["count"] = static_cast<int64_t>(snap.entries.size());

    json::array entries;
    entries.reserve(snap.entries.size());
    for (const auto& e : snap.entries)
    {
        json::object eobj;
        eobj["character_guid"] = e.character_guid;
        json::object loc;
        loc["x"] = e.x;
        loc["y"] = e.y;
        loc["z"] = e.z;
        eobj["location"] = std::move(loc);
        eobj["yaw"] = e.yaw;
        eobj["vehicle_key"] = e.vehicle_key;
        eobj["rpm"] = e.rpm;
        eobj["gear"] = static_cast<int64_t>(e.gear);
        json::object vel;
        vel["x"] = e.vx;
        vel["y"] = e.vy;
        vel["z"] = e.vz;
        eobj["velocity"] = std::move(vel);
        entries.push_back(std::move(eobj));
    }
    obj["entries"] = std::move(entries);
    return obj;
}

bool LocationsRoute::IsMatchingRequest(http::request<http::string_body> req)
{
    auto target = req.target();
    return target == "/players/locations" || target.starts_with("/players/locations?");
}

json::object LocationsRoute::GetResponseJson(http::request<http::string_body> req, http::status& statusCode)
{
    json::object response;

    if (req.method() != http::verb::get)
    {
        statusCode = http::status::method_not_allowed;
        response["error"] = std::format(
            "Method {} not allowed for /players/locations",
            std::string(req.method_string()));
        return response;
    }

    auto snap = LocationBroadcaster::Get().GetLatest();
    if (!snap)
    {
        // Server is still warming up; return a valid but empty payload.
        response["seq"] = 0;
        response["timestamp_ms"] = 0;
        response["boot_epoch"] = LocationBroadcaster::Get().GetBootEpoch();
        response["count"] = 0;
        response["entries"] = json::array();
        statusCode = http::status::ok;
        return response;
    }

    statusCode = http::status::ok;
    return LocationSnapshotToJson(*snap);
}
