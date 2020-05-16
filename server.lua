local amountToGet = DRPDrugs.AmountYouGet
local amountToProd = DRPDrugs.AmountToProduceOne
local timeToDoStuff = DRPDrugs.TimeToPickProduceSell
local backpackSpace = DRPDrugs.BackpackSpace
local backpackRecived = DRPDrugs.BackpackRecived
local canProduce = 0

----------------------------------------------------------------------------------------------------------------------------------
----- Pick and calculate backpackspace.
----------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("DRP_Drugs:PickDrug")
AddEventHandler("DRP_Drugs:PickDrug", function(type)
    local player = exports['drp_core']:GetPlayerData(source)
    if backpackSpace ~= 0 then
        TriggerClientEvent("DRP_Drugs:DrugLocationPick", player.id, true, amountToGet, type, backpackSpace, timeToDoStuff)
        backpackSpace = backpackSpace - amountToGet
        backpackRecived = backpackRecived + amountToGet
    else 
        TriggerClientEvent("DRP_Core:Error", player.id, type, tostring("Your backpack is full!"),2500,false,"leftCenter")
    end
end)

----------------------------------------------------------------------------------------------------------------------------------
----- Auto pick and calculate backpackspace.
----------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("DRP_Drugs:PickDrugAuto")
AddEventHandler("DRP_Drugs:PickDrugAuto", function(type)
    local player = exports['drp_core']:GetPlayerData(source)
    if backpackSpace ~= 0 then
        TriggerClientEvent("DRP_Drugs:DrugLocationPickAuto", player.id, true, amountToGet, type, backpackSpace, timeToDoStuff)
        backpackSpace = backpackSpace - backpackSpace
        backpackRecived = backpackRecived + amountToGet
    else 
        TriggerClientEvent("DRP_Core:Error", player.id, type, tostring("Your backpack is full!"),2500,false,"leftCenter")
    end
end)

----------------------------------------------------------------------------------------------------------------------------------
----- Produce and calculate backpackspace.
----------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("DRP_Drugs:ProdDrug")
AddEventHandler("DRP_Drugs:ProdDrug", function(type)
    local player = exports['drp_core']:GetPlayerData(source)
    canProduce = math.floor(backpackRecived / amountToProd)
    if backpackRecived >= amountToProd then
        TriggerClientEvent("DRP_Drugs:DrugLocationProd", player.id, true, amountToGet, type, canProduce, timeToDoStuff)
        backpackSpace = backpackSpace + amountToGet
        backpackRecived = backpackRecived - backpackRecived
    else
        TriggerClientEvent("DRP_Core:Error", player.id, type, tostring("You don't got enough to produce more!"),2500,false,"leftCenter")
    end
end)

----------------------------------------------------------------------------------------------------------------------------------
----- Auto pick and calculate backpackspace.
----------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("DRP_Drugs:ProdDrugAuto")
AddEventHandler("DRP_Drugs:ProdDrugAuto", function(type)
    local player = exports['drp_core']:GetPlayerData(source)
    canProduce = math.floor(backpackRecived / amountToProd)
    if backpackRecived >= canProduce then
        TriggerClientEvent("DRP_Drugs:DrugLocationProdAuto", player.id, true, amountToGet, type, canProduce, timeToDoStuff)
        backpackSpace = backpackSpace + canProduce
        backpackRecived = backpackRecived - backpackRecived
    else 
        TriggerClientEvent("DRP_Core:Error", player.id, type, tostring("You don't got enough to produce more!"),2500,false,"leftCenter")
    end
end)

----------------------------------------------------------------------------------------------------------------------------------
----- Information on how much you got when you stopped auto picking.
----------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("DRP_Drugs:AmountWhenQuitAutoPick")
AddEventHandler("DRP_Drugs:AmountWhenQuitAutoPick", function(drugsRecived, amountLeft, type)
    local player = exports['drp_core']:GetPlayerData(source)
    backpackSpace = backpackSpace + amountLeft
    TriggerClientEvent("DRP_Core:Info", player.id, type, tostring("You got "..drugsRecived.."g "..type),2500,false,"leftCenter")
end)

RegisterServerEvent("DRP_Drugs:AmountWhenQuitAutoProd")
AddEventHandler("DRP_Drugs:AmountWhenQuitAutoProd", function(drugsRecived, amountLeft, type)
    local player = exports['drp_core']:GetPlayerData(source)
    backpackSpace = backpackSpace - drugsRecived
    backpackRecived = backpackRecived + amountLeft
    print(backpackSpace)
    print(backpackRecived)
    TriggerClientEvent("DRP_Core:Info", player.id, type, tostring("You got "..drugsRecived.."g "..type),2500,false,"leftCenter")
end)