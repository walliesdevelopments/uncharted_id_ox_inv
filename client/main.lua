local QBCore = exports['qb-core']:GetCoreObject()

-- Key listener for closing license with 'R' key
local licenseDisplayed = false

-- Register useable item for vic_driver_license
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        -- Nothing needed here for now
    end)
end)

-- Function to play license showing animation
local function playLicenseAnimation()
    local playerPed = PlayerPedId()
    
    -- Load the animation dictionary
    local animDict = "paper_1_rcm_alt1-8"
    local animName = "player_one_dual-8"
    
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(0)
    end
    
    -- Play the animation
    TaskPlayAnim(playerPed, animDict, animName, 8.0, -8.0, 3000, 0, 0, false, false, false)
    
    -- Clean up after animation finishes (don't wait)
    Citizen.CreateThread(function()
        Citizen.Wait(200)
        RemoveAnimDict(animDict)
    end)
end

-- Handle vic_driver_license item usage
RegisterNetEvent('uncharted_id:client:useDriverLicense', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    -- Play animation
    playLicenseAnimation()
    
    TriggerServerEvent('license:server:showLicense', coords, { type = "driver" })
end)

-- Handle vic_motorbike_license item usage
RegisterNetEvent('uncharted_id:client:useMotorbikeLicense', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    -- Play animation
    playLicenseAnimation()
    
    TriggerServerEvent('license:server:showLicense', coords, { type = "motorbike" })
end)

-- Handle vic_weaponlicense item usage
RegisterNetEvent('uncharted_id:client:useFirearmsLicense', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    -- Play animation
    playLicenseAnimation()
    
    TriggerServerEvent('license:server:showLicense', coords, { type = "firearms" })
end)

-- Handle vic_id_card item usage
RegisterNetEvent('uncharted_id:client:useIdCard', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    -- Play animation
    playLicenseAnimation()
    
    TriggerServerEvent('license:server:showLicense', coords, { type = "id-card" })
end)

-- Handle vic_truck_license item usage
RegisterNetEvent('uncharted_id:client:useTruckLicense', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    -- Play animation
    playLicenseAnimation()
    
    TriggerServerEvent('license:server:showLicense', coords, { type = "truck" })
end)

RegisterNetEvent('license:client:showLicense', function(data)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    -- Play animation
    playLicenseAnimation()

    TriggerServerEvent('license:server:showLicense', coords, data)
end)

RegisterCommand('showlicense', function(_, args)
    local licenseType = args[1] or "driver"
    TriggerEvent('license:client:showLicense', { type = licenseType })
end)

-- Add a manual close command as backup
RegisterCommand('closelicense', function()
    if licenseDisplayed then
        SendNUIMessage({
            action = "hide"
        })
        licenseDisplayed = false
    end
end)

RegisterNetEvent('license:client:displayLicense', function(name, licenseType)
    -- Get player data for license
    local PlayerData = QBCore.Functions.GetPlayerData()
    
    -- Get player's address from QBCore
    local function getPlayerAddress()
        local address = {
            line1 = "FLAT 10",
            line2 = "77 SAMPLE PARADE", 
            line3 = "KEW EAST VIC 3102"
        }
        
        -- Try to get real address from player data
        if PlayerData.metadata and PlayerData.metadata.address then
            address.line1 = PlayerData.metadata.address.apartment or PlayerData.metadata.address.house or "UNIT 1"
            address.line2 = PlayerData.metadata.address.street or "MAIN STREET"
            address.line3 = PlayerData.metadata.address.city or "MELBOURNE VIC 3000"
        elseif PlayerData.charinfo and PlayerData.charinfo.address then
            address.line1 = PlayerData.charinfo.address.apartment or PlayerData.charinfo.address.house or "UNIT 1"
            address.line2 = PlayerData.charinfo.address.street or "MAIN STREET"
            address.line3 = PlayerData.charinfo.address.city or "MELBOURNE VIC 3000"
        else
            -- Fallback: Try to get from housing system if available (with error protection)
            local success = false
            
            -- Try qb-houses with error protection
            if not success and GetResourceState('qb-houses') == 'started' then
                local status, result = pcall(function()
                    -- Try common export names safely
                    if exports['qb-houses'] and exports['qb-houses']['GetHouses'] then
                        return exports['qb-houses']:GetHouses(PlayerData.citizenid)
                    elseif exports['qb-houses'] and exports['qb-houses']['GetPlayerHouses'] then
                        return exports['qb-houses']:GetPlayerHouses(PlayerData.citizenid)
                    end
                    return nil
                end)
                
                if status and result and result[1] then
                    address.line1 = result[1].label or result[1].name or "HOUSE"
                    address.line2 = result[1].adress or result[1].street or "RESIDENTIAL STREET"
                    address.line3 = "MELBOURNE VIC 3000"
                    success = true
                end
            end
            
            -- Try qb-apartments with error protection
            if not success and GetResourceState('qb-apartments') == 'started' then
                local status, result = pcall(function()
                    if exports['qb-apartments'] and exports['qb-apartments']['GetPlayerApartment'] then
                        return exports['qb-apartments']:GetPlayerApartment(PlayerData.citizenid)
                    elseif exports['qb-apartments'] and exports['qb-apartments']['GetApartmentInfo'] then
                        return exports['qb-apartments']:GetApartmentInfo(PlayerData.citizenid)
                    end
                    return nil
                end)
                
                if status and result then
                    address.line1 = "APT " .. (result.apartmentNumber or result.name or "1")
                    address.line2 = result.street or result.label or "APARTMENT COMPLEX"
                    address.line3 = "MELBOURNE VIC 3000"
                    success = true
                end
            end
        end
        
        return address
    end
    
    -- Take a mugshot for the license
    local function takePhoto()
        local ped = PlayerPedId()
        local mugshot = exports["MugShotBase64"]:GetMugShotBase64(ped, true)
        return mugshot
    end
    
    -- Get photo (you can modify this based on your setup)
    local playerPhoto = nil
    
    -- Option 1: Take a live mugshot using MugShotBase64
    if exports["MugShotBase64"] then
        playerPhoto = takePhoto()
    end
    
    -- Option 2: Use stored photo from database (if you have one)
    -- playerPhoto = PlayerData.charinfo.photo or nil
    
    -- Option 3: Use a default photo URL
    -- playerPhoto = "https://i.imgur.com/yourphoto.png"
    
    -- Get player's real address
    local playerAddress = getPlayerAddress()
    
    local licenseData = {}
    
    if licenseType == "driver" then
        licenseData = {
            name = PlayerData.charinfo.firstname .. " " .. PlayerData.charinfo.lastname,
            address1 = playerAddress.line1,
            address2 = playerAddress.line2,
            address3 = playerAddress.line3,
            expiry = "20-05-2025",
            birthDate = PlayerData.charinfo.birthdate or "01-01-1990",
            licenseType = "CAR",
            conditions = "NONE",
            licenseNumber = PlayerData.citizenid or "123456789",
            signature = PlayerData.charinfo.firstname .. " " .. PlayerData.charinfo.lastname,
            photo = playerPhoto
        }
    elseif licenseType == "motorbike" then
        licenseData = {
            name = PlayerData.charinfo.firstname .. " " .. PlayerData.charinfo.lastname,
            address1 = playerAddress.line1,
            address2 = playerAddress.line2,
            address3 = playerAddress.line3,
            expiry = "20-05-2025",
            birthDate = PlayerData.charinfo.birthdate or "01-01-1990",
            licenseType = "MOTORBIKE",
            conditions = "NONE",
            licenseNumber = PlayerData.citizenid or "123456789",
            signature = PlayerData.charinfo.firstname .. " " .. PlayerData.charinfo.lastname,
            photo = playerPhoto
        }
    elseif licenseType == "proof-age" then
    elseif licenseType == "firearms" then
        licenseData = {
            name = PlayerData.charinfo.firstname .. " " .. PlayerData.charinfo.lastname,
            conditions = "N",
            reasons = "Sport/Target Shooting",
            signature = PlayerData.charinfo.firstname .. " " .. PlayerData.charinfo.lastname,
            expiry = "01/01/2030",
            licenseNumber = string.sub(PlayerData.citizenid or "113569895", 1, 9),
            photo = playerPhoto
        }
    elseif licenseType == "id-card" then
        licenseData = {
            name = PlayerData.charinfo.firstname .. " " .. PlayerData.charinfo.lastname,
            address1 = playerAddress.line2, -- Use street for ID card
            address2 = playerAddress.line3, -- Use city for second line
            birthDate = PlayerData.charinfo.birthdate or "03-09-1989",
            issueDate = "05/03/2019",
            location = "572",
            cardNumber = string.sub(PlayerData.citizenid or "123456", 1, 6),
            photo = playerPhoto
        }
    elseif licenseType == "truck" then
        licenseData = {
            name = PlayerData.charinfo.firstname .. " " .. PlayerData.charinfo.lastname,
            address1 = playerAddress.line1,
            address2 = playerAddress.line2,
            address3 = playerAddress.line3,
            expiry = "21-11-2019",
            birthDate = PlayerData.charinfo.birthdate or "02-06-1983",
            licenseType = "CAR HR", -- Heavy Rigid as shown in image
            conditions = "NONE",
            licenseNumber = string.sub(PlayerData.citizenid or "059120569", 1, 9),
            signature = PlayerData.charinfo.firstname .. " " .. PlayerData.charinfo.lastname,
            photo = playerPhoto,
            isHeavyVehicle = true -- Special flag for heavy vehicle styling
        }
    end
    
    -- Show NUI
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = "show",
        licenseType = licenseType,
        licenseData = licenseData
    })
    
    -- Set license as displayed
    licenseDisplayed = true
end)

-- Key listener for closing license
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if licenseDisplayed then
            -- Multiple ways to detect R key press
            if IsControlJustPressed(1, 140) or -- R key (PlayerControl)
               IsControlJustPressed(2, 140) or -- R key (Frontend)
               IsControlJustPressed(0, 177) or -- Backspace
               IsDisabledControlJustPressed(0, 140) then -- R key when disabled
                
                SendNUIMessage({
                    action = "hide"
                })
                licenseDisplayed = false
            end
        else
            Citizen.Wait(500) -- Reduce resource usage when license is not displayed
        end
    end
end)

-- Update license display status
RegisterNetEvent('license:client:setDisplayStatus', function(status)
    licenseDisplayed = status
end)

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    licenseDisplayed = false
    cb('ok')
end)
