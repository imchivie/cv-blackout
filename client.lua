local QBCore = exports['qb-core']:GetCoreObject()
local isBlackoutActive = false

-- Track blackout state locally
RegisterNetEvent('qb-weathersync:client:SyncWeather', function(NewWeather, newblackout)
    isBlackoutActive = newblackout
end)

-- Function to get current blackout state
local function getBlackoutState()
    return isBlackoutActive
end

-- Dramatic lighting effects
local function powerOutEffect()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    
    -- Screen flash effect
    DoScreenFadeOut(100)
    Citizen.SetTimeout(100, function()
        DoScreenFadeIn(500)
    end)
    
    -- Create flickering lights effect
    for i = 1, 16 do
        -- Flicker effect
        SetArtificialLightsState(true)
        Wait(math.random(50, 150))
        SetArtificialLightsState(false)
        Wait(math.random(30, 900))
    end
    
    -- Small screen shake
    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.2)
    Wait(200)
    StopGameplayCamShaking(false)
end

local function powerRestoreEffect()
    local playerPed = PlayerPedId()
    
    -- Screen flash
    DoScreenFadeOut(100)
    Citizen.SetTimeout(100, function()
        DoScreenFadeIn(300)
    end)
    
    -- Power surge flicker
    for i = 1, 5 do
        SetArtificialLightsState(true)
        Wait(math.random(20, 60))
        SetArtificialLightsState(false)
        Wait(math.random(10, 40))
    end
    
    -- Final bright flash
    SetArtificialLightsState(true)
    Wait(100)
    
    -- manest7a9ich camera shake fil power restore

    -- Small screen shake for dramatic effect
    -- ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.15)
    -- Wait(200)
    -- StopGameplayCamShaking(false)
end

local function flickerEffect()
    -- Random flickering during blackout (adds tension)
    local flickers = math.random(1, 15)
    for i = 1, flickers do
        SetArtificialLightsState(false)
        Wait(math.random(50, 200))
        SetArtificialLightsState(true)
        Wait(math.random(30, 150))
        SetArtificialLightsState(false)
    end
end

-- Event handlers
RegisterNetEvent('cv-blackout:client:lightingEffect', function(effectType)
    if effectType == 'powerout' then
        powerOutEffect()
    elseif effectType == 'powerrestore' then
        powerRestoreEffect()
    elseif effectType == 'flicker' then
        flickerEffect()
    end
end)

-- Random flickering while blackout is active (optional)
CreateThread(function()
    while true do
        Wait(10000) -- Check every 10 seconds
        
        if isBlackoutActive then
            -- Check config for random flicker setting
            local shouldFlicker = true
            if Config and Config.Effects then
                shouldFlicker = Config.Effects.randomFlicker
            end
            
            if shouldFlicker then
                local flickerChance = 20
                if Config and Config.Effects and Config.Effects.flickerChance then
                    flickerChance = Config.Effects.flickerChance
                end
                
                -- Chance of random flicker every 10 seconds during blackout
                if math.random(1, 100) <= flickerChance then
                    flickerEffect()
                end
            end
            Wait(5000) -- Additional wait after flicker
        end
    end
end)

print('^2[CV-BLACKOUT] Client effects loaded!^7')