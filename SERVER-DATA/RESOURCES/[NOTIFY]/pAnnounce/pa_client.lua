local p = {} -- NO TOUCHY TOUCHY
-----------[ CONFIG ]---------------------------------------------------

-- Delay in minutes between messages
p.delay = 1


p.prefix = '^1[Announce] '
p.suffix = '^1.'

p.messages = {   
    'Message ^1one',
    '^4Message two',
    '^7Message three',
    'Message ^6four',
    '^8Message five',
}

p.ignore = { 
    'ip:127.0.1.5',
    'steam:123456789123456',
    'license:1654687313215747944131321',
}
--------------------------------------------------------------------------


















-----[ CODE, DON'T TOUCH THIS ]-------------------------------------------
local playerIdentifiers
local enableMessages = true
local timeout = p.delay * 1000 * 60 -- from ms, to sec, to min
local playerOnIgnore = false
RegisterNetEvent('pa:setPlayerIdentifiers')
AddEventHandler('pa:setPlayerIdentifiers', function(identifiers)
    playerIdentifiers = identifiers
end)
Citizen.CreateThread(function()
    while playerIdentifiers == {} or playerIdentifiers == nil do
        Citizen.Wait(1000)
        TriggerServerEvent('pa:getPlayerIdentifiers')
    end
    for iid in pairs(p.ignore) do
        for pid in pairs(playerIdentifiers) do
            if p.ignore[iid] == playerIdentifiers[pid] then
                playerOnIgnore = true
                break
            end
        end
    end
    if not playerOnIgnore then
        while true do
            for i in pairs(p.messages) do
                if enableMessages then
                    chat(i)
                    print('[pAnnounce] Message #' .. i .. ' sent.')
                end
                Citizen.Wait(timeout)
            end
            
            Citizen.Wait(0)
        end
    else
        print('[pAnnounce] Player is on ignore list, no announcements will be received.')
    end
end)
function chat(i)
    TriggerEvent('chatMessage', '', {255,255,255}, p.prefix .. p.messages[i] .. p.suffix)
end
RegisterCommand('pannounce', function()
    enableMessages = not enableMessages
    if enableMessages then
        status = '^2enabled^5.'
    else
        status = '^1disabled^5.'
    end
    TriggerEvent('chatMessage', '', {255, 255, 255}, '^5[pAnnounce] automessages are now ' .. status)
end, false)
--------------------------------------------------------------------------
