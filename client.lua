local isActive = false
local isPressed = false
----------------------------------------------------------------------------------------------------------------------------------
----- Creating blips on the map.
----------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
        for i=1, #DRPDrugs.Blips do
            local blip = AddBlipForCoord(DRPDrugs.Blips[i].x, DRPDrugs.Blips[i].y, DRPDrugs.Blips[i].z)
            SetBlipSprite(blip, DRPDrugs.Blips[i].blipId)
            SetBlipAsShortRange(blip, true)
            SetBlipScale(blip, 0.8)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName(DRPDrugs.Blips[i].name)
            EndTextCommandSetBlipName(blip)
        end
    Citizen.Wait(1)
end)

----------------------------------------------------------------------------------------------------------------------------------
----- Server & Client shite.
----------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("stop", function()
    isPressed = true
end, false)

----------------------------------------------------------------------------------------------------------------------------------
----- Start picking if backpack is not full.
----------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("DRP_Drugs:DrugLocationPick")
AddEventHandler("DRP_Drugs:DrugLocationPick", function(bool, amountToGet, type, backpackSpace, timeToDoStuff)
    if bool then
        isActive = true
        exports['drp_progressBars']:startUI(timeToDoStuff, "Picking "..type.." - X"..backpackSpace.." left")
        TaskStartScenarioInPlace(PlayerPedId(), 'PROP_HUMAN_PARKING_METER', 0, true)
        Citizen.Wait(timeToDoStuff)
        ClearPedTasksImmediately(GetPlayerPed(-1))
        TriggerEvent("DRP_Core:Success", type, tostring("You got "..amountToGet.."g "..type),2500,false,"leftCenter")
        print(tostring(backpackSpace))
    end
    isActive = false
end)

----------------------------------------------------------------------------------------------------------------------------------
----- FUCKING WORKS TOBY!! - DON'T TOUCH IT!!!!
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
----- Start auto picking if backpack is not full.
----------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("DRP_Drugs:DrugLocationPickAuto")
AddEventHandler("DRP_Drugs:DrugLocationPickAuto", function(bool, amountToGet, type, backpackSpace, timeToDoStuff)
    local drugReviced = 0
    if bool then
         while backpackSpace ~= 0 do
            isActive = true
            exports['drp_progressBars']:startUI(timeToDoStuff, "Picking "..type.." - X"..backpackSpace.." left")
            TaskStartScenarioInPlace(PlayerPedId(), 'PROP_HUMAN_PARKING_METER', 0, true)
            Citizen.Wait(timeToDoStuff)
            ClearPedTasksImmediately(GetPlayerPed(-1))
            TriggerEvent("DRP_Core:Success", type, tostring("You got "..amountToGet.."g "..type),2500,false,"leftCenter")
            print(tostring(backpackSpace))
            Citizen.Wait(100)
            backpackSpace = backpackSpace - amountToGet
            drugReviced = drugReviced + amountToGet
            if isPressed then
                TriggerServerEvent("DRP_Drugs:AmountWhenQuitAutoPick", drugReviced, backpackSpace, type)
                Citizen.Wait(100)
                backpackSpace = 0
                ClearPedTasksImmediately(GetPlayerPed(-1))
            end
        end
    end
    isPressed = false
    isActive = false
end)

----------------------------------------------------------------------------------------------------------------------------------
----- FUCKING WORKS TOBY!! - DON'T TOUCH IT!!!!
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
----- Drug locations.
----------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    local sleepTimer = 1000
    while true do
        for i=1, #DRPDrugs.Locations do
            local ped = PlayerPedId()
            local pedPos = GetEntityCoords(ped)
            local distance = Vdist(pedPos.x, pedPos.y, pedPos.z, DRPDrugs.Locations[i].x, DRPDrugs.Locations[i].y, DRPDrugs.Locations[i].z)
            if distance <= 1.0 then
                sleepTimer = 5
                exports['drp_core']:DrawText3Ds(DRPDrugs.Locations[i].x, DRPDrugs.Locations[i].y, DRPDrugs.Locations[i].z + 0.5, tostring("~b~[E]~w~ Pick "..DRPDrugs.Locations[i].type.."\n~g~[Q]~w~ Keep picking "..DRPDrugs.Locations[i].type))
                if isActive == false then
                    if IsControlJustPressed(1, 86) then
                        TriggerServerEvent("DRP_Drugs:PickDrug", DRPDrugs.Locations[i].type)
                    elseif IsControlJustPressed(1, 44)then
                        TriggerServerEvent("DRP_Drugs:PickDrugAuto", DRPDrugs.Locations[i].type)
                    end
                end
            end
        end
        Citizen.Wait(sleepTimer)
    end
