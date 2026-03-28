---String and table utility functions
---@class Strings

local Strings = {}

---Split string by the separator.
---Returns `nil` if input is `nil` or empty.
---@param inputstr string Input string
---@param sep string? Separator character(s). Defaults to a whitespace.
---@return string[]?
function Strings.Split(inputstr, sep)
  if inputstr == nil then return nil end
  -- if sep is null, set it as space
  if sep == nil then
    sep = '%s'
  end
  -- define an array
  local t = {}
  -- split string based on sep
  for str in string.gmatch(inputstr, '([^' .. sep .. ']+)')
  do
    -- insert the substring in table
    table.insert(t, str)
  end
  -- return the array
  return t
end

---Merge two tables together, overwriting base table values with the appended table values recursively
---@param base table
---@param append table
---@return table
function Strings.MergeTables(base, append)
  for k, v in pairs(append) do
    if type(v) == "table" then
      if type(base[k] or false) == "table" then
        Strings.MergeTables(base[k] or {}, append[k] or {})
      else
        base[k] = v
      end
    else
      base[k] = v
    end
  end
  return base
end

---Deep set table value
---@param input table
---@param fields string[]
---@param value any
function Strings.RecursiveSetValue(input, fields, value)
  local field = table.remove(fields, 1)
  if input[field] ~= nil then
    if #fields == 0 then
      input[field] = value
    else
      Strings.RecursiveSetValue(input[field], fields, value)
    end
  else
    error("Invalid field value given")
  end
end

---Attempt to load a module, otherwise returns nil.
---This method does not automatically resolve the module completion.
---You may need to set the `@type` manually.
---@param moduleName string
function Strings.RequireSafe(moduleName)
  local hasModule, module = pcall(require, moduleName)
  if hasModule then
    return module
  end
  return nil
end

---Read file as strings
---@param path string
---@return string|nil
function Strings.ReadFile(path)
  local file = io.open(path, "rb")
  if file then
    local content = file:read("*all")
    file:close()
    return content
  end
  return nil
end

return Strings
