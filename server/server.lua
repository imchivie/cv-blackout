local QBCore = exports['qb-core']:GetCoreObject()

Config = Config or {}
Config.Notify = Config.Notify ~= false -- Set to false to disable notifications when toggling blackout mode

-- Function to trigger dramatic lighting effect on all clients
local function triggerLightingEffect(effectType)
    TriggerClientEvent('cv-blackout:client:lightingEffect', -1, effectType)
end

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
    local newState = not currentState
    
    -- Trigger dramatic effect before toggling
    if newState then
        -- Enabling blackout - power failure effect
        triggerLightingEffect('powerout')
        TriggerEvent('InteractSound_SV:PlayOnAll', 'blackoutoff', Config.volume)
    else
        -- Disabling blackout - power restore effect
        triggerLightingEffect('powerrestore')
    end
    
    -- Small delay for dramatic effect
    Citizen.SetTimeout(900, function()
        exports['qb-weathersync']:setBlackout(newState)
        
        -- Notify player
        if Config.Notify and src then
            if newState then
                TriggerClientEvent('QBCore:Notify', src, 'Blackout enabled! The city goes dark...', 'success')
            else
                TriggerClientEvent('QBCore:Notify', src, 'Blackout disabled! Power restored!', 'success')
            end
        end
    end)
end, 'admin')

-- Export to toggle blackout from other scripts
exports('ToggleBlackout', function(state)
    if not exports['qb-weathersync'] then
        print('^1[ERROR] qb-weathersync not found!^7')
        return false
    end
    
    local newState
    if state == nil then
        -- Toggle if no state provided
        local currentState = exports['qb-weathersync']:getBlackoutState()
        newState = not currentState
    else
        newState = state
    end
    
    -- Trigger dramatic effect
    if newState then
        triggerLightingEffect('powerout')
    else
        triggerLightingEffect('powerrestore')
    end
    
    Citizen.SetTimeout(500, function()
        exports['qb-weathersync']:setBlackout(newState)
    end)
    
    return newState
end)

-- Event to toggle blackout from other scripts
RegisterNetEvent('cv-blackout:server:toggle', function()
    local src = source
    
    if not exports['qb-weathersync'] then
        if Config.Notify and src then
            TriggerClientEvent('QBCore:Notify', src, 'qb-weathersync not found!', 'error')
        end
        return
    end
    
    local currentState = exports['qb-weathersync']:getBlackoutState()
    local newState = not currentState
    
    -- Trigger dramatic effect
    if newState then
        triggerLightingEffect('powerout')
    else
        triggerLightingEffect('powerrestore')
    end
    
    Citizen.SetTimeout(500, function()
        exports['qb-weathersync']:setBlackout(newState)
        
        if Config.Notify and src then
            if newState then
                TriggerClientEvent('QBCore:Notify', src, 'Blackout enabled! The city goes dark...', 'success')
            else
                TriggerClientEvent('QBCore:Notify', src, 'Blackout disabled! Power restored!', 'success')
            end
        end
    end)
end)

RegisterNetEvent('cv-blackout:server:set', function(state)
    local src = source
    
    if not exports['qb-weathersync'] then
        if Config.Notify and src then
            TriggerClientEvent('QBCore:Notify', src, 'qb-weathersync not found!', 'error')
        end
        return
    end
    
    -- Trigger dramatic effect
    if state then
        triggerLightingEffect('powerout')
    else
        triggerLightingEffect('powerrestore')
    end
    
    Citizen.SetTimeout(500, function()
        exports['qb-weathersync']:setBlackout(state)
        
        if Config.Notify and src then
            if state then
                TriggerClientEvent('QBCore:Notify', src, 'Blackout enabled! The city goes dark...', 'success')
            else
                TriggerClientEvent('QBCore:Notify', src, 'Blackout disabled! Power restored!', 'success')
            end
        end
    end)
end)

print('^2[CV-BLACKOUT] Script loaded successfully!^7')