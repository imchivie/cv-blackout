Config = Config or {}
Config.checkUpdates = Config.checkUpdates ~= false -- Default to true if not set

-- get version
local function getResourceVersion()
    local resourceName = GetCurrentResourceName()
    local version = GetResourceMetadata(resourceName, 'version')
    
    if version and version ~= '' then
        return version
    end
    return '1.0.0'
end

local CV_VERSION = getResourceVersion()
local updateMessage = nil
local updateUrl = nil
local isCustomVersion = false

-- Helper function to wrap long text
local function wrapText(text, maxLength)
    local words = {}
    for word in string.gmatch(text, "%S+") do
        table.insert(words, word)
    end
    
    local lines = {}
    local currentLine = ""
    
    for _, word in ipairs(words) do
        if #currentLine + #word + 1 <= maxLength then
            if currentLine == "" then
                currentLine = word
            else
                currentLine = currentLine .. " " .. word
            end
        else
            table.insert(lines, currentLine)
            currentLine = word
        end
    end
    
    if currentLine ~= "" then
        table.insert(lines, currentLine)
    end
    
    return lines
end
