local MF = nil
TriggerEvent("esx:getSharedObject", function(MahdiFahimi) MF = MahdiFahimi end)
RegisterServerEvent("MF_ReportMenu:SendAdmins")
AddEventHandler("MF_ReportMenu:SendAdmins", function(source, msg)
    Sendlog(source, msg)
    TriggerEvent("es:getPlayers", function(pl)
		for k,v in pairs(pl) do
			TriggerEvent("es:getPlayerFromId", k, function(user)
				if(user.permission_level > 2 )then
                    TriggerClientEvent('chat:addMessage', k, {
                        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 0, 0, 0.4); border-radius: 3px;border: 1px solid yellow;"><i class="far fa-newspaper"></i> BloodMoon Staff Team | Report Jadid :<br>  {0}</div>',
                        args = { "(^2" .. GetPlayerName(source) .." | "..source.."^0) " .. msg }
                    })
				end
			end)
		end
    end)
end)

Sendlog = function(source, msg)
    local identifier
	local discord   = "https://discord.com/api/webhooks/923890305269379083/CwlnI5DnbcyWbo9uaJiAyDZJ64LTm2Qvqj3P-Y0MZbho_PN9rF4Fy3us-euUnKJUAnUa"
	local playerip
    for k,v in ipairs(GetPlayerIdentifiers(source))do
		if string.sub(v, 1, string.len("steam:")) == "steam:" then
			identifier = v
		elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
			discord = v
		elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
			playerip = v
		end
    end
    discord = discord:gsub('discord:','')
    identifier = identifier:gsub('steam:','')
    local date = os.date('*t')
	if date.month < 10 then date.month = '0' .. tostring(date.month) end
	if date.day < 10 then date.day = '0' .. tostring(date.day) end
	if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
	if date.min < 10 then date.min = '0' .. tostring(date.min) end
    if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
    local xPlayer = MF.GetPlayerFromId(source)
    TriggerEvent('DiscordBot:ToDiscord', 'report', GetPlayerName(source), "```css\n[ Name : " .. GetPlayerName(source) .. "| ID : " .. source .."]\n[ Identifier : " .. identifier .. "]\n[ Report : " .. msg .. "]\n[ Time : `"  .. date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec .. '` ]\n``` <@!'..discord..'>',  'user', source, true, false)
end

RegisterCommand('ac', function(source, args)

    local xPlayer = MF.GetPlayerFromId(source)

    if xPlayer.permission_level > 2 then
        if args[1] then
            if xPlayer.aduty then
                        local name = GetPlayerName(source)
                            local xPlayers = MF.GetPlayers()
                            for i=1, #xPlayers, 1 do

                                local xP = MF.GetPlayerFromId(xPlayers[i])

                                if xP.permission_level > 0 and xP.aduty then
                                    if(tonumber(args[1]) and GetPlayerName(tonumber(args[1])))then
                                        TriggerClientEvent('chat:addMessage', xPlayers[i], { args = { "^4[^1AcceptReport^4] ^3" .. name .. "^0 Report Shomare " .. "^0^*" .. tonumber(args[1]) .. "^4 Ra Resedegi Kard..."}})
                                    else
                                        TriggerClientEvent('chat:addMessage', xPlayers[i], { args = {"^4[^1AcceptReport^4] ^3" .. "Shomare " .. tonumber(args[1]) .. " Eshtebash Ast"}}) 
                                    end

                                end

                            end
                    else
                        TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid id ra khali begozarid!")
                    end
                end
    else
        TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma admin nistid!")
    end
end)