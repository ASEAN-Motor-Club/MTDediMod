#include "modsmanager.h"

#include <UE4SSProgram.hpp>
#include <fmt/format.h>
#include "HookManager.h"

static const char *modsReloadPath = "/mods/reload";

bool ModsManager::IsMatchingRequest(http::request<http::string_body> req) {
  if (req.target().starts_with(modsReloadPath)) {
    return true;
  }
  return false;
}

json::object ModsManager::GetResponseJson(http::request<http::string_body> req,
                                          http::status &statusCode) {
  json::object obj;
  if (req.target() == modsReloadPath) {
    if (req.method() == http::verb::post) {
      // Unregister all hooks before reloading mods to prevent stale callbacks
      HookManager::UnregisterAllHooks();
      UE4SSProgram::get_program().queue_reinstall_mods();
      statusCode = http::status::accepted;
      obj["status"] = "received mods reload signal";
      return obj;
    } else {
      // Path matches but method is not POST
      statusCode = http::status::method_not_allowed;
      obj["error"] = fmt::format("Method {} not allowed for {}", 
                                  std::string(req.method_string()),
                                  std::string(req.target()));
      return obj;
    }
  }
  
  // Path didn't match exactly - shouldn't happen since IsMatchingRequest already checked
  statusCode = http::status::not_found;
  obj["error"] = fmt::format("Route not found: {}", std::string(req.target()));
  return obj;
}
