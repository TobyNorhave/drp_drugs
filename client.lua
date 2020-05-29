local isActive = false
local isPressed = false
local isGoodToGo = false
local drugLoactions = {}
local productionLocations = {}
local sellLocations = {}

----------------------------------------------------------------------------------------------------------------------------------
----- ONLY TOUCH SHIT HERE, IF YOU KNOW WHAT YOU'RE DOING!
----------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    TriggerServerEvent("DRP_Drugs:InitAll")
end)
RegisterNetEvent("DRP_Drugs:Init")
AddEventHandler("DRP_Drugs:Init", function(blip, drug, prod, sell)
    showBlips(blip)
    drugLoactions = drug
    productionLocations = prod
    sellLocations = sell
    spawnPeds(sell)
end)

RegisterNetEvent("DRP_Drugs:GoodToGo")
AddEventHandler("DRP_Drugs:GoodToGo", function(bool)
    isGoodToGo = bool
end)

----------------------------------------------------------------------------------------------------------------------------------
----- Drug locations Thread.
----------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    local sleeper = 1000
    while true do
        for i = 1, #drugLoactions do
            local ped = PlayerPedId()
            local pedPos = GetEntityCoords(ped)
            local distance = Vdist(pedPos.x, pedPos.y, pedPos.z, drugLoactions[i].x, drugLoactions[i].y, drugLoactions[i].z)
            if distance <= 0.6 then
                sleeper = 5
                DrawText3Ds(drugLoactions[i].x, drugLoactions[i].y, drugLoactions[i].z + 0.5, tostring("~b~[E]~w~ Pick "..drugLoactions[i].type.."\n~g~[Q]~w~ Keep picking "..drugLoactions[i].type))
                if not isActive then
                    if IsControlJustPressed(1, 86) then
                        TriggerServerEvent("DRP_Drugs:PickDrug", drugLoactions[i].type, true, false)
                    elseif IsControlJustPressed(1, 44)then
                        TriggerServerEvent("DRP_Drugs:PickDrug", drugLoactions[i].type, false, true)
                    end
                end
            end
        end
        Citizen.Wait(sleeper)
    end
end)

----------------------------------------------------------------------------------------------------------------------------------
----- Getting productions Thread.
----------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    local sleeper = 1000
    while true do
        for i = 1, #productionLocations do
            local ped = PlayerPedId()
            local pedPos = GetEntityCoords(ped)
            local distance = Vdist(pedPos.x, pedPos.y, pedPos.z, productionLocations[i].x, productionLocations[i].y, productionLocations[i].z)
            if distance <= 2.0 then
                sleeper = 5
                DrawText3Ds(productionLocations[i].x, productionLocations[i].y, productionLocations[i].z + 0.5, tostring("~b~[E]~w~ Produce "..productionLocations[i].type.."\n~g~[Q]~w~ Keep producing "..productionLocations[i].type))
                if not isActive then
                    if IsControlJustPressed(1, 86) then
                        TriggerServerEvent("DRP_Drugs:ProdDrug", productionLocations[i].type, productionLocations[i].use, true, false) -- Produce one time
                    elseif IsControlJustPressed(1, 44) then
                        TriggerServerEvent("DRP_Drugs:ProdDrug", productionLocations[i].type, productionLocations[i].use, false, true) -- Keep producing
                    end
                end
            end
        end
        Citizen.Wait(sleeper)
    end
end)

----------------------------------------------------------------------------------------------------------------------------------
----- Getting sell locations Thread.
----------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    local sleeper = 1000
    while true do
        for i = 1, #sellLocations do
            local ped = PlayerPedId()
            local pedPos = GetEntityCoords(ped)
            local distance = Vdist(pedPos.x, pedPos.y, pedPos.z, sellLocations[i].coords.x, sellLocations[i].coords.y, sellLocations[i].coords.z)
            if distance <= 2.0 then
                sleeper = 5
                DrawText3Ds(sellLocations[i].coords.x, sellLocations[i].coords.y, sellLocations[i].coords.z + 0.5, tostring("~b~[E]~w~ Sell "..sellLocations[i].type.."\n~g~[Q]~w~ Keep selling "..sellLocations[i].type))
                if not isActive then
                    if IsControlJustPressed(1, 86) then
                        TriggerServerEvent("DRP_Drugs:SellDrug", sellLocations[i].type, sellLocations[i].price, true, false)
                    elseif IsControlJustPressed(1, 44) then
                        TriggerServerEvent("DRP_Drugs:SellDrug", sellLocations[i].type, sellLocations[i].price, false, true)
                    end
                end
            end
        end
        Citizen.Wait(sleeper)
    end
end)

