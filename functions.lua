-----------------------------------------------------------------------------------------------------------------------------------
----- Sets blips on the map Function.
-----------------------------------------------------------------------------------------------------------------------------------
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