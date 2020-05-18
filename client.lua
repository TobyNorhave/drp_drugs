local isActive = false
local isPressed = false
local drugLoactions = {}
local productionLocations = {}
local sellLocations = {}
-----------------------------------------------------------------------------------------------------------------------------------
----- Set you're blips here.
-----------------------------------------------------------------+-----------------------------------------------------------------
local blips = { 
    {x =360.27, y =6479.0, z =29.36, blipId = 403, name = "Coke Field"},
    {x = 1391.89, y =3605.6, z =38.94, blipId = 514, name = "Coke Production"}
}

-----------------------------------------------------------------------------------------------------------------------------------
----- ONLY TOUCH SHIT HERE, IF YOU KNOW WHAT YOU'RE DOING!
----- Creating blips on the map.
-----------------------------------------------------------------+-----------------------------------------------------------------
Citizen.CreateThread(function()
    TriggerServerEvent("DRP_Drugs:InitAll")
end)
RegisterNetEvent("DRP_Drugs:Init")
AddEventHandler("DRP_Drugs:Init", function(drug, prod, sell)
    drugLoactions = drug
    productionLocations = prod
    sellLocations = sell
end)

-----------------------------------------------------------------------------------------------------------------------------------
----- Sets blips on the map.
-----------------------------------------------------------------+-----------------------------------------------------------------
Citizen.CreateThread(function()
    for k, v in pairs(blips) do
        local blip = AddBlipForCoord(v.x, v.y, v.z)
        print(v.x)
        SetBlipSprite(blip, v.blipId)
        SetBlipAsShortRange(blip, true)
        SetBlipScale(blip, 0.8)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(v.name)
        EndTextCommandSetBlipName(blip)
    end
    Citizen.Wait(1)
end)

----------------------------------------------------------------------------------------------------------------------------------
----- Drug locations.
----------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    local sleepTimer = 1000
    while true do
        for k, v in pairs (drugLoactions) do
            local ped = PlayerPedId()
            local pedPos = GetEntityCoords(ped)
            local distance = Vdist(pedPos.x, pedPos.y, pedPos.z, v.x, v.y, v.z)
            if distance <= 0.6 then
                sleepTimer = 5
                exports['drp_core']:DrawText3Ds(v.x, v.y, v.z + 0.5, tostring("~b~[E]~w~ Pick "..v.type.."\n~g~[Q]~w~ Keep picking "..v.type))
                if isActive == false then
                    if IsControlJustPressed(1, 86) then
                        TriggerServerEvent("DRP_Drugs:PickDrug", v.type, true, false)
                    elseif IsControlJustPressed(1, 44)then
                        TriggerServerEvent("DRP_Drugs:PickDrug", v.type, false, true)
                    end
                end
            end
        end
        Citizen.Wait(sleepTimer)
    end
end)

----------------------------------------------------------------------------------------------------------------------------------
----- Getting productions.
----------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    local sleepTimer = 1000
    while true do
        for k, v in pairs (productionLocations) do
            local ped = PlayerPedId()
            local pedPos = GetEntityCoords(ped)
            local distance = Vdist(pedPos.x, pedPos.y, pedPos.z, v.x, v.y, v.z)
            if distance <= 2.0 then
                sleepTimer = 5
                exports['drp_core']:DrawText3Ds(v.x, v.y, v.z + 0.5, tostring("~b~[E]~w~ Produce "..v.type.."\n~g~[Q]~w~ Keep producing "..v.type))
                if isActive == false then
                    if IsControlJustPressed(1, 86) then
                        TriggerServerEvent("DRP_Drugs:ProdDrug", v.type, v.use, true, false) -- Produce one time
                    elseif IsControlJustPressed(1, 44) then
                        TriggerServerEvent("DRP_Drugs:ProdDrug", v.type, v.use, false, true) -- Jeep producing
                    end
                end
            end
        end
        Citizen.Wait(sleepTimer)
    end
end)

