local QBCore = exports['qb-core']:GetCoreObject()

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
    if not currentState then
        TriggerClientEvent('QBCore:Notify', src, 'Blackout enabled!', 'success')
    else
        TriggerClientEvent('QBCore:Notify', src, 'Blackout disabled!', 'success')
    end
end, 'admin')