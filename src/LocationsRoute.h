#pragma once
#include "webroute.h"

struct LocationSnapshot;

// Serialize a LocationSnapshot into the canonical JSON shape used by both
// the /players/locations GET endpoint and the /players/locations/stream
// SSE frame body. Kept in this TU so there is exactly one source of truth.
json::object LocationSnapshotToJson(const LocationSnapshot& snap);

// GET /players/locations — non-streaming JSON snapshot of the latest
// player location batch published by LocationSampler via LocationBroadcaster.
//
// Response shape:
// {
//   "seq": <uint64>,
//   "timestamp_ms": <uint64>,
//   "boot_epoch": <uint64>,
//   "count": <int>,
//   "entries": [
//     {
//       "character_guid": "...",
//       "location": { "x": 0.0, "y": 0.0, "z": 0.0 },
//       "yaw": 0.0,
//       "vehicle_key": "",
//       "rpm": 0.0,
//       "gear": 0,
//       "velocity": { "x": 0.0, "y": 0.0, "z": 0.0 }
//     }
//   ]
// }
//
// Returns an empty entries array with seq=0 if no snapshot has been
// published yet (server still starting up).
class LocationsRoute : public Route
{
public:
    LocationsRoute() = default;
    bool IsMatchingRequest(http::request<http::string_body> req) override;
    json::object GetResponseJson(http::request<http::string_body> req, http::status& statusCode) override;
};
