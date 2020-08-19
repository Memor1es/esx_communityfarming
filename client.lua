ESX                             = nil
local PlayerData                = {}
local onJob                     = false
local working                   = false

local crops = {}

-- random ESX fuckery
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job

    createBlips()
end)

-- checks if player has farmer job
function checkJob()
    if PlayerData ~= nil then
        IsJobTrue = false
        if PlayerData.job ~= nil and PlayerData.job.name == 'farmer' then
            IsJobTrue = true
        end
        return IsJobTrue
    end
end 

-- creates map blips
function createBlips()
    if checkJob() then
        -- locker room blip
        lockerRoomBlip = AddBlipForCoord(Config.lockerRoom.x, Config.lockerRoom.y, Config.lockerRoom.z)
        SetBlipSprite(lockerRoomBlip, 86)
        SetBlipScale(lockerRoomBlip, 1.0)
        SetBlipColour(lockerRoomBlip, 3)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Locker Room")
        EndTextCommandSetBlipName(lockerRoomBlip)

        -- wheat sell blip
        wheatSellBlip = AddBlipForCoord(Config.wheatSell.x, Config.wheatSell.y, Config.wheatSell.z)
        SetBlipSprite(wheatSellBlip, 86)
        SetBlipScale(wheatSellBlip, 1.0)
        SetBlipColour(wheatSellBlip, 5)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Wheat Sell Point")
        EndTextCommandSetBlipName(wheatSellBlip)
    else
        RemoveBlip(lockerRoomBlip)
        RemoveBlip(wheatSellBlip)
    end
end

-- markers
CreateThread(function()
    -- determines size of field and splits into grid, draws markers in each grid section to denote a crop pickup
    for i=1, #Config.farms, 1 do

        local fieldLength = math.max(math.abs(Config.farms[i].corner1.x - Config.farms[i].corner3.x), math.abs(Config.farms[i].corner2.x - Config.farms[i].corner4.x))
        local fieldWidth = math.min(math.abs(Config.farms[i].corner1.x - Config.farms[i].corner2.x), math.abs(Config.farms[i].corner3.x - Config.farms[i].corner4.x))
        local cropIncrementLength = fieldLength / Config.farms[i].cropsPerRow
        for y=1, fieldWidth, 5 do
            for x=1, fieldLength, cropIncrementLength do
                table.insert(crops, {field = Config.farms[i].name, x = Config.farms[i].corner1.x - x - y, y = Config.farms[i].corner1.y + x - y, z = Config.farms[i].corner1.z - 1, growth = 0})
            end
        end
    end

    while true do
        Wait(10) 
        if checkJob() then
            -- lockerroom marker
            DrawMarker(1, Config.lockerRoom.x, Config.lockerRoom.y, Config.lockerRoom.z - 1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 255, 128, 0, 100, false, false, 2, false, false, false, false)
            -- select vehicle marker
            if working == true then
                DrawMarker(1, Config.selectVehicle.x, Config.selectVehicle.y, Config.selectVehicle.z - 1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 255, 128, 0, 100, false, false, 2, false, false, false, false)
            end
            -- wheat sell marker
            DrawMarker(1, Config.wheatSell.x, Config.wheatSell.y, Config.wheatSell.z - 1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 255, 128, 0, 100, false, false, 2, false, false, false, false)

            -- draw markers for each crop
            for k,v in pairs(crops) do
                if v.growth <= 0 then
                    DrawMarker(1, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 255, 0, 0, 100, false, false, 2, false, false, false, false)
                elseif v.growth >= 1 and v.growth <= 99 then
                    DrawMarker(1, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 255, 255, 0, 100, false, false, 2, false, false, false, false)
                elseif v.growth >= 100 then
                    DrawMarker(1, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 0, 255, 0, 100, false, false, 2, false, false, false, false)
                end
            end
        end
    end
end)

