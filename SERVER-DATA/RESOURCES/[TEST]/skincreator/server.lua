local firstSpawn = nil
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('getSkin', function(source, cb)
	getSkin(source, function(skin)
		cb(skin)
	end)
end)

RegisterServerEvent("updateSkin")
AddEventHandler("updateSkin", function(skin)
	TriggerEvent('es:getPlayerFromId', source, function(user)
		local player = user.identifier

		exports.ghmattimysql:execute('UPDATE users SET `skin` = @skin, `gender` = @gender WHERE identifier = @identifier',
			{
				['@skin']       = json.encode(skin),
				['@gender']		= skin.sex,
				['@identifier'] = player
			})

		print("Outfits successfully updated !")
	end)
end)

function getSkin(source, cb)
	TriggerEvent('es:getPlayerFromId', source, function(user)
		exports.ghmattimysql:execute('SELECT skin FROM users WHERE identifier = @identifier', {
			['@identifier'] = user.identifier
		}, function(users)
			local user = users[1]
	
			if user.skin then
				cb(true)
			else
				cb(false)
			end
		end)
	end)
end

RegisterCommand('visible', function()
	TriggerClientEvent('visibility', -1)
  end, true)