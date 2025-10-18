#pragma once
#include "webroute.h"

class EventsRoute : public Route
{
public:
    EventsRoute() = default;
    bool IsMatchingRequest(http::request<http::string_body> req) override;
    json::object GetResponseJson(http::request<http::string_body> req, http::status& statusCode) override;
};