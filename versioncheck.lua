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
    end
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
                        for part in string.gmatch(str, "%d+") do
                            table.insert(parts, tonumber(part))
                        end
                        return parts
                    end
                    
                    local v1parts = splitVersion(v1)
                    local v2parts = splitVersion(v2)
                    
                    for i = 1, math.max(#v1parts, #v2parts) do
                        local num1 = v1parts[i] or 0
                        local num2 = v2parts[i] or 0
                        if num1 ~= num2 then
                            return num1 < num2
                        end
                    end
                    return false
                end

                if isVersionLess(currentVersion, latestVersion) then
                    updateMessage = string.format("New version available: %s (current: %s)", latestVersion, CV_VERSION)
                    updateUrl = "https://github.com/imchivie/cv-blackout/releases"
                    isCustomVersion = false
                elseif currnetVersion ~= latestVersion then
                    updateMessge = string.format("You are running your custom version of cv-blackout. The latest official release is: %s", latestVersion)
                    updateUrl = "https://github.com/imchivie/cv-blackout/releases"
                    isCustomVersion = true
                else
                    updateMessage = "Running latest version"
                    updateUrl = nil
                end
            end
        elseif err == 404 then
            updateMessage = "No release found on GitHub yet"
            updateUrl = nil
        else
            if Config.Debug then
                updateMessage = string.format("Error checking for updates: (http %s)", err)
            end
        
        end
    end, 'GET')
end

local function displayBanner()

    print('^1╔═══════════════════════════════════════════════════════════════════════╗^0')
    print('^1║                                                                       ║^0')
    print('^1║     ___  _  _     ____  __      __    ___  _  _  _____  __  __  ____  ║^0')
    print('^1║    / __)( \\/ )___(  _ \\(  )    /__\\  / __)( )/ )(  _  )(  )(  )(_  _) ║^0')
    print('^1║   ( (__  \\  /(___)) _ < )(__  /(__)\\( (__  )  (  )(_)(  )(__)(   )(   ║^0')
    print('^1║    \\___)  \\/     (____/(____)(__)(__)\\___)(_)\\_)(_____)(______) (__)  ║^0')
    print('^1║                                                                       ║^0')
    
    -- display version with color 
    local versionLine = string.format("CV-Blackout %s - blackout script by @imchivie", CV_VERSION)
    if isCustomVersion then
        versionLine = versionLine .. " ^3(CUSTOM)^0"
    end
    
    local versionLength = #versionLine
    local versionPadding = 71 - versionLength
    local leftVersionPad = math.floor(versionPadding / 2)
    local rightVersionPad = versionPadding - leftVersionPad

    print(('^2║%s%s%s^2║^0'):format(
        string.rep(" ", leftVersionPad),
        versionLine,
        string.rep(" ", rightVersionPad)
    ))

end