----------------------------------------------------------------------------------------------------------------------------------
----- Getting sell locations
----------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    local sleepTimer=1000
    while true do
        for k, v in pairs (sellLocations) do
            local ped = PlayerPedId()
            local pedPos = GetEntityCoords(ped)
            local distance = Vdist(pedPos.x, pedPos.y, pedPos.z, v.x, v.y, v.z)
            if distance <= 2.0 then
                sleepTimer = 5
                exports['drp_core']:DrawText3Ds(v.x, v.y, v.z + 0.5, tostring("~b~[E]~w~ Sell "..v.type.."\n~g~[Q]~w~ Keep selling "..v.type))
                if IsControlJustPressed(1, 86) then
                    TriggerServerEvent("DRP_Drugs:SellDrug", v.type, v.price, true, false)
                elseif IsControlJustPressed(1, 44) then
                    TriggerServerEvent("DRP_Drugs:SellDrug", v.type, v.price, false, true)
                end
            end
        end
        Citizen.Wait(sleepTimer)
    end
end)

----------------------------------------------------------------------------------------------------------------------------------
----- Peds for Drug sell locations.
----------------------------------------------------------------------------------------------------------------------------------
-- Citizen.CreateThread(function()
--     local sleeper = 10
--     for k,v in pairs(sellLocations) do
--         local lmodel = (v.ishash) and v.model or GetHashKey(v.model)
--         RequestModel(v.ishash)
--         print(lmodel)
--         while not HasModelLoaded(lmodel) do
--             Wait(sleeper)
--         end
--         local lPed = CreatePed(4, lmodel, v.x, v.y, v.z, v.h, false, false)
--         SetEntityInvincible(lPed, true)
--         FreezeEntityPosition(lPed, true)
--         SetBlockingOfNonTemporaryEvents(lPed, true)
--         --SetAmbientVoiceName(lPed, v.voice)
--         if v.dict ~= nil then
--             loadAnimDict(v.dict)
--             TaskPlayAnim(lPed, v.dict, false, 8.0, 0.0, -1, 1, 0, 0, 0, 0)
--         else
--             TaskStartScenarioInPlace(lPed, "WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT", 0, 0)
--         end
--         SetModelAsNoLongerNeeded(lmodel)
--     end
-- end)

----------------------------------------------------------------------------------------------------------------------------------
----- Start picking
----------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("DRP_Drugs:DrugLocationPick")
AddEventHandler("DRP_Drugs:DrugLocationPick", function(pick, auto, amountToGet, type, timeToDoStuff)
    local sleeper = 100
    local itemCounter = 0
    if pick then
        isActive = true
        exports['drp_progressBars']:startUI(timeToDoStuff, "Picking "..type.." - X"..amountToGet)
        TaskStartScenarioInPlace(PlayerPedId(), 'PROP_HUMAN_PARKING_METER', 0, true)
        Citizen.Wait(timeToDoStuff)
        ClearPedTasksImmediately(GetPlayerPed(-1))
        TriggerServerEvent("DRP_Inventory:addInventoryItem", type, amountToGet)
        TriggerEvent("DRP_Core:Success", type, tostring("You got "..amountToGet.."g "..type),2500,false,"leftCenter")
        Citizen.Wait(sleeper)
    elseif auto then
        while isPressed == false do 
            isActive = true
            exports['drp_progressBars']:startUI(timeToDoStuff, "Picking "..type.." - X"..amountToGet)
            TaskStartScenarioInPlace(PlayerPedId(), 'PROP_HUMAN_PARKING_METER', 0, true)
            Citizen.Wait(timeToDoStuff)
            ClearPedTasksImmediately(GetPlayerPed(-1))
            TriggerServerEvent("DRP_Inventory:addInventoryItem", type, amountToGet)
            TriggerEvent("DRP_Core:Success", type, tostring("You got "..amountToGet.."g "..type),2500,false,"leftCenter")
            itemCounter = itemCounter + amountToGet
            if isPressed then
                TriggerEvent("DRP_Core:Info", type, tostring("You got "..itemCounter.."g "..type),2500,false,"leftCenter")
            end
            Citizen.Wait(sleeper)
        end
    end
    isPressed = false
    isActive = false
end)

