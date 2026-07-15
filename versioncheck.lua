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


local function checkForUpdates()
    if not Config.checkUpdates then
        updateMessage = nil
        return
    
    PerformHttpRequest('https://api.github.com/repos/imchivie/cv-blackout/releases/latest', function(err, text, headers)
        if err == 200 then
            local data = json.decode(text)
            if data and data.tag_name then
                local latestVersion = data.tag_name:lower():gsub('v', '')
                local currentVersion = CV_VERSION:lower()

                -- Simple version comparison 
                local function isVersionLess(v1, v2)
                    -- split verison to parts (exp: 1.3.2 -> {1,3,2})
                    local function splitVersion(str)
                        local parts = {}
                        for part in string.gmatch(str,"%d+") do
                            table.insert(parts, tonumber(part))
                        end
                        return parts
                    end
                    
                    local v1parts = splitVersion(v1)
                    local v2parts = splitVersion(v2)
                    
                    for i = 1, math.max(#v1parts, #v2parts) do
                        local num1 = v1parts[i] or 0
                        local num2 = v2parts[i] or 0
                        if num1  ~= num2 then 
                            return num1 < num2
                        end
                    end
                    return false
                end
                
            end
        end
    end, 'GET')
    end
end