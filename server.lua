local amountToGet = DRPDrugs.AmountYouGet
local cokeAmount = DRPDrugs.CokeAmount

RegisterServerEvent("DRP_Drugs:PickProduceDrug")
AddEventHandler("DRP_Drugs:PickProduceDrug", function(type)
    local player = exports['drp_core']:GetPlayerData(source)
    if cokeAmount ~= 0 then
        TriggerClientEvent("DRP_Drugs:DrugLocationPick", player.id, true, amountToGet, type, cokeAmount, false)
        cokeAmount = cokeAmount - amountToGet
    else 
        TriggerClientEvent("DRP_Drugs:DrugLocationPick", player.id, false)
    end
end)

RegisterServerEvent("DRP_Drugs:PickProduceDrugAuto")
AddEventHandler("DRP_Drugs:PickProduceDrugAuto", function(type)
    local player = exports['drp_core']:GetPlayerData(source)
    if cokeAmount ~= 0 then
        TriggerClientEvent("DRP_Drugs:DrugLocationPickAuto", player.id, true, amountToGet, type, cokeAmount, true)
        cokeAmount = cokeAmount - cokeAmount
    else 
        TriggerClientEvent("DRP_Drugs:DrugLocationPickAuto", player.id, false)
    end
end)

RegisterServerEvent("DRP_Drugs:AmountWhenQuitAnim")
AddEventHandler("DRP_Drugs:AmountWhenQuitAnim", function(drugsRecived, amountLeft, type)
    local player = exports['drp_core']:GetPlayerData(source)
    cokeAmount = cokeAmount + amountLeft
    TriggerClientEvent("DRP_Core:Info", player.id, type, tostring("You got "..drugsRecived.."g "..type),2500,false,"leftCenter")
end)