----------------------------------------------------------------------------------------------------------------------------------
----- Start production
----------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("DRP_Drugs:DrugLocationProd")
AddEventHandler("DRP_Drugs:DrugLocationProd", function(prod, auto, amountToGet, amountToProd, type, use, timeToDoStuff)
    local sleeper = 100
    local itemCounter = 0
    if prod then
        isActive = true
        exports['drp_progressBars']:startUI(timeToDoStuff, "Producing "..type.." - X"..amountToGet)
        TaskStartScenarioInPlace(PlayerPedId(), 'PROP_HUMAN_PARKING_METER', 0, true)
        Citizen.Wait(timeToDoStuff)
        ClearPedTasksImmediately(GetPlayerPed(-1))
        TriggerServerEvent("DRP_Inventory:addInventoryItem", type, amountToGet)
        TriggerEvent("DRP_Core:Success", type, tostring("You got "..amountToGet.."g "..type),2500,false,"leftCenter")
        Citizen.Wait(sleeper)
    elseif auto then
        while isPressed == false do 
            isActive = true
            exports['drp_progressBars']:startUI(timeToDoStuff, "Producing "..type.." - X"..amountToGet)
            TaskStartScenarioInPlace(PlayerPedId(), 'PROP_HUMAN_PARKING_METER', 0, true)
            Citizen.Wait(timeToDoStuff)
            ClearPedTasksImmediately(GetPlayerPed(-1))
            TriggerServerEvent("DRP_Inventory:removeInventoryItem", use, amountToProd)
            TriggerServerEvent("DRP_Inventory:addInventoryItem", type, amountToGet)
            TriggerEvent("DRP_Core:Success", type, tostring("You got "..amountToGet.."g "..type),2500,false,"leftCenter")
            itemCounter = itemCounter + amountToGet
            if isPressed then
                TriggerEvent("DRP_Core:Info", type, tostring("You got "..itemCounter.."g "..type),2500,false,"leftCenter")
            end
            Citizen.Wait(sleeper)
        end
    end
    isPressed = false
    isActive = false
end)

----------------------------------------------------------------------------------------------------------------------------------
----- Start selling
----------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("DRP_Drugs:SellLocationDrug")
AddEventHandler("DRP_Drugs:SellLocationDrug", function(sell, auto, amountToGet, price, type, timeToDoStuff)
    local sleeper = 100
    local itemCounter = 0
    local cashRecived = 0
    if sell then
        exports['drp_progressBars']:startUI(timeToDoStuff, "Selling "..type.." - X"..amountToGet)
            TaskStartScenarioInPlace(PlayerPedId(), 'PROP_HUMAN_PARKING_METER', 0, true)
            Citizen.Wait(timeToDoStuff)
            ClearPedTasksImmediately(GetPlayerPed(-1))
            TriggerServerEvent("DRP_Inventory:removeInventoryItem", type, amountToGet)
            --- TriggerEvent("DRP", ) -----
            TriggerEvent("DRP_Core:Success", type, tostring("You got "..price.."$ for "..amountToGet.."g "..type),2500,false,"leftCenter")
            Citizen.Wait(sleeper)
    elseif auto then
        while isPressed == false do 
            isActive = true
            exports['drp_progressBars']:startUI(timeToDoStuff, "Selling "..type.." - X"..amountToGet)
            TaskStartScenarioInPlace(PlayerPedId(), 'PROP_HUMAN_PARKING_METER', 0, true)
            Citizen.Wait(timeToDoStuff)
            ClearPedTasksImmediately(GetPlayerPed(-1))
            TriggerServerEvent("DRP_Inventory:removeInventoryItem", type, amountToGet)
            --- TriggerEvent("DRP", ) -----
            TriggerEvent("DRP_Core:Success", type, tostring("You got "..price.."$ for "..amountToGet.."g "..type),2500,false,"leftCenter")
            itemCounter = itemCounter + amountToGet
            cashRecived = cashRecived + price
            if isPressed then
                TriggerEvent("DRP_Core:Info", type, tostring("You got "..cashRecived.."$ for "..itemCounter.."g "..type),2500,false,"leftCenter")
            end
            Citizen.Wait(sleeper)
        end
    end
    isPressed = false
    isActive = false
end)

----------------------------------------------------------------------------------------------------------------------------------
----- Commands / the only one ^^
----------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("stop", function()
    isPressed = true
end, false)
