Citizen.CreateThread(function()
	while true do
        -- This is the Application ID (Replace this with you own)
		SetDiscordAppId(824621959174160404)

        -- Here you will have to put the image name for the "large" icon.
		SetDiscordRichPresenceAsset('es_extended')

        -- Here you can add hover text for the "large" icon.
        SetDiscordRichPresenceAssetText('ES_EXTENDED')
       
        -- Here you will have to put the image name for the "small" icon.
        SetDiscordRichPresenceAssetSmall('es_extended')

        -- Here you can add hover text for the "small" icon.
        SetDiscordRichPresenceAssetSmallText('ES_EXTENDED')

        -- Amount of online player (Don't touch)
        local playerCount = #GetActivePlayers()
        --TriggerServerEvent('GetActivePlayers')

        --Player Id Show
        --local playerId = GetPlayerServerId(PlayerId())

        -- Your own playername (Don't touch)
        local playerName = GetPlayerName(PlayerId())

        -- Set here the amount of slots you have (Edit if needed)
        local maxPlayerSlots = 48

        -- Sets the string with variables as RichPresence (Don't touch)
        SetRichPresence(string.format("%s | %s/%s", playerName, playerCount, maxPlayerSlots))
        --SetRichPresence(string.format("%s | ID: %s | %s/%s", playerName, playerId, playerCount, maxPlayerSlots))

        SetDiscordRichPresenceAction(0, "Join", ".")
        SetDiscordRichPresenceAction(1, "Discord", ".")

        --It updates every one minute just in case.
		Citizen.Wait(60000)
	end
end)