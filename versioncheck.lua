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