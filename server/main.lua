-- Keep qb-core for player data if you're still using QBCore elsewhere
local QBCore = exports['qb-core']:GetCoreObject()
local ox = exports.ox_inventory

-- ox_inventory usable items
ox:RegisterUsableItem('vic_driver_license', function(source, item)
    -- item.metadata is available if you store anything on the item
    TriggerClientEvent('uncharted_id:client:useDriverLicense', source, item and item.metadata or nil)
end)

ox:RegisterUsableItem('vic_motorbike_license', function(source, item)
    TriggerClientEvent('uncharted_id:client:useMotorbikeLicense', source, item and item.metadata or nil)
end)

ox:RegisterUsableItem('vic_weaponlicense', function(source, item)
    TriggerClientEvent('uncharted_id:client:useFirearmsLicense', source, item and item.metadata or nil)
end)

ox:RegisterUsableItem('vic_id_card', function(source, item)
    TriggerClientEvent('uncharted_id:client:useIdCard', source, item and item.metadata or nil)
end)

ox:RegisterUsableItem('vic_truck_license', function(source, item)
    TriggerClientEvent('uncharted_id:client:useTruckLicense', source, item and item.metadata or nil)
end)

-- unchanged: showing licenses to players nearby
RegisterServerEvent('license:server:showLicense', function(coords, data)
    local src = source
    local players = QBCore.Functions.GetPlayers() -- fine to keep if you’re still on QBCore core
    local playerName = GetPlayerName(src)

    print(('[License] %s is showing %s license at coords: %s'):format(playerName, data.type, coords))

    local playersInRange = 0

    for _, playerId in pairs(players) do
        if playerId ~= src then
            local targetPed = GetPlayerPed(playerId)
            if targetPed and targetPed ~= 0 then
                local targetCoords = GetEntityCoords(targetPed)
                local distance = #(vector3(targetCoords.x, targetCoords.y, targetCoords.z) - vector3(coords.x, coords.y, coords.z))

                if distance < 10.0 then
                    TriggerClientEvent('license:client:displayLicense', playerId, playerName, data.type)
                    playersInRange += 1
                    print(('[License] Showing license to %s (distance: %.2f)'):format(GetPlayerName(playerId), distance))
                end
            end
        end
    end

    TriggerClientEvent('license:client:displayLicense', src, playerName, data.type)
    print(('[License] License shown to %d nearby players'):format(playersInRange))
end)
