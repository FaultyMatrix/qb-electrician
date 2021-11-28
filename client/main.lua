local QBCore = exports['qb-core']:GetCoreObject()
local PlayerJob = {}
CompleteRepairs = 0
JobsinSession = {}

local function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

-- Blip Function
local function SetJobBlip(title)
    local JobBlip = AddBlipForCoord(Config.Locations[title].coords.x, Config.Locations[title].coords.y, Config.Locations[title].coords.z)
    SetBlipSprite(JobBlip, 354)
    SetBlipDisplay(JobBlip, 4)
    SetBlipScale(JobBlip, 0.8)
    SetBlipAsShortRange(JobBlip, true)
    SetBlipColour(JobBlip, 5)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Config.Locations[title].label)
    EndTextCommandSetBlipName(JobBlip)
end

-- Job Blip Function
local function SetWorkBlip(d)
    for k, v in pairs(Config.Locations["jobset" ..d]) do
        WorkBlip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
        SetBlipSprite(WorkBlip, 143)
        SetBlipDisplay(WorkBlip, 4)
        SetBlipScale(WorkBlip, 0.5)
        SetBlipAsShortRange(WorkBlip, true)
        SetBlipColour(WorkBlip, 26)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(v.name)
        EndTextCommandSetBlipName(WorkBlip)
        table.insert(JobsinSession, {id = k, x = v.coords.x, y = v.coords.y, z = v.coords.z, BlipId = WorkBlip})
    end
    TriggerEvent('qb-electrician:client:JobMarkers')
end


-- Checks if car is a Job Vehicle
local function VehicleCheck(vehicle)
    local retval = false
    for k, v in pairs(Config.JobVehicles) do
        print(v)
        if GetEntityModel(vehicle) == GetHashKey(v) then
            retval = true
        end
    end
    return retval
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerJob = QBCore.Functions.GetPlayerData().job
end)

