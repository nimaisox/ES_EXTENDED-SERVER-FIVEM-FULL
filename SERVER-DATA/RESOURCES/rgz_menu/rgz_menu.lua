local menuOn = false

local keybindControls = {
	["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local keybindControl = keybindControls["F1"]
        if IsControlPressed(0, keybindControl) then
            menuOn = true
            SendNUIMessage({
                type = 'init',
                resourceName = GetCurrentResourceName()
            })
            SetCursorLocation(0.5, 0.5)
            SetNuiFocus(true, true)
            PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
            while menuOn == true do Citizen.Wait(100) end
            Citizen.Wait(100)
            while IsControlPressed(0, keybindControl) do Citizen.Wait(100) end
        end
    end
end)

RegisterNUICallback('closemenu', function(data, cb)
    menuOn = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = 'destroy'
    })
    PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
    cb('ok')
end)


RegisterNUICallback('openmenu', function(data)
    menuOn = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = 'destroy'
    })
    PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
    if data.id == 'inventory' then
        TriggerEvent("esx_inventoryhud:openPlayerInventory")
    elseif data.id == 'billing' then
        TriggerEvent("nuo:openbilling")
    elseif data.id == 'dance' then
        TriggerEvent("dp:RecieveMenu")
        print('Dance!')
    elseif data.id == 'id' then
        TriggerEvent("idcard:openId")
    elseif data.id == 'work' then
        -- info notif 
        TriggerEvent("pNotify:SendNotification", {
            text = "Niestety, prace jeszcze niedostępne",
            type = "error",
            queue = "global",
            timeout = 3000,
            layout = "bottomRight"
          })
    elseif data.id == 'phone' then
        TriggerEvent("gcPhone:forceOpenPhone")
    end



    -- RegisterNetEvent("esx_billing:openBillings")
    -- AddEventHandler("esx_billing:openBillings", function()
    --         ShowBillsMenu()
    -- end)

    -- RegisterNetEvent(“gcphone:openphone”)
    -- AddEventHandler(“gcphone:openphone”, function()
    -- TooglePhone()
    -- end)

end)
-- Callback function for testing
RegisterNUICallback('testprint', function(data, cb)
    -- Print message
    TriggerEvent('chatMessage', "[test]", {255,0,0}, data.message)

    -- Send ACK to callback function
    cb('ok')
end)