end)

----------------------------------------------------------------------------------------------------------------------------------
----- Start production if backpack is not full and item is available.
----------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("DRP_Drugs:DrugLocationProd")
AddEventHandler("DRP_Drugs:DrugLocationProd", function(bool, amountToGet, type, canProduce, timeToDoStuff)
    if bool then
        isActive = true
        exports['drp_progressBars']:startUI(timeToDoStuff, "Producing "..type.." - X"..canProduce.." left")
        TaskStartScenarioInPlace(PlayerPedId(), 'PROP_HUMAN_PARKING_METER', 0, true)
        Citizen.Wait(timeToDoStuff)
        ClearPedTasksImmediately(GetPlayerPed(-1))
        TriggerEvent("DRP_Core:Success", type, tostring("You got "..amountToGet.."g "..type),2500,false,"leftCenter")
        print(tostring(canProduce))
    end
    isActive = false
end)

----------------------------------------------------------------------------------------------------------------------------------
----- Start auto producing if backpack is not full.
----------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("DRP_Drugs:DrugLocationProdAuto")
AddEventHandler("DRP_Drugs:DrugLocationProdAuto", function(bool, amountToGet, type, canProduce, timeToDoStuff)
    local drugReviced = 0
    if bool then
         while canProduce ~= 0 do
            isActive = true
            exports['drp_progressBars']:startUI(timeToDoStuff, "Producing "..type.." - X"..canProduce.." left")
            TaskStartScenarioInPlace(PlayerPedId(), 'PROP_HUMAN_PARKING_METER', 0, true)
            Citizen.Wait(timeToDoStuff)
            ClearPedTasksImmediately(GetPlayerPed(-1))
            TriggerEvent("DRP_Core:Success", type, tostring("You got "..amountToGet.."g "..type),2500,false,"leftCenter")
            print(tostring(canProduce))
            Citizen.Wait(100)
            canProduce = canProduce - amountToGet
            drugReviced = drugReviced + amountToGet
            if isPressed then
                TriggerServerEvent("DRP_Drugs:AmountWhenQuitAutoProd", drugReviced, canProduce, type)
                Citizen.Wait(100)
                canProduce = 0
                ClearPedTasksImmediately(GetPlayerPed(-1))
            end
        end
    end
    isPressed = false
    isActive = false
end)

----------------------------------------------------------------------------------------------------------------------------------
----- GOTTA BE REFACTORET! - Gotte simplify stuff before release
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
----- Getting productions.
----------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    local sleepTimer = 1000
    while true do
        for i=1, #DRPDrugs.Productions do
            local ped = PlayerPedId()
            local pedPos = GetEntityCoords(ped)
            local distance = Vdist(pedPos.x, pedPos.y, pedPos.z, DRPDrugs.Productions[i].x, DRPDrugs.Productions[i].y, DRPDrugs.Productions[i].z)
            if distance <= 2.0 then
                sleepTimer = 5
                exports['drp_core']:DrawText3Ds(DRPDrugs.Productions[i].x, DRPDrugs.Productions[i].y, DRPDrugs.Productions[i].z + 0.5, tostring("~b~[E]~w~ Produce "..DRPDrugs.Productions[i].type.."\n~g~[Q]~w~ Keep producing "..DRPDrugs.Productions[i].type))
                if isActive == false then
                    if IsControlJustPressed(1, 86) then
                        TriggerServerEvent("DRP_Drugs:ProdDrug", DRPDrugs.Productions[i].type)
                    elseif IsControlJustPressed(1, 44) then
                        TriggerServerEvent("DRP_Drugs:ProdDrugAuto", DRPDrugs.Productions[i].type)
                    end
                end
            end
        end
        Citizen.Wait(sleepTimer)
    end
