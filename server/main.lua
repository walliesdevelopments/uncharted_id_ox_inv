local QBCore = exports['qb-core']:GetCoreObject()

-- Register the vic_driver_license as a useable item
QBCore.Functions.CreateUseableItem("vic_driver_license", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    
    TriggerClientEvent('uncharted_id:client:useDriverLicense', source)
end)

-- Register the vic_motorbike_license as a useable item
QBCore.Functions.CreateUseableItem("vic_motorbike_license", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    
    TriggerClientEvent('uncharted_id:client:useMotorbikeLicense', source)
end)

-- Register the vic_weaponlicense as a useable item
QBCore.Functions.CreateUseableItem("vic_weaponlicense", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    
    TriggerClientEvent('uncharted_id:client:useFirearmsLicense', source)
end)

-- Register the vic_id_card as a useable item
QBCore.Functions.CreateUseableItem("vic_id_card", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    
    TriggerClientEvent('uncharted_id:client:useIdCard', source)
end)

-- Register the vic_truck_license as a useable item
QBCore.Functions.CreateUseableItem("vic_truck_license", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    
    TriggerClientEvent('uncharted_id:client:useTruckLicense', source)
end)

RegisterServerEvent('license:server:showLicense', function(coords, data)
    local src = source
    local players = QBCore.Functions.GetPlayers()
    local playerName = GetPlayerName(src)
    
    print(string.format("[License] %s is showing %s license at coords: %s", playerName, data.type, coords))
    
    local playersInRange = 0
    
    for _, playerId in pairs(players) do
        if playerId ~= src then -- Don't send to the person showing the license
            local targetPed = GetPlayerPed(playerId)
            if targetPed and targetPed ~= 0 then
                local targetCoords = GetEntityCoords(targetPed)
                local distance = #(vector3(targetCoords.x, targetCoords.y, targetCoords.z) - vector3(coords.x, coords.y, coords.z))
                
                if distance < 10.0 then -- Increased range from 5.0 to 10.0 for better visibility
                    TriggerClientEvent('license:client:displayLicense', playerId, playerName, data.type)
                    playersInRange = playersInRange + 1
                    print(string.format("[License] Showing license to %s (distance: %.2f)", GetPlayerName(playerId), distance))
                end
            end
        end
    end
    
    -- Also show to the person displaying the license
    TriggerClientEvent('license:client:displayLicense', src, playerName, data.type)
    
    print(string.format("[License] License shown to %d nearby players", playersInRange))
end)
