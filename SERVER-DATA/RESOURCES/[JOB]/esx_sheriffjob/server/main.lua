ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
  TriggerEvent('esx_service:activateService', 'sheriff', Config.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'sheriff', _U('alert_sheriff'), true, true)
TriggerEvent('esx_society:registerSociety', 'Sheriff', 'sheriff', 'society_sheriff', 'society_sheriff', 'society_sheriff', {type = 'public'})

RegisterServerEvent('esx_sheriff:giveWeapon')
AddEventHandler('esx_sheriff:giveWeapon', function(weapon, ammo)
  local xPlayer = ESX.GetPlayerFromId(source)
  xPlayer.addWeapon(weapon, ammo)
end)

RegisterServerEvent('esx_sheriff:confiscatePlayerItem')
AddEventHandler('esx_sheriff:confiscatePlayerItem', function(target, itemType, itemName, amount)

  local sourceXPlayer = ESX.GetPlayerFromId(source)
  local targetXPlayer = ESX.GetPlayerFromId(target)

  if itemType == 'item_standard' then

    local label = sourceXPlayer.getInventoryItem(itemName).label
    local playerItemCount = targetXPlayer.getInventoryItem(itemName).count

    if playerItemCount <= amount then
      targetXPlayer.removeInventoryItem(itemName, amount)
      sourceXPlayer.addInventoryItem(itemName, amount)
    else
      TriggerClientEvent('esx:showNotification', _source, _U('invalid_quantity'))
    end

    TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_have_confinv') .. amount .. ' ' .. label .. _U('from') .. targetXPlayer.name)
    TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. targetXPlayer.name .. _U('confinv') .. amount .. ' ' .. label )

  end

  if itemType == 'item_account' then

    targetXPlayer.removeAccountMoney(itemName, amount)
    sourceXPlayer.addAccountMoney(itemName, amount)

    TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_have_confdm') .. amount .. _U('from') .. targetXPlayer.name)
    TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. targetXPlayer.name .. _U('confdm') .. amount)

  end

  if itemType == 'item_weapon' then

    targetXPlayer.removeWeapon(itemName)
    sourceXPlayer.addWeapon(itemName, amount)

    TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_have_confweapon') .. ESX.GetWeaponLabel(itemName) .. _U('from') .. targetXPlayer.name)
    TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. targetXPlayer.name .. _U('confweapon') .. ESX.GetWeaponLabel(itemName))

  end

end)

function deleteLicense(owner, license)
    MySQL.Sync.execute("DELETE FROM user_licenses WHERE `owner` = @owner AND `type` = @license", {
        ['@owner'] = owner,
        ['@license'] = license,
    })
    print('Permis suppr - '..owner)
    print('Permis suppr - '..license)

end



RegisterServerEvent('esx_sheriff:deletelicense')
AddEventHandler('esx_sheriff:deletelicense', function(target, license)
  local text = ""
  local sourceXPlayer = ESX.GetPlayerFromId(source)
  local targetXPlayer = ESX.GetPlayerFromId(target)

  if(license =="weapon")then
    text= "Vapenlicens"
  end
  if(license =="dmv")then
    text = "Teoriprov"
  end
  if(license =="drive")then
    text= "Bilkörkort"
  end
  if(license =="drive_bike")then
    text= "Motorcykelkörkort"
  end
  if(license =="drive_truck")then
    text="Lastbilskörkort"
  end

  TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Du har ~r~dragit in ~w~ : '..text..' ditt ~b~'..targetXPlayer.name )
  TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~r~' .. sourceXPlayer.name .. ' drog in ditt : '.. text)


  local identifier = GetPlayerIdentifiers(target)[1]



  deleteLicense(identifier,license)




end)

RegisterServerEvent('esx_sheriff:handcuff')
AddEventHandler('esx_sheriff:handcuff', function(target)
  TriggerClientEvent('esx_sheriff:handcuff', target)
end)

RegisterServerEvent('esx_sheriff:drag')
AddEventHandler('esx_sheriff:drag', function(target)
  local _source = source
  TriggerClientEvent('esx_sheriff:drag', target, _source)
end)

RegisterServerEvent('esx_sheriff:putInVehicle')
AddEventHandler('esx_sheriff:putInVehicle', function(target)
  TriggerClientEvent('esx_sheriff:putInVehicle', target)
end)

RegisterServerEvent('esx_sheriff:OutVehicle')
AddEventHandler('esx_sheriff:OutVehicle', function(target)
    TriggerClientEvent('esx_sheriff:OutVehicle', target)
end)

