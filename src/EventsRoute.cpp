#include "EventsRoute.h"
#include "EventManager.h"
#include <format>

// Match requests specifically for the "/events" endpoint
bool EventsRoute::IsMatchingRequest(http::request<http::string_body> req)
{
    return req.target() == "/events";
}

// On a match, return buffered events as JSON (non-destructive snapshot)
json::object EventsRoute::GetResponseJson(http::request<http::string_body> req, http::status& statusCode)
{
    json::object response;
    
    // Only allow GET requests for events
    if (req.method() != http::verb::get) {
        statusCode = http::status::method_not_allowed;
        response["error"] = std::format("Method {} not allowed for /events", 
                                        std::string(req.method_string()));
        return response;
    }
    
    // Parse ?since=<seq> from query string (optional cursor-based polling)
    auto target = std::string(req.target());
    uint64_t since_seq = 0;
    auto qpos = target.find("?since=");
    if (qpos != std::string::npos) {
        try { since_seq = std::stoull(target.substr(qpos + 7)); }
        catch (...) {}
    }

    if (since_seq > 0) {
        auto filtered = EventManager::Get().GetEventsSince(since_seq);
        json::array events;
        for (const auto& entry : filtered) {
            events.push_back(entry.data);
        }
        response["events"] = events;
    } else {
        // Legacy: return full buffer snapshot
        json::array events = EventManager::Get().GetBufferedEventsJson();
        response["events"] = events;
    }

    statusCode = http::status::ok;
    return response;
}