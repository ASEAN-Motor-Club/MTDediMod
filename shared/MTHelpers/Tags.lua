---GameplayTag utility functions for MotorTown
---@class Tags

local Tags = {}

---Convert FGameplayTag to string
---@param gameplayTag FGameplayTag
---@return string
function Tags.TagToString(gameplayTag)
  return gameplayTag.TagName:ToString()
end

---Convert FGameplayTagContainer to string array
---@param gameplayTag FGameplayTagContainer
---@return string[]
function Tags.ContainerToStrings(gameplayTag)
  local arr = {}
  gameplayTag.GameplayTags:ForEach(function(index, element)
    table.insert(arr, element:get().TagName:ToString())
  end)
  return arr
end

---Convert FGameplayTagQuery to JSON serializable table
---@param query FGameplayTagQuery
---@return table
function Tags.QueryToTable(query)
  local data = {}

  data.AutoDescription = query.AutoDescription:ToString()

  data.QueryTokenStream = {} ---@type number[]
  query.QueryTokenStream:ForEach(function(index, element)
    table.insert(data.QueryTokenStream, element:get())
  end)

  data.TagDictionary = {} ---@type string[]
  query.TagDictionary:ForEach(function(index, element)
    table.insert(data.TagDictionary, Tags.TagToString(element:get()))
  end)

  data.TokenStreamVersion = query.TokenStreamVersion
  data.UserDescription = query.UserDescription:ToString()

  return data
end

return Tags
