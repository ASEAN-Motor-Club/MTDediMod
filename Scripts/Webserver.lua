--------  To Do:  ------------
-- 405 response needs to add allowed methods header

local statics = require("Statics")
local json = require("JsonParser")
local auth = os.getenv("MOD_SERVER_PASSWORD")
local mime = require("mime")
local bcrypt = RequireSafe("bcrypt")

local enableDebug = statics.ModLogLevel > 2

---@enum (key) RequestMethod
local _method = {
    GET = "GET",
    POST = "POST",
    PUT = "PUT",
    DELETE = "DELETE",
    PATCH = "PATCH",
    HEAD = "HEAD",
}

---@enum MimeType
local _mimeType = {
    json = "application/json",
    plaintext = "text/plain"
}

---Request handler for the specified path
---@alias RequestPathHandler fun(session: table): resContent: string|table?, resType: MimeType?, resCode: integer?

---@class RequestPathHandlerTable
---@field path string
---@field method RequestMethod
---@field handler RequestPathHandler
---@field authenticate boolean
---@field asyncSafe boolean
local RequestPathHandlerTable = {}
RequestPathHandlerTable.__index = RequestPathHandlerTable

---Create a new request handler
---@param path string
---@param method RequestMethod
---@param handler RequestPathHandler
---@param asyncSafe boolean?
---@return RequestPathHandlerTable
function RequestPathHandlerTable.new(path, method, handler, asyncSafe)
    local obj = setmetatable({}, RequestPathHandlerTable)
    obj.path = path
    obj.method = method
    obj.handler = handler
    obj.authenticate = true
    obj.asyncSafe = asyncSafe or false
    return obj
end

local handlers = {} ---@type RequestPathHandlerTable[]

---Find a handler index by path and method
---@param path string Request path
---@param method RequestMethod Request method i.e. GET, POST, etc.
local function findHandlerIndex(path, method)
    for i, h in ipairs(handlers) do
        if path == h.path then
            if method == h.method then
                return i
            end
        end
    end
    return nil
end

---Find a handler by path and methods
---@param path string Request path
---@param method? RequestMethod
---@return RequestPathHandlerTable|nil
local function findHandler(path, method)
    for i, h in ipairs(handlers) do
        local base = string.gsub(h.path, "%*", "[^/]*")
        local pat = string.format("^%s$", base)
        if string.find(path, pat) == 1 then
            if method == nil or h.method == "*" or method == h.method then
                if enableDebug then
                    LogOutput("DEBUG", "Match for %s", h.path)
                end
                return h
            end
        end
    end
    return nil
end

---Authenticate header if applicable
---@param session table
local function authenticateSession(session)
    if not auth then
        return true
    end

    local headerAuth = session.headers["authorization"] or nil
    if headerAuth then
        local basicAuth = string.match(headerAuth, "Basic (.+)")
        if bcrypt then
            if bcrypt.verify(auth, basicAuth) then
                return true
            end
        else
            return basicAuth == mime.b64(auth)
        end
    end

    LogOutput("DEBUG", "Unauthenticated session")
    return false
end

---Parse a path into components
---@param path string
---@return string[]
local function parsePath(path)
    local parts = {}
    for part in string.gmatch(path, "([^/]+)") do
        table.insert(parts, part)
    end
    return parts
end

---Dispatch a request from the C++ LuaHttpServer.
---Runs on the game thread.
---@param method string
---@param path string
---@param query_json string
---@param headers_json string
---@param body string?
---@return integer status_code
---@return string? body
---@return string? content_type
_G.__CppDispatchRequest = function(method, path, query_json, headers_json, body)
    local query = json.parse(query_json) or {}
    local headers = json.parse(headers_json) or {}

    local session = {
        method = method,
        urlString = path,
        urlComponents = { path = path },
        pathComponents = parsePath(path),
        queryComponents = query,
        headers = headers,
        content = body,
        version = "HTTP/1.1",
    }

    local h = findHandler(path, method)
    if h then
        if h.authenticate and not authenticateSession(session) then
            return 401, nil, nil
        end

        local ok, content, mime, code = pcall(h.handler, session)
        if ok then
            local response_body = content
            if type(content) == "table" then
                local strOk, strResult = pcall(json.stringify, content)
                if strOk then
                    response_body = strResult
                else
                    return 500, json.stringify({error = "JSON stringify failed"}), "application/json"
                end
            end
            return code or 200, response_body, mime or "application/json"
        else
            local errMsg = content or "Unknown error"
            LogOutput("ERROR", "Handler error: %s", errMsg)
            local jsonOk, jsonErr = pcall(json.stringify, {error = errMsg})
            if jsonOk then
                return 500, jsonErr, "application/json"
            else
                return 500, '{"error":"Internal server error"}', "application/json"
            end
        end
    else
        local any = findHandler(path, nil)
        if any then
            return 405, nil, nil
        else
            return 404, nil, nil
        end
    end
end

---Register a new handler for the specified path and method
---@param path string pattern to match (e.g. `/api/status`)
---@param method RequestMethod request type (e.g. `GET`, `POST`)
---@param handler RequestPathHandler request handler function
---@param asyncSafe boolean? Kept for compatibility; ignored.
local function registerHandler(path, method, handler, asyncSafe)
    local h = RequestPathHandlerTable.new(path, method, handler, asyncSafe)
    local i = findHandlerIndex(path, method)
    if i == nil then
        table.insert(handlers, h)
    else
        handlers[i] = h
    end
end

---Start the web server
---@param bindHost string? Host IP to bind to
---@param bindPort number? Port to bind to
local function run(bindHost, bindPort)
    bindHost = bindHost or "*"
    bindPort = bindPort or 5001

    registerHandler("/stop", "POST", function(session)
        return { status = "ok" }, nil, 201
    end)

    LogOutput("INFO", "Lua HTTP handlers registered (C++ server on %s:%d)", bindHost, bindPort)
end

local WebserverInstance = {
    run = run,
    registerHandler = registerHandler
}

if not _G.Webserver then
    _G.Webserver = WebserverInstance
end

return _G.Webserver
