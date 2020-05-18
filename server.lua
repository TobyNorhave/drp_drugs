local amountToGet = DRPDrugs.AmountYouGet
local amountToProd = DRPDrugs.AmountToProduceOne
local timeToDoStuff = DRPDrugs.TimeToPickProduceSell
----------------------------------------------------------------------------------------------------------------------------------
----- Send Blips and locations to player.
----------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("DRP_Drugs:InitAll")
AddEventHandler("DRP_Drugs:InitAll", function()
    local drug = DRPDrugs.Locations
    local prod = DRPDrugs.Productions
    local sell = DRPDrugs.SellLocations
    TriggerClientEvent("DRP_Drugs:Init", source, drug, prod, sell)
end)

----------------------------------------------------------------------------------------------------------------------------------
----- Pick and calculate backpackspace.
----------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("DRP_Drugs:PickDrug")
AddEventHandler("DRP_Drugs:PickDrug", function(type, pick, auto)
    local src = source
    local player = exports["drp_id"]:GetCharacterData(src)
    if pick then
        TriggerClientEvent("DRP_Drugs:DrugLocationPick", player.charid, true, false, amountToGet, type, timeToDoStuff)
    elseif auto then
        TriggerClientEvent("DRP_Drugs:DrugLocationPick", player.charid, true, true, amountToGet, type, timeToDoStuff)
    end
end)

----------------------------------------------------------------------------------------------------------------------------------
----- Produce and calculate backpackspace.
----------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("DRP_Drugs:ProdDrug")
AddEventHandler("DRP_Drugs:ProdDrug", function(type, use, prod, auto)
    local src = source
    local player = exports["drp_id"]:GetCharacterData(src)
    if prod then
        TriggerClientEvent("DRP_Drugs:DrugLocationProd", player.charid, true, false, amountToGet, amountToProd, type, use, timeToDoStuff)
    elseif auto then
        TriggerClientEvent("DRP_Drugs:DrugLocationProd", player.charid, true, true, amountToGet, amountToProd, type, use, timeToDoStuff)
    end
end)

RegisterServerEvent("DRP_Drugs:SellDrug")
AddEventHandler("DRP_Drugs:SellDrug", function(type, price, prod, auto)
    local src = source
    local player = exports["drp_id"]:GetCharacterData(src)
    if prod then
        TriggerClientEvent("DRP_Drugs:SellLocationDrug", player.charid, true, false, amountToGet, price, type, timeToDoStuff)
    elseif auto then
        TriggerClientEvent("DRP_Drugs:SellLocationDrug", player.charid, true, true, amountToGet, price, type, timeToDoStuff)
    end
end)