-- check if player in markers and do stuff
CreateThread(function()
    local inLockerRoomMarker = false
    local inSelectVehicleMarker = false
    local inWheatSellMarker = false
    local inCropMarker = false

    while true do
        Wait(10)
        local playerLoc = GetEntityCoords(GetPlayerPed(-1))
        if checkJob() then
            -- locker room marker
            if(GetDistanceBetweenCoords(playerLoc, Config.lockerRoom.x, Config.lockerRoom.y, Config.lockerRoom.z, true) < 2) then
                inLockerRoomMarker = true
            else
                inLockerRoomMarker = false
            end

            -- select vehicle marker
            if(GetDistanceBetweenCoords(playerLoc, Config.selectVehicle.x, Config.selectVehicle.y, Config.selectVehicle.z, true) < 2) and working == true then
                inSelectVehicleMarker = true
            else
                inSelectVehicleMarker = false
            end

            -- wheat sell marker
            if(GetDistanceBetweenCoords(playerLoc, Config.wheatSell.x, Config.wheatSell.y, Config.wheatSell.z, true) < 2) then
                inWheatSellMarker = true
            else
                inWheatSellMarker = false
            end

            -- any crop marker
            for k,v in pairs(crops) do 
                if(GetDistanceBetweenCoords(playerLoc, v.x, v.y, v.z, true) < 2) then
                    inCropMarker = true
                end
            end
        end

        -- if in locker room marker
        if inLockerRoomMarker then
            -- create help text
            BeginTextCommandDisplayHelp("STRING");
            AddTextComponentSubstringPlayerName("Press ~INPUT_CONTEXT~ to open locker room");  
            EndTextCommandDisplayHelp (0, 0, 1, -1);
    
            if IsControlPressed(0, 38) then
                ESX.UI.Menu.Open( 'default', GetCurrentResourceName(), 'lockerroom',
                    {
                        title    = ('Locker Room'),
                        align = 'top-left',
                        elements = {
                            {label = ('Work Clothes'), value = 'workclothes'},
                            {label = ('Civilian Clothes'), value = 'civilianclothes'},
                        }
                    },
                    function(data, menu)
                        if data.current.value == 'workclothes' then
                            TriggerEvent('skinchanger:getSkin', function(skin)
                                if skin.sex == 0 then
                                    TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms.male)
                                elseif skin.sex == 1 then
                                    TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms.female)
                                end
                            end)
                            -- creates blip for each field
                            for i=1, #Config.farms, 1 do
                                farmBlip = AddBlipForCoord(Config.farms[i].mapX, Config.farms[i].mapY, Config.farms[i].mapZ)
                                SetBlipSprite(farmBlip, 86)
                                SetBlipScale(farmBlip, 1.0)
                                SetBlipColour(farmBlip, 2)
                                BeginTextCommandSetBlipName("STRING")
                                AddTextComponentString("[Farm] " .. Config.farms[i].name)
                                EndTextCommandSetBlipName(farmBlip)

                                working = true
                            end
                        elseif data.current.value == 'civilianclothes' then
                            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                                TriggerEvent('skinchanger:loadSkin', skin)
                            end)
                            RemoveBlip(farmBlip)
                            working = false
                        end
                    end,
                    function(data, menu)
                        menu.close()
                    end
                )
            end
        else
            ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'lockerroom')
        end

        -- if in select vehicle marker
        if inSelectVehicleMarker then
            -- create help text
            BeginTextCommandDisplayHelp("STRING");
            AddTextComponentSubstringPlayerName("Press ~INPUT_CONTEXT~ to open vehicle selector");  
            EndTextCommandDisplayHelp (0, 0, 1, -1);
    
            if IsControlPressed(0, 38) then
                ESX.UI.Menu.Open( 'default', GetCurrentResourceName(), 'selectvehicle',
                    {
                        title    = ('Select Vehicle'),
                        align = 'top-left',
                        elements = {
                            {label = ('Tractor'), value = 'tractor'},
                        }
                    },
                    function(data, menu)
                        if data.current.value == 'tractor' then
                            RequestModel('tractor2')
                            while not HasModelLoaded('tractor2') do
                                Wait(500)
                            end
                            local jobVehicle = CreateVehicle('tractor2', Config.selectVehicle.spawnX, Config.selectVehicle.spawnY, Config.selectVehicle.spawnZ, Config.selectVehicle.spawnHeading, true, false)
                            SetPedIntoVehicle(PlayerPedId(), jobVehicle, -1)
                            SetEntityAsNoLongerNeeded(jobVehicle)
                            SetModelAsNoLongerNeeded('tractor2')

                            RequestModel('graintrailer')
                            while not HasModelLoaded('graintrailer') do
                                Wait(500)
                            end
                            local jobTrailer = CreateVehicle('graintrailer', Config.selectVehicle.spawnX - 5, Config.selectVehicle.spawnY, Config.selectVehicle.spawnZ, Config.selectVehicle.spawnHeading, true, false)
                            SetPedIntoVehicle(PlayerPedId(), jobVehicle, -1)
                            SetEntityAsNoLongerNeeded(jobVehicle)
                            SetModelAsNoLongerNeeded('tractor2')

                            AttachVehicleToTrailer(jobVehicle, jobTrailer, 1.1)
                        end
                    end,
                    function(data, menu)
                        menu.close()
                    end
                )
            end
        else
            ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'selectvehicle')
        end

        if inWheatSellMarker then
            -- create help text
            BeginTextCommandDisplayHelp("STRING");
            AddTextComponentSubstringPlayerName("Press ~INPUT_CONTEXT~ to sell wheat");  
            EndTextCommandDisplayHelp (0, 0, 1, -1);
    
            if IsControlPressed(0, 38) then
                TriggerServerEvent("esx_communityfarming:sell")
            end
        end


        -- in in any crop marker
        if inCropMarker then
            for k,v in pairs(crops) do
                if(GetDistanceBetweenCoords(playerLoc, v.x, v.y, v.z, true) < 2) then
                    if v.growth <= 0 then
                        BeginTextCommandDisplayHelp("STRING");
                        AddTextComponentSubstringPlayerName("Press ~INPUT_CONTEXT~ to plant a new crop");  
                        EndTextCommandDisplayHelp (0, 0, 1, -1);   
                        if IsControlPressed(0, 38) then
                            RequestAnimDict("amb@world_human_gardener_plant@male@base")
                            TaskPlayAnim(GetPlayerPed(-1), "amb@world_human_gardener_plant@male@base", "base", 8.0, 8.0, 10000, 0, 0, 0, 0, 0)
                            Wait(10000)
                            v.growth = 1
                        end
                    elseif v.growth >= 1 and v.growth <= 99 then
                        BeginTextCommandDisplayHelp("STRING");
                        AddTextComponentSubstringPlayerName("Crop is currently growing: ~g~" .. v.growth .. "%");  
                        EndTextCommandDisplayHelp (0, 0, 1, -1);            
                    elseif v.growth >= 100 then
                        BeginTextCommandDisplayHelp("STRING");
                        AddTextComponentSubstringPlayerName("Press ~INPUT_CONTEXT~ to harvest crop");  
                        EndTextCommandDisplayHelp (0, 0, 1, -1);
                        if IsControlPressed(0, 38) then
                            RequestAnimDict("amb@world_human_gardener_plant@male@base")
                            TaskPlayAnim(GetPlayerPed(-1), "amb@world_human_gardener_plant@male@base", "base", 8.0, 8.0, 10000, 0, 0, 0, 0, 0)
                            Wait(10000)
                            v.growth = 0
                            TriggerServerEvent('esx_communityfarming:harvest')
                        end
                    end
                end
            end
        end
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        for k,v in pairs(crops) do
            if v.growth >= 1 and v.growth < 100 then
                v.growth = v.growth + 1
                Wait(1000)
            elseif v.growth == 100 then
                v.growth = 100
            end
        end
    end
end)

function getTableSize(t)
    local count = 0
    for _, __ in pairs(t) do
        count = count + 1
    end
    return count
end