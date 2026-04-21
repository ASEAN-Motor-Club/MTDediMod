--------  To Do:  --------------
-- Look into respecting a "keep open" request
-- 405 response needs to add allowed methods header
-- Cover more cases that may results in timeout

local socket = require("socket")
local mime = require("mime")
local url = require("socket.url")
local statics = require("Statics")
local json = require("JsonParser")
local auth = os.getenv("MOD_SERVER_PASSWORD")
local usePartialSend = os.getenv("MOD_SERVER_SEND_PARTIAL")
local bcrypt = RequireSafe("bcrypt")

local enableDebug = statics.ModLogLevel > 2
local port = tonumber(os.getenv("MOD_SERVER_PORT")) or 5001
local isServerRunning = false
local time = function()
    return socket.gettime() * 1000
end

-- Hard limits to prevent the webserver from overwhelming the game thread or
-- exceeding FD_SETSIZE (~1024) in socket.select.
local maxClients = 64          -- max concurrent TCP connections
local maxGetInFlight = 10      -- max GET/HEAD callbacks queued on game thread
local getInFlight = 0          -- current GET/HEAD callbacks in flight
local maxSessionAgeMs = 15000  -- force-close connections older than this

---@enum (key) RequestMethod
local _method = {
    GET = "GET",
    POST = "POST",
    PUT = "PUT",
    DELETE = "DELETE",
    PATCH = "PATCH",
}

---@enum (key) ConnectionState
local _state = {
    init = "init",
    header = "header",
    body = "body",
    close = "close"
}

---@enum MimeType
local _mimeType = {
    json = "application/json",
    plaintext = "text/plain"
}

---@class ClientTable
---@field id integer Client connection ID. No two clients should have the same ID unless connections are kept open
---@field client TCPSocketClient
---@field rawHeaders string[] Raw request header pairs in a case-sensitive table
---@field headers table<string,string> Request headers in lowercase keys
---@field method RequestMethod
---@field urlString string Full URL request path
---@field urlComponents table<string,string>?
---@field pathComponents string[] URL request paths separated by `/`
---@field queryComponents table<string,string>
---@field version string HTTP version used in the request
---@field contentLength number? Returns a valid number if content is not empty
---@field content string? Request body
---@field state ConnectionState
---@field connTime number
---@field pendingResponse {content:string|table?,mime:MimeType?,code:integer?}? Response queued by game thread for async send (GET/HEAD only)
local ClientTable = {}
ClientTable.__index = ClientTable

---Create a new client
---@param newId number
---@param client TCPSocketClient
---@return ClientTable
function ClientTable.new(newId, client)
    local obj = setmetatable({}, ClientTable)
    obj.id = newId
    obj.client = client
    obj.state = "init"
    obj.connTime = time()
    obj.queryComponents = {}
    return obj
end

---@enum (key) ResponseStatus
local _resCode = {
    [200] = "200 OK",
    [201] = "201 Created",
    [204] = "204 No Content",
    [400] = "400 Bad Request",
    [401] = "401 Unauthorized",
    [403] = "403 Forbidden",
    [404] = "404 Not Found",
    [405] = "405 Method Not Allowed",
    [500] = "500 Internal Server Error",
    [503] = "503 Service Unavailable"
}

---Request handler for the specified path
---@alias RequestPathHandler fun(session: ClientTable): resContent: string?, resType: MimeType?, resCode: ResponseStatus?

---@class RequestPathHandlerTable
---@field path string
---@field method RequestMethod
---@field handler RequestPathHandler
---@field authenticate boolean
local RequestPathHandlerTable = {}
RequestPathHandlerTable.__index = RequestPathHandlerTable

