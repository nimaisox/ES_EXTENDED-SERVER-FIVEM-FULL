local MF = nil
Citizen.CreateThread(function()
    while MF == nil do
        TriggerEvent("esx:getSharedObject", function(MahdiFahimi) MF = MahdiFahimi end)
        Wait(0)
    end
end)
local enabled = true
local report
CloseMenu = function() return true end
KeyboardInput = function(TextEntry, ExampleText, MaxStringLength)
    AddTextEntry("FMMC_KEY_TIP1", TextEntry .. ":")
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        blockinput = false
        return result
    else
        Citizen.Wait(500)
        blockinput = false
        return nil
    end
end

Citizen.CreateThread(function(source)
    JayMenu.CreateMenu("CommonMenu", "~y~~h~BloodMoon Report Menu", function() return CloseMenu() end)
    JayMenu.SetSubTitle("CommonMenu", "~r~~h~Select")
	for k, v in ipairs(Config_RPS.ReportCats) do
        JayMenu.CreateSubMenu(v[1], "CommonMenu", v[2])
		JayMenu.SetSubTitle(v[1], v[2])
    end
    while true do
        Citizen.Wait(0)
        if JayMenu.IsMenuOpened("CommonMenu") then  
            for k, v in ipairs(Config_RPS.ReportCats) do
                JayMenu.MenuButton("~r~~h~"..v[2], v[1])
            end
             --if JayMenu.Button("~b~~h~Discord : discord.gg/tShuCeU") then end
            --if JayMenu.Button("~b~~h~Server Developer By : AminMRX & endboy") then end
            JayMenu.Display()
        end
        for k, v in ipairs(Config_RPS.ReportCats) do
            if JayMenu.IsMenuOpened(v[1]) then
                if v[1] == "REPORT_MORE" then
                    if JayMenu.Button("~g~~h~Report type", "~r~~h~"..v[2]) then end
                    if JayMenu.Button("~b~~h~Type your report") then
                        report = KeyboardInput("Enter Report", "", 1000)
                    end
                    if JayMenu.Button("~r~~h~Send Report") then
                        if report ~= nil then
                            TriggerServerEvent("MF_ReportMenu:SendAdmins", GetPlayerServerId(PlayerId()), report)
                            TriggerEvent('chat:addMessage', {
                                template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 0, 0, 0.4); border-radius: 3px; border: 1px solid yellow;"><i class="far fa-water"></i> BloodMoon Report System:<br>  {0}</div>',
                                args = { "^2Report Shoma Baraye BloodMoon Staff Team Ersal Shod! "}
                            })
                            report = nil
                            JayMenu.CloseMenu()
                        else
                            MF.ShowNotification("~r~Report Khali Ast")
                        end
                    end
                     --if JayMenu.Button("~b~~h~Discord : discord.gg/tShuCeU") then end
                    --if JayMenu.Button("~b~~h~Server Developer By : AminMRX & endboy") then end        
                    JayMenu.Display()
                else
                    if JayMenu.Button("~g~~h~Report type","~r~~h~"..v[2].."") then end
                    if JayMenu.Button("~r~~h~Send Report") then
                        TriggerServerEvent("MF_ReportMenu:SendAdmins", GetPlayerServerId(PlayerId()), v[2])
                        TriggerEvent('chat:addMessage', {
                            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 0, 0, 0.4); border-radius: 3px; border: 1px solid yellow;"><i class="far fa-newspaper"></i> BloodMoon Report System:<br>  {0}</div>',
                            args = { "^2Report Shoma Baraye BloodMoon Staff Team Ersal Shod!"}
                        })
                        JayMenu.CloseMenu()
                    end
                     --if JayMenu.Button("~b~~h~Discord : discord.gg/tShuCeU") then end
                    --if JayMenu.Button("~b~~h~Server Developer By : AminMRX & endboy") then end        
                    JayMenu.Display()
                end
            end
        end
    end
end)

local can = true

RegisterCommand("report",function(source, args)
    if can then
        JayMenu.OpenMenu("CommonMenu")
        can = false
    else
        MF.ShowNotification("Baraye Har Report Dar BloodMoon Rp Bayad 2 Daghighe Sabr Konid")
    end
end, false)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if not can then
            Wait(Config_RPS.AntiSpamTime)
            can = true
        end
    end
end)