-- Randomly selects a Vehicle from the Config List
RegisterNetEvent('qb-electrician:client:VehPick', function()
    local choice = math.random(1, #Config.JobVehicles)
    ElecVeh = Config.JobVehicles[choice]
    TriggerEvent('qb-electrician:client:SpawnVehicle', ElecVeh)
end)

CreateThread(function()
    if Config.ShowBlip then
        SetJobBlip("job")
    end
end)

-- Markers for Job Vehicle
CreateThread(function()
    local inRange = false
    while true do
        Wait(0)
        local pos = GetEntityCoords(PlayerPedId())
        -- if PlayerJob.name == "electrician" then
            if #(pos - vector3(Config.Locations["vehicle"].coords.x, Config.Locations["vehicle"].coords.y, Config.Locations["vehicle"].coords.z)) < 10 then
                inRange = true
                DrawMarker(2, Config.Locations["vehicle"].coords.x, Config.Locations["vehicle"].coords.y, Config.Locations["vehicle"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                if #(pos - vector3(Config.Locations["vehicle"].coords.x, Config.Locations["vehicle"].coords.y, Config.Locations["vehicle"].coords.z)) < 1.5 then
                    if IsPedInAnyVehicle(PlayerPedId(), false) then
                        DrawText3D(Config.Locations["vehicle"].coords.x, Config.Locations["vehicle"].coords.y, Config.Locations["vehicle"].coords.z, "~g~E~w~ - Store Vehicle")
                    else
                        DrawText3D(Config.Locations["vehicle"].coords.x, Config.Locations["vehicle"].coords.y, Config.Locations["vehicle"].coords.z, "~g~E~w~ - Retrieve Vehicle")
                    end
                    if IsControlJustReleased(0, 38) then
                        if IsPedInAnyVehicle(PlayerPedId(), false) then
                            if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId() then
                                if VehicleCheck(GetVehiclePedIsIn(PlayerPedId(), false)) then
                                    DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
                                    for k,v in ipairs(JobsinSession) do
                                        RemoveBlip(v.BlipId)
                                    end
                                else
                                    QBCore.Functions.Notify('This is not an electrician vehicle!', 'error')
                                end
                            else
                                QBCore.Functions.Notify('You must be the driver to do this!', 'error')
                            end
                        else
                            TriggerEvent('qb-electrician:client:VehPick')
                        end
                    end  
                end
            end
            if not inRange then
                Wait(1000)
            end
        -- end
    end
end)

-- Spawns Electrician Vehicle
RegisterNetEvent('qb-electrician:client:SpawnVehicle', function(vehicleInfo)
    local coords = Config.Locations["vehicle"].coords
    QBCore.Functions.SpawnVehicle(vehicleInfo, function(veh)
        SetVehicleNumberPlateText(veh, "ELEC"..tostring(math.random(1000, 9999)))
        SetEntityHeading(veh, coords.w)
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        SetEntityAsMissionEntity(veh, true, true)
        TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
        SetVehicleEngineOn(veh, true, true)
        CurrentPlate = QBCore.Functions.GetPlate(veh)
        StartJobLocations()
    end, coords, true)
end)

function StartJobLocations()
    jobchoice = math.random(1,5)
    SetWorkBlip(jobchoice)
    QBCore.Functions.Notify("Your jobs have been added to your GPS - Go and complete your work.", "primary")
end

-- Individual Job Site Interactions
RegisterNetEvent('qb-electrician:client:JobMarkers', function(k, v)
    local inRange = false
    CompleteRepairs = 0
    while true do
        Wait(0)
        for k, v in ipairs(JobsinSession) do
            local pos = GetEntityCoords(PlayerPedId())
            if CompleteRepairs < 5 then
                -- if PlayerJob.name == "electrician" then
                    if #(pos - vector3(v.x, v.y, v.z)) < 10 then
                        inRange = true
                        DrawMarker(2, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                        if #(pos - vector3(v.x, v.y, v.z)) < 1.5 then
                            DrawText3D(v.x, v.y, v.z, "~g~E~w~ - Repair Electrical Fault")
                            if IsControlJustReleased(0, 38) then
                                QBCore.Functions.Progressbar("repair_work", "Repairing Fault...", math.random(10000, 12000), false, true, {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {
                                    animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                                    anim = "machinic_loop_mechandplayer",
                                    flags = 49,
                                }, {}, {}, function() -- Done
                                    CompleteRepairs = CompleteRepairs + 1
                                    print(CompleteRepairs)
                                    if CompleteRepairs <= 4 then
                                        QBCore.Functions.Notify("You've repaired the electrical fault. Head to the next job.")
                                    else
                                        QBCore.Functions.Notify("You've finished all your jobs - Return your vehicle and collect your payslip.")
                                    end
                                    RemoveBlip(v.BlipId)
                                    table.remove(JobsinSession, k)
                                end, function() -- Cancel
                                    StopAnimTask(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
                                    QBCore.Functions.Notify("Cancelled..", "error")
                                end)
                            end  
                        end
                    end
                    if not inRange then
                        Wait(1000)
                    end
                -- end
            end
        end
    end
end)

CreateThread(function()
    local pos = GetEntityCoords(PlayerPedId())
    local inRange = false
    while true do
        Wait(0)
        local pos = GetEntityCoords(PlayerPedId())
        -- if PlayerJob.name == "electrician" then
            if #(pos - vector3(Config.Locations["payslip"].coords.x, Config.Locations["payslip"].coords.y, Config.Locations["payslip"].coords.z)) < 10 then
                inRange = true
                DrawMarker(2, Config.Locations["payslip"].coords.x, Config.Locations["payslip"].coords.y, Config.Locations["payslip"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                if #(pos - vector3(Config.Locations["payslip"].coords.x, Config.Locations["payslip"].coords.y, Config.Locations["payslip"].coords.z)) < 1.5 then
                    DrawText3D(Config.Locations["payslip"].coords.x, Config.Locations["payslip"].coords.y, Config.Locations["payslip"].coords.z, "~g~E~w~ - Payslip")
                    if IsControlJustReleased(0, 38) then
                        if CompleteRepairs ~= 0 then
                            TriggerServerEvent('qb-electrician:server:Payslip', CompleteRepairs)
                            CompleteRepairs = 0
                            for k,v in ipairs(JobsinSession) do
                                RemoveBlip(v.BlipId)
                            end
                        else
                            QBCore.Functions.Notify("You haven't done any jobs yet!", "error")
                        end
                        
                    end  
                end
            end
            if not inRange then
                Wait(1000)
            end
        -- end
    end
end)
