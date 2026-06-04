local QBCore = exports['qb-core']:GetCoreObject()

Config = Config or {}
Config.Notify = Config.Notify ~= false -- Set to false to disable notifications when toggling blackout mode
-- Command to toggle blackout
QBCore.Commands.Add('blackouttoggle', 'Toggle blackout mode', {}, false, function(source)
    local src = source
    
    -- Check if qb-weathersync is available
    if not exports['qb-weathersync'] then
        TriggerClientEvent('QBCore:Notify', src, 'qb-weathersync not found!', 'error')
        return
    end
    
    -- Toggle blackout
    local currentState = exports['qb-weathersync']:getBlackoutState()
    exports['qb-weathersync']:setBlackout(not currentState)
    
    -- Notify player
    if Config.Notify then
        if not currentState then
            TriggerClientEvent('QBCore:Notify', src, 'Blackout enabled!', 'success')
        else
            TriggerClientEvent('QBCore:Notify', src, 'Blackout disabled!', 'success')
        end
    end
end, 'admin')

-- Export to toggle blackout from other scripts
exports('ToggleBlackout', function(state)
    if not exports['qb-weathersync'] then
        print('^1[ERROR] qb-weathersync not found!^7')
        return false
    end
    
    if state == nil then
        -- Toggle if no state provided
        local currentState = exports['qb-weathersync']:getBlackoutState()
        exports['qb-weathersync']:setBlackout(not currentState)
        return not currentState
    else
        -- Set to specific state
        exports['qb-weathersync']:setBlackout(state)
        return state
    end
end)