---Create a new request handler
---@param path string
---@param method RequestMethod
---@param handler RequestPathHandler
---@param authenticate boolean?
---@return RequestPathHandlerTable
function RequestPathHandlerTable.new(path, method, handler, authenticate)
    local obj = setmetatable({}, RequestPathHandlerTable)
    obj.path = path
    obj.method = method
    obj.handler = handler
    if authenticate == nil then
        obj.authenticate = true
    else
        obj.authenticate = authenticate
    end
    return obj
end

local serverString = statics.ModName .. " server " .. statics.ModVersion
local clients = {} ---@type TCPSocketClient[]
local sessions = {} ---@type table<TCPSocketClient, ClientTable>
local nextSessionID = 1
local g_server = nil ---@class TCPSocketServer
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
        local base = string.gsub(h.path, "%*", "[^/]*") -- Turn asterisks into Lua wild patterns (single segment)
        local pat = string.format("^%s$", base)      -- Add anchors to pattern
        if string.find(path, pat) == 1 then
            --if path == h.path then
            if method == nil or h.method == "*" or method == h.method then
                LogOutput("DEBUG", "Match for %s", h.path)
                return h
            end
        end
    end
    return nil
end

---Get a new connecting client
local function getNewClients()
    local client, err = g_server:accept()

    if client == nil then
        if err ~= "timeout" then
            LogOutput("ERROR", "Error from accept: %s", err)
        end
        return
    end

    if #clients >= maxClients then
        LogOutput("WARN", "Connection rejected: client limit reached (%d)", maxClients)
        client:close()
        return
    end

    LogOutput("DEBUG", "Accepted connection from client")
    client:settimeout(1)
    table.insert(clients, client)

    local s = ClientTable.new(nextSessionID, client)
    nextSessionID = nextSessionID + 1
    sessions[client] = s
end