end)

----------------------------------------------------------------------------------------------------------------------------------
----- Getting SellLocations
----------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    local sleepTimer=1000
    while true do
        for i=1, #DRPDrugs.SellLocations do
            local ped = PlayerPedId()
            local pedPos = GetEntityCoords(ped)
            local distance = Vdist(pedPos.x, pedPos.y, pedPos.z, DRPDrugs.SellLocations[i].x, DRPDrugs.SellLocations[i].y, DRPDrugs.SellLocations[i].z)
            if distance <= 2.0 then
                sleepTimer = 5
                exports['drp_core']:DrawText3Ds(DRPDrugs.SellLocations[i].x, DRPDrugs.SellLocations[i].y, DRPDrugs.SellLocations[i].z + 0.5, tostring("~b~[E]~w~ Sell "..DRPDrugs.SellLocations[i].type.."\n~g~[Q]~w~ Keep selling "..DRPDrugs.SellLocations[i].type))
                if IsControlJustPressed(1, 86) then
                    exports['drp_progressBars']:startUI(time, "Selling "..DRPDrugs.SellLocations[i].type)
                    TaskStartScenarioInPlace(PlayerPedId(), 'PROP_HUMAN_PARKING_METER', 0, true)
                    Citizen.Wait(time)
                    ClearPedTasksImmediately(GetPlayerPed(-1))
                    --NEEDS TO BE CHANGED TO
                    TriggerEvent("DRP_Core:Success", DRPDrugs.SellLocations[i].type, tostring("You got "..dirtyMoney.."$ for "..amountToGet.."g "..DRPDrugs.SellLocations[i].type),2500,false,"leftCenter")
                elseif IsControlJustPressed(1, 44) then
                    --NEEDS TO BE CHANGED
                    exports['drp_progressBars']:startUI(time, "Selling "..DRPDrugs.SellLocations[i].type)
                    TaskStartScenarioInPlace(PlayerPedId(), 'PROP_HUMAN_PARKING_METER', 0, true)
                    Citizen.Wait(time)
                    ClearPedTasksImmediately(GetPlayerPed(-1))
                    --NEEDS TO BE CHANGED TO
                    TriggerEvent("DRP_Core:Success", DRPDrugs.SellLocations[i].type, tostring("You got "..dirtyMoney.."$ for "..amountToGet.."g "..DRPDrugs.SellLocations[i].type),2500,false,"leftCenter")
                end
            end
        end
        Citizen.Wait(sleepTimer)
    end
end)

----------------------------------------------------------------------------------------------------------------------------------
----- Peds for Drug sell locations.
----------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    local sleepTimer = 10
    for i=1, #DRPDrugs.SellLocations do
        local lmodel = (DRPDrugs.SellLocations[i].ishash) and DRPDrugs.SellLocations[i].model or GetHashKey(DRPDrugs.SellLocations[i].model)
        RequestModel(lmodel)
        while not HasModelLoaded(lmodel) do
            Citizen.Wait(sleepTimer)
        end
        local lPed = CreatePed(4, lmodel, DRPDrugs.SellLocations[i].x, DRPDrugs.SellLocations[i].y, DRPDrugs.SellLocations[i].z + -1.0, DRPDrugs.SellLocations[i].h, false, false)
        SetEntityInvincible(lPed, true)
        FreezeEntityPosition(lPed, true)
        SetBlockingOfNonTemporaryEvents(lPed, true)
        SetAmbientVoiceName(lPed, DRPDrugs.SellLocations[i].voice)
        TaskStartScenarioInPlace(lPed, "WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT", 0, 0)
        SetModelAsNoLongerNeeded(lmodel)
    end
end)