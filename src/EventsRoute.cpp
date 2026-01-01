#include "EventsRoute.h"
#include "EventManager.h"
#include <fmt/format.h>

// Match requests specifically for the "/events" endpoint
bool EventsRoute::IsMatchingRequest(http::request<http::string_body> req)
{
    return req.target() == "/events";
}

// On a match, get events from the manager and return them as JSON
json::object EventsRoute::GetResponseJson(http::request<http::string_body> req, http::status& statusCode)
{
    json::object response;
    
    // Only allow GET requests for events
    if (req.method() != http::verb::get) {
        statusCode = http::status::method_not_allowed;
        response["error"] = fmt::format("Method {} not allowed for /events", 
                                        std::string(req.method_string()));
        return response;
    }
    
    // Retrieve and clear all pending events from the manager
    json::array events = EventManager::Get().GetAndClearEvents();
    response["events"] = events;

    statusCode = http::status::ok;
    return response;
}