----------------------------------------------------------------------------------------------------------------------------------
----- Start picking Event.
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
        while not isPressed do 
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
----- Start production Event.
----------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("DRP_Drugs:DrugLocationProd")
AddEventHandler("DRP_Drugs:DrugLocationProd", function(prod, auto, amountToGet, amountToProd, type, use, timeToDoStuff)
    local sleeper = 100
    local itemCounter = 0
    if prod then
        isActive = true
        TriggerServerEvent("DRP_Drugs:CheckInv", use, amountToProd)
        Citizen.Wait(300)
        if isGoodToGo then
            exports['drp_progressBars']:startUI(timeToDoStuff, "Producing "..type.." - X"..amountToGet)
            TaskStartScenarioInPlace(PlayerPedId(), 'PROP_HUMAN_PARKING_METER', 0, true)
            Citizen.Wait(timeToDoStuff)
            ClearPedTasksImmediately(GetPlayerPed(-1))
            TriggerServerEvent("DRP_Inventory:addInventoryItem", type, amountToGet)
            TriggerEvent("DRP_Core:Success", type, tostring("You got "..amountToGet.."g "..type),2500,false,"leftCenter")
            Citizen.Wait(sleeper)
        end
    elseif auto then
        while not isPressed do 
            isActive = true
            TriggerServerEvent("DRP_Drugs:CheckInv", use, amountToProd)
            Citizen.Wait(300)
            if isGoodToGo then
                exports['drp_progressBars']:startUI(timeToDoStuff, "Producing "..type.." - X"..amountToGet)
                TaskStartScenarioInPlace(PlayerPedId(), 'PROP_HUMAN_PARKING_METER', 0, true)
                Citizen.Wait(timeToDoStuff)
                ClearPedTasksImmediately(GetPlayerPed(-1))
                TriggerServerEvent("DRP_Inventory:addInventoryItem", type, amountToGet)
                TriggerEvent("DRP_Core:Success", type, tostring("You got "..amountToGet.."g "..type),2500,false,"leftCenter")
                itemCounter = itemCounter + amountToGet
                if isPressed then
                    TriggerEvent("DRP_Core:Info", type, tostring("You got "..itemCounter.."g "..type),2500,false,"leftCenter")
                end
            end
            Citizen.Wait(sleeper)
        end
    end
    isGoodToGo = false
    isPressed = false
    isActive = false
end)

----------------------------------------------------------------------------------------------------------------------------------
----- Start selling Event.
----------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("DRP_Drugs:SellLocationDrug")
AddEventHandler("DRP_Drugs:SellLocationDrug", function(sell, auto, amountToGet, price, type, timeToDoStuff)
    local sleeper = 100
    local itemCounter = 0
    local cashRecived = 0
    if sell then
        isActive = true
        TriggerServerEvent("DRP_Drugs:CheckInv", type, amountToGet)
        if isGoodToGo then
            --selling(timeToDoStuff, type, amountToGet, price)
            exports['drp_progressBars']:startUI(timeToDoStuff, "Selling "..type.." - X"..amountToGet)
            TaskStartScenarioInPlace(PlayerPedId(), 'PROP_HUMAN_PARKING_METER', 0, true)
            Citizen.Wait(timeToDoStuff)
            ClearPedTasksImmediately(GetPlayerPed(-1))
            TriggerServerEvent("DRP_Drugs:AddDirtyMoney", price)
            TriggerEvent("DRP_Core:Success", type, tostring("You got "..price.."$ for "..amountToGet.."g "..type),2500,false,"leftCenter")
            Citizen.Wait(sleeper)
        end
    elseif auto then
        while not isPressed do 
            isActive = true
            TriggerServerEvent("DRP_Drugs:CheckInv", type, amountToGet)
            Citizen.Wait(500)
            if isGoodToGo then
                exports['drp_progressBars']:startUI(timeToDoStuff, "Selling "..type.." - X"..amountToGet)
                TaskStartScenarioInPlace(PlayerPedId(), 'PROP_HUMAN_PARKING_METER', 0, true)
                Citizen.Wait(timeToDoStuff)
                ClearPedTasksImmediately(GetPlayerPed(-1))
                TriggerEvent("DRP_Core:Success", type, tostring("You got "..price.."$ for "..amountToGet.."g "..type),2500,false,"leftCenter")
                itemCounter = itemCounter + amountToGet
                cashRecived = cashRecived + price
                if isPressed then
                    TriggerServerEvent("DRP_Drugs:AddDirtyMoney", cashRecived)
                    TriggerEvent("DRP_Core:Info", type, tostring("You got "..cashRecived.."$ for "..itemCounter.."g "..type),2500,false,"leftCenter")
                end
            end
            Citizen.Wait(sleeper)
        end
    end
    isGoodToGo = false
    isPressed = false
    isActive = false
end)

----------------------------------------------------------------------------------------------------------------------------------
----- Commands / the only one ^^
----------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("stop", function()
    isPressed = true
end, false)