RegisterServerEvent('esx_sheriff:getStockItem')
AddEventHandler('esx_sheriff:getStockItem', function(itemName, count)

      local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_sheriff', function(inventory)
    local item = inventory.getItem(itemName)
    if item.count >= count and count > 0  then
        inventory.removeItem(itemName, count)
        xPlayer.addInventoryItem(itemName, count)
        TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn') .. count .. ' ' .. item.label)
    else
        TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
    end
  end)
end)

RegisterServerEvent('esx_sheriff:putStockItems')
AddEventHandler('esx_sheriff:putStockItems', function(itemName, count)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_sheriff', function(inventory)

    local item = inventory.getItem(itemName)
    local playerItemCount = xPlayer.getInventoryItem(itemName).count

    if item.count >= 0 and count <= playerItemCount then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_quantity'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_added') .. count .. ' ' .. item.label)

  end)

end)

ESX.RegisterServerCallback('esx_sheriff:getOtherPlayerData', function(source, cb, target)

  if Config.EnableESXIdentity then

    local xPlayer = ESX.GetPlayerFromId(target)

    local identifier = GetPlayerIdentifiers(target)[1]

    local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
      ['@identifier'] = identifier
    })

    local user      = result[1]
    local firstname     = user['firstname']
    local lastname      = user['lastname']
    local sex           = user['sex']
    local dob           = user['dateofbirth']
    local height        = user['height'] .. " Inches"

    local data = {
      name        = GetPlayerName(target),
      job         = xPlayer.job,
      inventory   = xPlayer.inventory,
      accounts    = xPlayer.accounts,
      weapons     = xPlayer.loadout,
      firstname   = firstname,
      lastname    = lastname,
      sex         = sex,
      dob         = dob,
      height      = height
    }

    TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)

      if status ~= nil then
        data.drunk = math.floor(status.percent)
      end

    end)

    if Config.EnableLicenses then

      TriggerEvent('esx_license:getLicenses', target, function(licenses)
        data.licenses = licenses
        cb(data)
      end)

    else
      cb(data)
    end

  else

    local xPlayer = ESX.GetPlayerFromId(target)

    local data = {
      name       = GetPlayerName(target),
      job        = xPlayer.job,
      inventory  = xPlayer.inventory,
      accounts   = xPlayer.accounts,
      weapons    = xPlayer.loadout
    }

    TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)

      if status ~= nil then
        data.drunk = status.getPercent()
      end

    end)

    TriggerEvent('esx_license:getLicenses', target, function(licenses)
      data.licenses = licenses
    end)

    cb(data)

  end

end)

ESX.RegisterServerCallback('esx_sheriff:getFineList', function(source, cb, category)

  MySQL.Async.fetchAll(
    'SELECT * FROM fine_types WHERE category = @category',
    {
      ['@category'] = category
    },
    function(fines)
      cb(fines)
    end
  )

end)

ESX.RegisterServerCallback('esx_sheriff:getVehicleInfos', function(source, cb, plate)

  if Config.EnableESXIdentity then

    MySQL.Async.fetchAll(
      'SELECT * FROM owned_vehicles',
      {},
      function(result)

        local foundIdentifier = nil

        for i=1, #result, 1 do

          local vehicleData = json.decode(result[i].vehicle)

          if vehicleData.plate == plate then
            foundIdentifier = result[i].owner
            break
          end

        end

        if foundIdentifier ~= nil then

          MySQL.Async.fetchAll(
            'SELECT * FROM users WHERE identifier = @identifier',
            {
              ['@identifier'] = foundIdentifier
            },
            function(result)

              local ownerName = result[1].firstname .. " " .. result[1].lastname

              local infos = {
                plate = plate,
                owner = ownerName
              }

              cb(infos)

            end
          )

        else

          local infos = {
          plate = plate
          }

          cb(infos)

        end

      end
    )

  else

    MySQL.Async.fetchAll(
      'SELECT * FROM owned_vehicles',
      {},
      function(result)

        local foundIdentifier = nil

        for i=1, #result, 1 do

          local vehicleData = json.decode(result[i].vehicle)

          if vehicleData.plate == plate then
            foundIdentifier = result[i].owner
            break
          end

        end

        if foundIdentifier ~= nil then

          MySQL.Async.fetchAll(
            'SELECT * FROM users WHERE identifier = @identifier',
            {
              ['@identifier'] = foundIdentifier
            },
            function(result)

              local infos = {
                plate = plate,
                owner = result[1].name
              }

              cb(infos)

            end
          )

        else

          local infos = {
          plate = plate
          }

          cb(infos)

        end

      end
    )

  end

end)

