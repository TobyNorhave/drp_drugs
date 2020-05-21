local isActive = false
local isPressed = false
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

----------------------------------------------------------------------------------------------------------------------------------
----- Drug locations Thread.
----------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    local sleeper = 1000
    while true do
        for k, v in pairs(drugLoactions) do
            local ped = PlayerPedId()
            local pedPos = GetEntityCoords(ped)
            local distance = Vdist(pedPos.x, pedPos.y, pedPos.z, v.x, v.y, v.z)
            if distance <= 0.6 then
                sleeper = 5
                DrawText3Ds(v.x, v.y, v.z + 0.5, tostring("~b~[E]~w~ Pick "..v.type.."\n~g~[Q]~w~ Keep picking "..v.type))
                if isActive == false then
                    if IsControlJustPressed(1, 86) then
                        TriggerServerEvent("DRP_Drugs:PickDrug", v.type, true, false)
                    elseif IsControlJustPressed(1, 44)then
                        TriggerServerEvent("DRP_Drugs:PickDrug", v.type, false, true)
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
        for k, v in pairs(productionLocations) do
            local ped = PlayerPedId()
            local pedPos = GetEntityCoords(ped)
            local distance = Vdist(pedPos.x, pedPos.y, pedPos.z, v.x, v.y, v.z)
            if distance <= 2.0 then
                sleeper = 5
                DrawText3Ds(v.x, v.y, v.z + 0.5, tostring("~b~[E]~w~ Produce "..v.type.."\n~g~[Q]~w~ Keep producing "..v.type))
                if isActive == false then
                    if IsControlJustPressed(1, 86) then
                        TriggerServerEvent("DRP_Drugs:ProdDrug", v.type, v.use, true, false) -- Produce one time
                    elseif IsControlJustPressed(1, 44) then
                        TriggerServerEvent("DRP_Drugs:ProdDrug", v.type, v.use, false, true) -- Jeep producing
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
        for k, v in pairs(sellLocations) do
            local ped = PlayerPedId()
            local pedPos = GetEntityCoords(ped)
            local distance = Vdist(pedPos.x, pedPos.y, pedPos.z, v.coords.x, v.coords.y, v.coords.z)
            if distance <= 2.0 then
                sleeper = 5
                DrawText3Ds(v.coords.x, v.coords.y, v.coords.z + 0.5, tostring("~b~[E]~w~ Sell "..v.type.."\n~g~[Q]~w~ Keep selling "..v.type))
                if IsControlJustPressed(1, 86) then
                    TriggerServerEvent("DRP_Drugs:SellDrug", v.type, v.price, true, false)
                elseif IsControlJustPressed(1, 44) then
                    TriggerServerEvent("DRP_Drugs:SellDrug", v.type, v.price, false, true)
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
----- Start production Event.
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
        TriggerServerEvent("DRP_Inventory:removeInventoryItem", use, amountToProd)
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
----- Start selling Event.
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
            TriggerServerEvent("DRP_Drugs:AddDirtyMoney", price)
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
            TriggerEvent("DRP_Core:Success", type, tostring("You got "..price.."$ for "..amountToGet.."g "..type),2500,false,"leftCenter")
            itemCounter = itemCounter + amountToGet
            cashRecived = cashRecived + price
            if isPressed then
                TriggerServerEvent("DRP_Drugs:AddDirtyMoney", cashRecived)
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

-----------------------------------------------------------------------------------------------------------------------------------
----- Sets blips on the map Function.
-----------------------------------------------------------------+-----------------------------------------------------------------
function showBlips(blips)
    for i = 1, #blips, 1 do
        local blip = AddBlipForCoord(blips[i].x, blips[i].y, blips[i].z)
        SetBlipSprite(blip, blips[i].blipId)
        SetBlipAsShortRange(blip, true)
        SetBlipScale(blip, 0.8)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(blips[i].name)
        EndTextCommandSetBlipName(blip)
    end
    Citizen.Wait(1)
end

----------------------------------------------------------------------------------------------------------------------------------
----- Peds for Drug sell locations Function. - Thanks to Darkzy for the fix!
----------------------------------------------------------------------------------------------------------------------------------
function spawnPeds(dealer)
    for a = 1, #dealer, 1 do
        local lmodel = GetHashKey(dealer[a].model)
        RequestModel(lmodel)
        while not HasModelLoaded(lmodel) do
            Wait(10)
        end
        local lPed = CreatePed(4, lmodel, dealer[a].coords.x, dealer[a].coords.y, dealer[a].coords.z - 0.95, dealer[a].coords.h, false, false)

        SetEntityInvincible(lPed, true)
        FreezeEntityPosition(lPed, true)
        SetBlockingOfNonTemporaryEvents(lPed, true)
        SetAmbientVoiceName(lPed, dealer[a].voice)
        TaskStartScenarioInPlace(lPed, "WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT", 0, 0)
        SetModelAsNoLongerNeeded(lmodel)
    end
end

----------------------------------------------------------------------------------------------------------------------------------
----- DrawText3Ds Function. - Thanks to Scrubz for the fix!
----------------------------------------------------------------------------------------------------------------------------------
function DrawText3Ds(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local factor = #text / 370
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end