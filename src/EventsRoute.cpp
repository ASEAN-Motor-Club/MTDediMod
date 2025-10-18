#include "EventsRoute.h"
#include "EventManager.h"

// Match requests specifically for the "/events" endpoint
bool EventsRoute::IsMatchingRequest(http::request<http::string_body> req)
{
    return req.target() == "/events";
}

// On a match, get events from the manager and return them as JSON
json::object EventsRoute::GetResponseJson(http::request<http::string_body> req, http::status& statusCode)
{
    // Retrieve and clear all pending events from the manager
    //json::array events = EventManager::Get().GetAndClearEvents();

    json::object response;
    //response["events"] = events;

    statusCode = http::status::ok;
    return response;
}