ESX.RegisterServerCallback('esx_sheriff:getArmoryWeapons', function(source, cb)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_sheriff', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    cb(weapons)

  end)

end)

ESX.RegisterServerCallback('esx_sheriff:addArmoryWeapon', function(source, cb, weaponName)

  local xPlayer = ESX.GetPlayerFromId(source)

  xPlayer.removeWeapon(weaponName)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_sheriff', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = weapons[i].count + 1
        foundWeapon = true
      end
    end

    if not foundWeapon then
      table.insert(weapons, {
        name  = weaponName,
        count = 1
      })
    end

     store.set('weapons', weapons)

     cb()

  end)

end)

ESX.RegisterServerCallback('esx_sheriff:removeArmoryWeapon', function(source, cb, weaponName)

  local xPlayer = ESX.GetPlayerFromId(source)

  xPlayer.addWeapon(weaponName, 1000)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_sheriff', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
        foundWeapon = true
      end
    end

    if not foundWeapon then
      table.insert(weapons, {
        name  = weaponName,
        count = 0
      })
    end

     store.set('weapons', weapons)

     cb()

  end)

end)


ESX.RegisterServerCallback('esx_sheriff:buy', function(source, cb, amount)

  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_sheriff', function(account)

    if account.money >= amount then
      account.removeMoney(amount)
      cb(true)
    else
      cb(false)
    end

  end)

end)

ESX.RegisterServerCallback('esx_sheriff:getStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_sheriff', function(inventory)
    cb(inventory.items)
  end)

end)

ESX.RegisterServerCallback('esx_sheriff:getPlayerInventory', function(source, cb)

  local xPlayer = ESX.GetPlayerFromId(source)
  local items   = xPlayer.inventory

  cb({
    items = items
  })

end)


function ShowPermis(source,identifier)
  local _source = source
  local licenses = MySQL.Sync.fetchAll("SELECT * FROM user_licenses where `owner`= @owner",{['@owner'] = identifier})

    for i=1, #licenses, 1 do

        if(licenses[i].type =="weapon")then
         TriggerClientEvent('esx:showNotification',_source,"Vapenlicens")
        end
        if(licenses[i].type =="dmv")then
            TriggerClientEvent('esx:showNotification',_source,"Godkänt teoriprov")
        end
        if(licenses[i].type =="drive")then
            TriggerClientEvent('esx:showNotification',_source,"Bilkörkort")
        end
        if(licenses[i].type =="drive_bike")then
           TriggerClientEvent('esx:showNotification',_source,"Motorcykelkörkort")
        end
        if(licenses[i].type =="drive_truck")then
          TriggerClientEvent('esx:showNotification',_source,"Lastbilskörkort")
        end


    end

end



RegisterServerEvent('esx_sheriff:license_see')
AddEventHandler('esx_sheriff:license_see', function(target)

  local sourceXPlayer = ESX.GetPlayerFromId(source)
  local targetXPlayer = ESX.GetPlayerFromId(target)

  local identifier = GetPlayerIdentifiers(target)[1]


  TriggerClientEvent('esx:showNotification', sourceXPlayer.source, '~b~'..targetXPlayer.name)
  ShowPermis(source,identifier)




end)


--police blip

local inServiceCops = {}



RegisterServerEvent('police:takeService')
AddEventHandler('police:takeService', function()
	if(not inServiceCops[source]) then
		inServiceCops[source] = GetPlayerName(source)

		for i, c in pairs(inServiceCops) do
			TriggerClientEvent("police:resultAllCopsInService", i, inServiceCops)
		end
	end
end)

RegisterServerEvent('police:breakService')
AddEventHandler('police:breakService', function()
	if(inServiceCops[source]) then
		inServiceCops[source] = nil

		for i, c in pairs(inServiceCops) do
			TriggerClientEvent("police:resultAllCopsInService", i, inServiceCops)
		end
	end
end)

AddEventHandler('playerDropped', function()
	if(inServiceCops[source]) then
		inServiceCops[source] = nil

		for i, c in pairs(inServiceCops) do
			TriggerClientEvent("police:resultAllCopsInService", i, inServiceCops)
		end
	end
end)