---Build the headers for a normal response
---Content is optional and may be `nil`. If not `nil`, content type must be provided (ex: `application/json`)
---Assumes that the supplied data is JSON format by default
---@param content string? Content of the response
---@param contentType MimeType? Content mime type
---@param resCode ResponseStatus? Response code, defaults to `200 OK`
---@param timestamp integer? Add initial request timestamp in ms
local function buildHeaders(content, contentType, resCode, timestamp)
    contentType = contentType or _mimeType.json
    timestamp = timestamp or -1
    local code = _resCode[resCode or (content and 200) or 204]
    local h = {}

    local function add(name, value)
        table.insert(h, string.format("%s: %s", name, value))
    end

    table.insert(h, "HTTP/1.1 " .. code)

    add("Server", serverString)
    add("Date", os.date("!%a, %d %b %Y %H:%M:%S GMT"))
    add("X-Timestamp", timestamp)
    add("Connection", "close")

    if content then
        add("Content-Length", #content)
        add("Content-type", contentType)
    end

    local header = table.concat(h, "\n") .. "\n\n"
    LogOutput("DEBUG", "Adding header: %s", header)
    return header
end

---Safely mark a session for removal
---@param client ClientTable
local function markSessionForRemoval(client)
    LogOutput("DEBUG", "Marking client %i for removal", client.id)
    client.state = "close"
end

---Helper function to ensure all data is sent
---@param client TCPSocketClient
---@param data string
local function send_all(client, data)
    local total_sent = 0

    local len = #data
    while total_sent < len do
        -- 'send' partial send method doesn't work, so we do our own string sub
        -- 'send' method will send malformed data if exceeds 40 bytes
        local endByte = math.min(total_sent + 42, len)
        local partial = string.sub(data, total_sent + 1, endByte)
        local sent, err, partial_sent_index = client:send(partial)
        if sent == nil then
            -- Handle error (e.g., connection closed, timeout)
            LogOutput("ERROR", "ERROR: Failed to send data: " .. (err or "unknown error"))
            return nil, err -- Return nil and error message
        end
        total_sent = total_sent + sent
        -- If 'sent' is less than the remaining 'data', client:send might have returned only part
        -- In LuaSocket, if 'send' succeeds but sends less than requested, 'sent' will be the actual amount.
        -- The loop naturally handles this by advancing total_sent.
    end
    return total_sent -- Return the total bytes sent on success
end

---Send a response to the clients
---@param client ClientTable
---@param content? string Response body
---@param contentType MimeType? Content mime type. defaults to `application/json`
---@param resCode ResponseStatus? Response code. Defaults to `200 OK`
local function sendResponse(client, content, contentType, resCode)
    LogOutput("DEBUG", "Sending the response")
    local header = buildHeaders(content, contentType, resCode, client.connTime)

    if usePartialSend then
        local sent = send_all(client.client, header)
        LogOutput("DEBUG", "Last byte sent: %i, header size: %i", sent, #header)

        if content then
            local contentSent = send_all(client.client, content)
            LogOutput("DEBUG", "Last byte sent: %i, content size: %i", contentSent, #content)
        end
    else
        local sent, err, sent_index = client.client:send(header .. (content or ""))
        LogOutput("DEBUG", "Last byte sent: %i, size: %i", sent, #header + (content and #content or 0))
    end

    local resDuration = time() - client.connTime
    LogOutput("INFO", "%d %s \"%s\" %.1fms", resCode or 200, client.method, client.urlString, resDuration)
    markSessionForRemoval(client)
end

---Parse the raw headers into a nice name/value dictionary
---@param client ClientTable
local function parseHeaders(client)
    client.headers = {}

    -- TODO: handle a continued header line!
    for _, line in ipairs(client.rawHeaders) do
        local name, value = string.match(line, "(%S+)%s*:%s*(.+)%s*")
        if name ~= nil then
            name = string.lower(name) -- convert to lowercase for simplified access
            client.headers[name] = value
        else
            LogOutput("ERROR", "Malformed header line:\n%s", line)
            return -1
        end
    end

    return 0 -- success
end

---Process request header content
---@param client ClientTable
local function processHeaders(client)
    client.contentLength = 0

    local len = client.headers["content-length"]
    if len ~= nil then
        client.contentLength = tonumber(len)
    end
end

---Authenticate header if applicable
---@param client ClientTable
local function authenticateSession(client)
    -- If no password is set, don't authenticate
    if not auth then
        return true
    end

    local headerAuth = client.headers["authorization"] or nil
    if headerAuth then
        local basicAuth = string.match(headerAuth, "Basic (.+)")
        if bcrypt then
            if bcrypt.verify(auth, basicAuth) then
                return true
            end
        else
            -- Fallback to base64 encoding
            return basicAuth == mime.b64(auth)
        end
    end

    LogOutput("DEBUG", "Unauthenticated session %i", client.id)
    return false
end

---Dump headers for debugging
---@param client ClientTable
local function dumpSession(client)
    if not enableDebug then return end

    LogOutput("DEBUG", "==============================")
    LogOutput("DEBUG", "URL string: %s", client.urlString)
    LogOutput("DEBUG", "Method: %s", client.method)
    LogOutput("DEBUG", "Version: %s", client.version)

    LogOutput("DEBUG", "Headers:")
    for name, value in pairs(client.headers) do
        LogOutput("DEBUG", "    '%s' = '%s'", name, value)
    end

    LogOutput("DEBUG", "URL components:")
    for k, v in pairs(client.urlComponents) do
        LogOutput("DEBUG", "     %s:  %s", k, tostring(v))
    end

    if client.queryComponents ~= nil then
        LogOutput("DEBUG", "URL Query components")
        for k, v in pairs(client.queryComponents) do
            LogOutput("DEBUG", "     %s =  %s", k, tostring(v))
        end
    end

    if client.urlComponents then
        LogOutput("DEBUG", "URL Path: %s", client.urlComponents.path or "")
        LogOutput("DEBUG", "URL Params: %s", client.urlComponents.params or "")
        LogOutput("DEBUG", "URL url: %s", client.urlComponents.url or "")
    end

    LogOutput("DEBUG", "URL path components:")
    for k, v in pairs(client.pathComponents) do
        LogOutput("DEBUG", "     %s:  %s", k, tostring(v))
    end

    LogOutput("DEBUG", "Content Length: %d", client.contentLength)
    LogOutput("DEBUG", "Content: %s", client.content or "")
    LogOutput("DEBUG", "==============================")
end

---This is called when we have a complete request ready to be processed.
---Runs on the game thread (dispatched via ExecuteInGameThread or ExecuteInGameThreadSync2).
---Returns response data so the async thread can handle sendResponse and JSON stringify.
---@param client ClientTable
---@return string|table? content Response body (string or table to be stringified on async thread)
---@return MimeType? mime
---@return integer? code HTTP status code
local function processSession(client)
    dumpSession(client)

    local h = findHandler(client.urlComponents.path, client.method)
    if h then
        if h.authenticate and not authenticateSession(client) then
            return nil, nil, 401
        end

        local status, content, mime, code = pcall(h.handler, client)
        -- Check if the handler returned any valid response
        if status then
            return content, mime, code
        else
            local errMsg = content or "Unknown error"
            LogOutput("ERROR", "Handler error: %s", errMsg)
            local jsonOk, jsonErr = pcall(function()
                return {
                    error = errMsg
                }
            end)
            if jsonOk then
                return jsonErr, nil, 500
            else
                -- Avoid using json.stringify here to avoid unprotected handler
                return '{"error":"Internal server error"}', nil, 500
            end
        end
    else
        -- No matching path and method. How about just the path?
        local h = findHandler(client.urlComponents.path, nil)
        if h then
            -- This is a valid path, but not for the method.
            -- TODO: need to build a header with the allowed methods!
            return nil, nil, 405
        else
            return nil, nil, 404
        end
    end
end

---Turns a query string into a table of name/value pairs
---@param path string
---@return table<string, string>
local function decodeQuery(path)
    local cgi = {}
    for name, value in string.gmatch(path, "([^&=]+)=([^&=]+)") do
        name = url.unescape(name)
        value = url.unescape(value)
        cgi[name] = value
    end
    return cgi
end

---Dispatch a complete request to the appropriate thread based on HTTP method.
---GET/HEAD use fire-and-forget ExecuteInGameThread (no async-thread spin-wait).
---All mutating methods use ExecuteInGameThreadSync2 to guarantee completion ordering.
---@param s ClientTable
local function dispatchSession(s)
    if s.method == "GET" or s.method == "HEAD" then
        -- Throttle: if too many GETs are already queued on the game thread,
        -- reject immediately so we don't flood ExecuteInGameThread.
        if getInFlight >= maxGetInFlight then
            sendResponse(s, '{"error":"Server busy"}', nil, 503)
            return
        end
        getInFlight = getInFlight + 1
        -- Fire-and-forget: queue handler to game thread, async thread will poll pendingResponse
        ExecuteInGameThread(function()
            local ok, content, mime, code = pcall(processSession, s)
            if ok then
                s.pendingResponse = { content = content, mime = mime, code = code }
            else
                s.pendingResponse = { content = '{"error":"Internal server error"}', code = 500 }
            end
        end)
    else
        -- Mutating method: block async thread until game thread completes
        local res = {}
        local ok = ExecuteInGameThreadSync2(function()
            res.content, res.mime, res.code = processSession(s)
        end, "Webserver.processSession", 5000)
        if not ok then
            sendResponse(s, '{"error":"Game thread timeout"}', nil, 503)
        else
            if type(res.content) == "table" then
                local strOk, strErr = pcall(json.stringify, res.content)
                if strOk then
                    sendResponse(s, strErr, res.mime, res.code)
                else
                    sendResponse(s, '{"error":"JSON stringify failed"}', nil, 500)
                end
            else
                sendResponse(s, res.content, res.mime, res.code)
            end
        end
    end
end

---Handle client request data
---@param client TCPSocketClient
local function handleClient(client)
    local s = sessions[client]

    local data = nil ---@type string?
    local err = nil ---@type string|"closed"|"timeout"|nil
    local partial = nil ---@type number?

    local state, pErr = pcall(function()
        if s.state == "init" or s.state == "header" then
            data, err, partial = client:receive("*l")
        elseif s.state == "body" then
            data, err, partial = client:receive(s.contentLength)
        end

        if data then
            if s.state == "init" then
                LogOutput("DEBUG", "(%d) INIT: '%s'", s.id, data)
                s.rawHeaders = {}
                local method, urlString, ver = string.match(data, "(%S+)%s+(%S+)%s+(%S+)")
                if method ~= nil then
                    s.method = method
                    s.urlString = urlString
                    LogOutput("INFO", "Incoming request %s", s.urlString)

                    -- Break down the url string
                    s.urlComponents = url.parse(urlString)

                    s.pathComponents = url.parse_path(s.urlComponents.path)

                    LogOutput("DEBUG", "Query Components %s", s.urlComponents.query or "")
                    if s.urlComponents.query ~= nil then
                        s.queryComponents = decodeQuery(s.urlComponents.query)
                    end

                    s.version = ver

                    s.state = "header"
                else
                    LogOutput("ERROR", "Malformed initial line")
                    markSessionForRemoval(s)
                    return
                end
            elseif s.state == "header" then
                LogOutput("DEBUG", "(%d)  HDR: %s", s.id, data)
                if data ~= "" then
                    table.insert(s.rawHeaders, data)
                else
                    LogOutput("DEBUG", "(%d)  End Headers", s.id)
                    local rc = parseHeaders(s)
                    if rc ~= 0 then
                        sendResponse(s, nil, nil, 400)
                        return
                    end

                    processHeaders(s)

                    if s.contentLength == 0 then
                        LogOutput("DEBUG", "Content length = 0, not waiting for content")
                        dispatchSession(s)
                    else
                        LogOutput("DEBUG", "Waiting for content")
                        s.state = "body"
                    end
                end
            else
                s.content = data
                dispatchSession(s)
            end
        else
            if err == "closed" then
                LogOutput("DEBUG", "Client closed the connection: ")
                markSessionForRemoval(s)
            elseif err == "timeout" then
                LogOutput("ERROR", "Receive timeout. Partial data: %s", partial)
                markSessionForRemoval(s)
            else
                LogOutput("ERROR", "Receive error: %s", err)
                markSessionForRemoval(s)
            end
        end
    end)
    if not state then
        LogOutput("ERROR", "Process error: %s", pErr)
        markSessionForRemoval(s)
    end
end

---Wait the given amount of time for some data to process. If data received, it will be processed and this
---method will return. If no data, it will timeout and return. The caller should not know or care which happened.
---
---Note that if there is data to process this method may return sooner or later than the timeout time.
---@param timeout number Socket selection timeout in seconds
local function process(timeout)
    local rclients, _, err = socket.select(clients, nil, timeout)
    ---@cast rclients TCPSocketClient[]
    if err ~= nil then
        -- Either no data (timeout) or an error
        if err ~= "timeout" then
            LogOutput("ERROR", "Select error: %s", err)
        end
    else
        -- Some clients have data for us
        for _, client in ipairs(rclients) do
            if client == g_server then
                -- special case, accept new connection
                getNewClients()
            else
                handleClient(client)
            end
        end
    end

    -- Send pending GET/HEAD responses (async thread handles stringify + socket I/O)
    for _, client in ipairs(clients) do
        local s = sessions[client]
        if s and s.pendingResponse then
            local pr = s.pendingResponse
            if type(pr.content) == "table" then
                local strOk, strErr = pcall(json.stringify, pr.content)
                if strOk then
                    sendResponse(s, strErr, pr.mime, pr.code)
                else
                    sendResponse(s, '{"error":"JSON stringify failed"}', nil, 500)
                end
            else
                sendResponse(s, pr.content, pr.mime, pr.code)
            end
            s.pendingResponse = nil
            if s.method == "GET" or s.method == "HEAD" then
                getInFlight = math.max(0, getInFlight - 1)
            end
        end
    end

    -- Cleanup phase: remove closed sessions and time out stale connections
    local now = time()
    local i = #clients
    while i >= 1 do
        local client_to_check = clients[i]
        local s = sessions[client_to_check]
        if s then
            if s.state == "close" then
                LogOutput("DEBUG", "Cleaning up client %i", s.id)
                client_to_check:close()
                table.remove(clients, i)
                sessions[client_to_check] = nil
            elseif now - s.connTime > maxSessionAgeMs then
                LogOutput("WARN", "Timing out client %i (age %d ms)", s.id, now - s.connTime)
                -- If this was a throttled GET that never got a pendingResponse,
                -- make sure we decrement the counter so the slot opens back up.
                if s.pendingResponse == nil and (s.method == "GET" or s.method == "HEAD") then
                    getInFlight = math.max(0, getInFlight - 1)
                end
                client_to_check:close()
                table.remove(clients, i)
                sessions[client_to_check] = nil
            end
        end
        i = i - 1
    end
end

---Register a new handler for the specified path and method
---@param path string pattern to match (e.g. `/api/status`)
---@param method RequestMethod request type (e.g. `GET`, `POST`)
---@param handler RequestPathHandler request handler function
---@param authenticate boolean? Should the handler be authenticated. Defaults to true
local function registerHandler(path, method, handler, authenticate)
    local h = RequestPathHandlerTable.new(path, method, handler, authenticate)
    -- Already registered?
    local i = findHandlerIndex(path, method)
    if i == nil then
        -- add
        table.insert(handlers, h)
    else
        -- replace
        handlers[i] = h
    end
end

---Initialize the web server
---@param host string Host to bind to
---@param initPort number Port to bind to
local function init(host, initPort)
    g_server = socket.bind(host, initPort)
    if g_server == nil then
        LogOutput("ERROR", "Unable to bind to port %s", initPort);
        return
    end

    local bindAddr, bindPort = g_server:getsockname()
    LogOutput("INFO", "Webserver listening to host %s on port %i", (bindAddr or host), (bindPort or initPort))

    g_server:settimeout(0)  -- Non-blocking: accept() returns immediately if no pending connections

    -- Add the server socket to the client arrays so we will wait on it in select()
    table.insert(clients, g_server)
end

---Start the web server
---@param bindHost string? Host IP to bind to
---@param bindPort number? Port to bind to
local function run(bindHost, bindPort)
    bindHost = bindHost or "*"
    bindPort = bindPort or port

    -- Register core webserver command
    registerHandler("/stop", "POST", function(session)
        isServerRunning = false
        return { status = "ok" }, nil, 201
    end)

    init(bindHost, bindPort)
    isServerRunning = true
    -- Run the webserver loop off the game thread via LoopAsync so that socket I/O
    -- (accept, receive, select) never blocks EngineTick.  When a complete HTTP
    -- request is ready, processSession is dispatched to the game thread with
    -- ExecuteInGameThreadSync2; the response is then sent from the async thread.
    -- process() uses timeout=0 (non-blocking socket.select) so the async thread
    -- never sleeps longer than necessary.
    LoopAsync(1, function()
        process(0)
        if not isServerRunning then
            LogOutput("INFO", "Webserver stopped")
        end
        return not isServerRunning
    end)
end

RegisterConsoleCommandHandler("stopwebserver", function(Cmd, CommandParts, Ar)
    isServerRunning = false
    return true
end)

local WebserverInstance = {
    run = run,
    registerHandler = registerHandler
}

if not _G.Webserver then
    _G.Webserver = WebserverInstance
end

return _G.Webserver
