local cokeAmount = DRPDrugs.CokeAmount

RegisterServerEvent("DRP_Drugs:PickProduceDrug")
AddEventHandler("DRP_Drugs:PickProduceDrug", function(amountToGet, type)
    local src = source
    local player = exports['drp_core']:GetPlayerData(src)
    --- Still need your inventory exports and events DarkyZZZZZZZZZZ! :p
    if cokeAmount ~= 0 then
        cokeAmount = cokeAmount - amountToGet
        TriggerClientEvent("DRP_Drugs:DrugLocationPick", player.id, true, amountToGet, type, cokeAmount, false)
    else 
        TriggerClientEvent("DRP_Drugs:DrugLocationPick", player.id, false)
    end
end)

RegisterServerEvent("DRP_Drugs:PickProduceDrugAuto")
AddEventHandler("DRP_Drugs:PickProduceDrugAuto", function(amountToGet, type)
    local src = source
    local player = exports['drp_core']:GetPlayerData(src)
    --- Still need your inventory exports and events DarkyZZZZZZZZZZ! :p
    if cokeAmount ~= 0 then
        cokeAmount = cokeAmount - amountToGet
        TriggerClientEvent("DRP_Drugs:DrugLocationPick", player.id, true, amountToGet, type, cokeAmount, true)
    else 
        TriggerClientEvent("DRP_Drugs:DrugLocationPick", player.id, false)
    end
end)