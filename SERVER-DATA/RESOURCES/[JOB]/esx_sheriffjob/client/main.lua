local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local PlayerData                = {}
local GUI                       = {}
local HasAlreadyEnteredMarker   = false
local LastStation               = nil
local LastPart                  = nil
local LastPartNum               = nil
local LastEntity                = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local IsHandcuffed              = false
local IsDragged                 = false
local CopPed                    = 0
local isOnDuty					= false

ESX                             = nil
GUI.Time                        = 0

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

function SetVehicleMaxMods(vehicle)

  local props = {
    modEngine       = 4,
    modBrakes       = 2,
    modTransmission = 2,
    modSuspension   = 2,
    modTurbo        = true,
  }

  ESX.Game.SetVehicleProperties(vehicle, props)

end

function getJob()
  if PlayerData.job ~= nil then
	return PlayerData.job.name	
  end  
end

function OpenCloakroomMenu()

  local elements = {
    { label = _U('citizen_wear'), value = 'citizen_wear' }
  }

  if PlayerData.job.grade_name == 'recruit' then
    table.insert(elements, {label = _U('police_wear'), value = 'cadet_wear'})
  end

  if PlayerData.job.grade_name == 'officer' then
    table.insert(elements, {label = _U('police_wear'), value = 'police_wear'})
  end

  if PlayerData.job.grade_name == 'sergeant' then
    table.insert(elements, {label = _U('police_wear'), value = 'sergeant_wear'})
  end

  if PlayerData.job.grade_name == 'lieutenant' then
    table.insert(elements, {label = _U('police_wear'), value = 'lieutenant_wear'})
  end

  if PlayerData.job.grade_name == 'boss' then
    table.insert(elements, {label = _U('police_wear'), value = 'commandant_wear'})
  end

  if Config.EnableNonFreemodePeds then
    table.insert(elements, {label = _U('sheriff_wear'), value = 'sheriff_wear_freemode'})
    table.insert(elements, {label = _U('lieutenant_wear'), value = 'lieutenant_wear_freemode'})
    table.insert(elements, {label = _U('commandant_wear'), value = 'commandant_wear_freemode'})
  end

  table.insert(elements, {label = _U('bullet_wear'), value = 'bullet_wear'})
  table.insert(elements, {label = _U('gilet_wear'), value = 'gilet_wear'})

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'cloakroom',
    {
      title    = _U('cloakroom'),
      align    = 'top-left',
      elements = elements,
    },
    function(data, menu)
      menu.close()

      if data.current.value == 'citizen_wear' then
	    ServiceOff()
		isOnDuty = false
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
          local model = nil

          if skin.sex == 0 then
            model = GetHashKey("mp_m_freemode_01")
          else
            model = GetHashKey("mp_f_freemode_01")
          end

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(1)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)

          TriggerEvent('skinchanger:loadSkin', skin)
          TriggerEvent('esx:restoreLoadout')
          local playerPed = GetPlayerPed(-1)
          SetPedArmour(playerPed, 0)
          ClearPedBloodDamage(playerPed)
          ResetPedVisibleDamage(playerPed)
          ClearPedLastWeaponDamage(playerPed)
        end)
      end

      if data.current.value == 'cadet_wear' then
		ServiceOn()
		isOnDuty = true
        TriggerEvent('skinchanger:getSkin', function(skin)
        
        if skin.sex == 0 then

          local model = GetHashKey("s_m_y_hwaycop_01")

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
      else
          local model = GetHashKey("s_f_y_sheriff_01")

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
          end

        end)
      end

      if data.current.value == 'police_wear' then
		ServiceOn()
		isOnDuty = true
        TriggerEvent('skinchanger:getSkin', function(skin)
        
            if skin.sex == 0 then

                local clothesSkin = {
                    ['tshirt_1'] = 58, ['tshirt_2'] = 0,
                    ['torso_1'] = 55, ['torso_2'] = 0,
                    ['decals_1'] = 0, ['decals_2'] = 0,
                    ['arms'] = 41,
                    ['pants_1'] = 25, ['pants_2'] = 0,
                    ['shoes_1'] = 25, ['shoes_2'] = 0,
                    ['helmet_1'] = -1, ['helmet_2'] = 0,
                    ['chain_1'] = 0, ['chain_2'] = 0,
                    ['ears_1'] = 2, ['ears_2'] = 0
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

            else

                local clothesSkin = {
                    ['tshirt_1'] = 35, ['tshirt_2'] = 0,
                    ['torso_1'] = 48, ['torso_2'] = 0,
                    ['decals_1'] = 0, ['decals_2'] = 0,
                    ['arms'] = 44,
                    ['pants_1'] = 34, ['pants_2'] = 0,
                    ['shoes_1'] = 27, ['shoes_2'] = 0,
                    ['helmet_1'] = -1, ['helmet_2'] = 0,
                    ['chain_1'] = 0, ['chain_2'] = 0,
                    ['ears_1'] = 2, ['ears_2'] = 0
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

            end

            local playerPed = GetPlayerPed(-1)
            SetPedArmour(playerPed, 0)
            ClearPedBloodDamage(playerPed)
            ResetPedVisibleDamage(playerPed)
            ClearPedLastWeaponDamage(playerPed)
            
        end)
      end

      if data.current.value == 'sergeant_wear' then
		ServiceOn()
		isOnDuty = true
        TriggerEvent('skinchanger:getSkin', function(skin)
        
        if skin.sex == 0 then

          local model = GetHashKey("s_m_y_hwaycop_01")

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
      else
          local model = GetHashKey("s_f_y_sheriff_01")

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
          end

        end)
      end

      if data.current.value == 'lieutenant_wear' then
		ServiceOn()
		isOnDuty = true
        TriggerEvent('skinchanger:getSkin', function(skin)
        
        if skin.sex == 0 then

          local model = GetHashKey("s_m_y_swat_01")

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
      else
          local model = GetHashKey("s_f_y_sheriff_01")

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
          end

        end)
      end

      if data.current.value == 'commandant_wear' then
		ServiceOn()
		isOnDuty = true
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

        if skin.sex == 0 then

          local model = GetHashKey("s_m_y_ranger_01")

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
      else
          local model = GetHashKey("s_f_y_sheriff_01")

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
          end

        end)
      end

      if data.current.value == 'bullet_wear' then
        TriggerEvent('skinchanger:getSkin', function(skin)
        
            if skin.sex == 0 then

                local clothesSkin = {
                    ['bproof_1'] = 11, ['bproof_2'] = 1
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

            else

                local clothesSkin = {
                    ['bproof_1'] = 13, ['bproof_2'] = 1
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

            end

            local playerPed = GetPlayerPed(-1)
            SetPedArmour(playerPed, 100)
            ClearPedBloodDamage(playerPed)
            ResetPedVisibleDamage(playerPed)
            ClearPedLastWeaponDamage(playerPed)
            
        end)
      end

      if data.current.value == 'gilet_wear' then
        TriggerEvent('skinchanger:getSkin', function(skin)
        
            if skin.sex == 0 then

                local clothesSkin = {
                    ['tshirt_1'] = 59, ['tshirt_2'] = 1
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

            else

                local clothesSkin = {
                    ['tshirt_1'] = 36, ['tshirt_2'] = 1
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

            end

            local playerPed = GetPlayerPed(-1)
            SetPedArmour(playerPed, 0)
            ClearPedBloodDamage(playerPed)
            ResetPedVisibleDamage(playerPed)
            ClearPedLastWeaponDamage(playerPed)
            
        end)
      end

      if data.current.value == 'sheriff_wear_freemode' then
		ServiceOn()
		isOnDuty = true
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

        if skin.sex == 0 then

          local model = GetHashKey("s_m_y_sheriff_01")

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
      else
          local model = GetHashKey("s_f_y_sheriff_01")

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
          end

        end)
      end

      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = _U('open_cloackroom')
      CurrentActionData = {}

    end,
    function(data, menu)

      menu.close()

      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = _U('open_cloackroom')
      CurrentActionData = {}
    end
  )

end

function OpenArmoryMenu(station)

  if Config.EnableArmoryManagement then

    local elements = {
      {label = _U('get_weapon'), value = 'get_weapon'},
      {label = _U('put_weapon'), value = 'put_weapon'},
      {label = 'Ta ut saker',  value = 'get_stock'},
      {label = 'Sätt in saker',  value = 'put_stock'}
    }

    if PlayerData.job.grade_name == 'boss' then
      table.insert(elements, {label = _U('buy_weapons'), value = 'buy_weapons'})
    end

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory',
      {
        title    = _U('armory'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        if data.current.value == 'get_weapon' then
          OpenGetWeaponMenu()
        end

        if data.current.value == 'put_weapon' then
          OpenPutWeaponMenu()
        end

        if data.current.value == 'buy_weapons' then
          OpenBuyWeaponsMenu(station)
        end

        if data.current.value == 'put_stock' then
              OpenPutStocksMenu()
            end

            if data.current.value == 'get_stock' then
              OpenGetStocksMenu()
            end

      end,
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_armory'
        CurrentActionMsg  = _U('open_armory')
        CurrentActionData = {station = station}
      end
    )

  else

    local elements = {}

    for i=1, #Config.PoliceStations[station].AuthorizedWeapons, 1 do
      local weapon = Config.PoliceStations[station].AuthorizedWeapons[i]
      table.insert(elements, {label = ESX.GetWeaponLabel(weapon.name), value = weapon.name})
    end

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory',
      {
        title    = _U('armory'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)
        local weapon = data.current.value
        TriggerServerEvent('esx_sheriff:giveWeapon', weapon,  1000)
      end,
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_armory'
        CurrentActionMsg  = _U('open_armory')
        CurrentActionData = {station = station}

      end
    )

  end

end

function OpenVehicleSpawnerMenu(station, partNum)

  local vehicles = Config.PoliceStations[station].Vehicles

  ESX.UI.Menu.CloseAll()

  if Config.EnableSocietyOwnedVehicles then

    local elements = {}

    ESX.TriggerServerCallback('esx_society:getVehiclesInGarage', function(garageVehicles)

      for i=1, #garageVehicles, 1 do
        table.insert(elements, {label = GetDisplayNameFromVehicleModel(garageVehicles[i].model) .. ' [' .. garageVehicles[i].plate .. ']', value = garageVehicles[i]})
      end

      ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'vehicle_spawner',
        {
          title    = _U('vehicle_menu'),
          align    = 'top-left',
          elements = elements,
        },
        function(data, menu)

          menu.close()

          local vehicleProps = data.current.value

          ESX.Game.SpawnVehicle(vehicleProps.model, vehicles[partNum].SpawnPoint, 270.0, function(vehicle)
            ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
            local playerPed = GetPlayerPed(-1)
            TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
          end)

          TriggerServerEvent('esx_society:removeVehicleFromGarage', 'police', vehicleProps)

        end,
        function(data, menu)

          menu.close()

          CurrentAction     = 'menu_vehicle_spawner'
          CurrentActionMsg  = _U('vehicle_spawner')
          CurrentActionData = {station = station, partNum = partNum}

        end
      )

    end, 'police')

  else

    local elements = {}

    table.insert(elements, { label = 'Sheriff 1', value = 'sheriff' })
	table.insert(elements, { label = 'Sheriff 2', value = 'sheriff2' })
    table.insert(elements, { label = 'Sheriff 3', value = 'sheriff3' })

    if PlayerData.job.grade_name == 'officer' then
      table.insert(elements, { label = 'Sheriff 3', value = 'sheriff3'})
    end

    if PlayerData.job.grade_name == 'sergeant' then
      table.insert(elements, { label = 'Sheriff 1', value = 'sheriff'})
      table.insert(elements, { label = 'Sheriff 2', value = 'sheriff2'})
      table.insert(elements, { label = 'Sheriff 3', value = 'sheriff3'})
    end

    if PlayerData.job.grade_name == 'lieutenant' then
      table.insert(elements, { label = 'Sheriff 1', value = 'sheriff'})
      table.insert(elements, { label = 'Sheriff 2', value = 'sheriff2'})
      table.insert(elements, { label = 'Sheriff 3', value = 'sheriff3'})
    end

    if PlayerData.job.grade_name == 'boss' then
      table.insert(elements, { label = 'Sheriff 1', value = 'sheriff'})
      table.insert(elements, { label = 'Sheriff 2', value = 'sheriff2'})
      table.insert(elements, { label = 'Sheriff 3', value = 'sheriff3'})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vehicle_spawner',
      {
        title    = _U('vehicle_menu'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        menu.close()

        local model = data.current.value

        local vehicle = GetClosestVehicle(vehicles[partNum].SpawnPoint.x,  vehicles[partNum].SpawnPoint.y,  vehicles[partNum].SpawnPoint.z,  3.0,  0,  71)

        if not DoesEntityExist(vehicle) then

          local playerPed = GetPlayerPed(-1)

          if Config.MaxInService == -1 then

            ESX.Game.SpawnVehicle(model, {
              x = vehicles[partNum].SpawnPoint.x,
              y = vehicles[partNum].SpawnPoint.y,
              z = vehicles[partNum].SpawnPoint.z
            }, vehicles[partNum].Heading, function(vehicle)
              TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
              SetVehicleMaxMods(vehicle)
            end)

          else

            ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)

              if canTakeService then

                ESX.Game.SpawnVehicle(model, {
                  x = vehicles[partNum].SpawnPoint.x,
                  y = vehicles[partNum].SpawnPoint.y,
                  z = vehicles[partNum].SpawnPoint.z
                }, vehicles[partNum].Heading, function(vehicle)
                  TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
                  SetVehicleMaxMods(vehicle)
                end)

              else
                ESX.ShowNotification(_U('service_max') .. inServiceCount .. '/' .. maxInService)
              end

            end, 'police')

          end

        else
          ESX.ShowNotification(_U('vehicle_out'))
        end

      end,
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_vehicle_spawner'
        CurrentActionMsg  = _U('vehicle_spawner')
        CurrentActionData = {station = station, partNum = partNum}

      end
    )

  end

end

function OpenPoliceActionsMenu()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'police_actions',
    {
      title    = 'Police',
      align    = 'top-left',
      elements = {
        {label = _U('citizen_interaction'), value = 'citizen_interaction'},
        {label = _U('vehicle_interaction'), value = 'vehicle_interaction'},
        {label = _U('object_spawner'),      value = 'object_spawner'},
      },
    },
    function(data, menu)

      if data.current.value == 'citizen_interaction' then

        ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'citizen_interaction',
          {
            title    = _U('citizen_interaction'),
            align    = 'top-left',
            elements = {
              {label = _U('id_card'),       value = 'identity_card'},
              {label = _U('search'),        value = 'body_search'},
              {label = _U('handcuff'),    value = 'handcuff'},
              {label = _U('drag'),      value = 'drag'},
              {label = _U('put_in_vehicle'),  value = 'put_in_vehicle'},
              {label = _U('out_the_vehicle'), value = 'out_the_vehicle'},
			  {label = _U('jail'),			value = 'jail'},
            },
          },
          function(data2, menu2)

            local player, distance = ESX.Game.GetClosestPlayer()

            if distance ~= -1 and distance <= 3.0 then

              if data2.current.value == 'identity_card' then
                OpenIdentityCardMenu(player)
              end

              if data2.current.value == 'body_search' then
                OpenBodySearchMenu(player)
              end

              if data2.current.value == 'handcuff' then
                TriggerServerEvent('esx_sheriff:handcuff', GetPlayerServerId(player))
              end

              if data2.current.value == 'drag' then
                TriggerServerEvent('esx_sheriff:drag', GetPlayerServerId(player))
              end

              if data2.current.value == 'put_in_vehicle' then
                TriggerServerEvent('esx_sheriff:putInVehicle', GetPlayerServerId(player))
              end

              if data2.current.value == 'out_the_vehicle' then
                  TriggerServerEvent('esx_sheriff:OutVehicle', GetPlayerServerId(player))
              end

              if data2.current.value == 'fine' then
                OpenFineMenu(player)
              end
			  
			  if data2.current.value == 'license_weapon_remove' then
                  TriggerServerEvent('esx_sheriff:deletelicense', GetPlayerServerId(player), 'weapon')

              end

              if data2.current.value == 'license_moto_remove' then
                  TriggerServerEvent('esx_sheriff:deletelicense', GetPlayerServerId(player), 'drive_bike')

              end
			  
              if data2.current.value == 'license_camion_remove' then
                  TriggerServerEvent('esx_sheriff:deletelicense', GetPlayerServerId(player), 'drive_truck')

              end
			  
              if data2.current.value == 'license_voiture_remove' then
                  TriggerServerEvent('esx_sheriff:deletelicense', GetPlayerServerId(player), 'drive')

              end
              if data2.current.value == 'license_code_remove' then
                  TriggerServerEvent('esx_sheriff:deletelicense', GetPlayerServerId(player), 'dmv')

              end
			  
			  if data2.current.value == 'jail' then
				JailPlayer(GetPlayerServerId(player))
			  end

            else
              ESX.ShowNotification(_U('no_players_nearby'))
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end

      if data.current.value == 'vehicle_interaction' then

        ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'vehicle_interaction',
          {
            title    = _U('vehicle_interaction'),
            align    = 'top-left',
            elements = {
              {label = _U('vehicle_info'), value = 'vehicle_infos'},
              {label = _U('pick_lock'),    value = 'hijack_vehicle'},
            },
          },
          function(data2, menu2)

            local playerPed = GetPlayerPed(-1)
            local coords    = GetEntityCoords(playerPed)
            local vehicle   = GetClosestVehicle(coords.x,  coords.y,  coords.z,  3.0,  0,  71)

            if DoesEntityExist(vehicle) then

              local vehicleData = ESX.Game.GetVehicleProperties(vehicle)

              if data2.current.value == 'vehicle_infos' then
                OpenVehicleInfosMenu(vehicleData)
              end

              if data2.current.value == 'hijack_vehicle' then

                local playerPed = GetPlayerPed(-1)
                local coords    = GetEntityCoords(playerPed)

                if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then

                  local vehicle = GetClosestVehicle(coords.x,  coords.y,  coords.z,  3.0,  0,  71)

                  if DoesEntityExist(vehicle) then

                    Citizen.CreateThread(function()

                      TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)

                      Wait(20000)

                      ClearPedTasksImmediately(playerPed)

                      SetVehicleDoorsLocked(vehicle, 1)
                      SetVehicleDoorsLockedForAllPlayers(vehicle, false)

                      TriggerEvent('esx:showNotification', _U('vehicle_unlocked'))

                    end)

                  end

                end

              end

            else
              ESX.ShowNotification(_U('no_vehicles_nearby'))
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end

      if data.current.value == 'object_spawner' then

        ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'citizen_interaction',
          {
            title    = _U('traffic_interaction'),
            align    = 'top-left',
            elements = {
              {label = _U('cone'),     value = 'prop_roadcone02a'},
              {label = _U('barrier'), value = 'prop_barrier_work06a'},
              {label = _U('spikestrips'),    value = 'p_ld_stinger_s'},
              {label = _U('box'),   value = 'prop_boxpile_07d'},
              {label = _U('cash'),   value = 'hei_prop_cash_crate_half_full'}
            },
          },
          function(data2, menu2)


            local model     = data2.current.value
            local playerPed = GetPlayerPed(-1)
            local coords    = GetEntityCoords(playerPed)
            local forward   = GetEntityForwardVector(playerPed)
            local x, y, z   = table.unpack(coords + forward * 1.0)

            if model == 'prop_roadcone02a' then
              z = z - 2.0
            end

            ESX.Game.SpawnObject(model, {
              x = x,
              y = y,
              z = z
            }, function(obj)
              SetEntityHeading(obj, GetEntityHeading(playerPed))
              PlaceObjectOnGroundProperly(obj)
            end)

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end

    end,
    function(data, menu)

      menu.close()

    end
  )

end

function OpenIdentityCardMenu(player)

  if Config.EnableESXIdentity then

    ESX.TriggerServerCallback('esx_sheriff:getOtherPlayerData', function(data)

      local jobLabel    = nil
      local sexLabel    = nil
      local sex         = nil
      local dobLabel    = nil
      local heightLabel = nil
      local idLabel     = nil

      if data.job.grade_label ~= nil and  data.job.grade_label ~= '' then
        jobLabel = 'Job : ' .. data.job.label .. ' - ' .. data.job.grade_label
      else
        jobLabel = 'Job : ' .. data.job.label
      end

      if data.sex ~= nil then
        if (data.sex == 'm') or (data.sex == 'M') then
          sex = 'Male'
        else
          sex = 'Female'
        end
        sexLabel = 'Sex : ' .. sex
      else
        sexLabel = 'Sex : Unknown'
      end

      if data.dob ~= nil then
        dobLabel = 'DOB : ' .. data.dob
      else
        dobLabel = 'DOB : Unknown'
      end

      if data.height ~= nil then
        heightLabel = 'Height : ' .. data.height
      else
        heightLabel = 'Height : Unknown'
      end

      if data.name ~= nil then
        idLabel = 'ID : ' .. data.name
      else
        idLabel = 'ID : Unknown'
      end

      local elements = {
        {label = _U('name') .. data.firstname .. " " .. data.lastname, value = nil},
        {label = sexLabel,    value = nil},
        {label = dobLabel,    value = nil},
        {label = heightLabel, value = nil},
        {label = jobLabel,    value = nil},
        {label = idLabel,     value = nil},
      }

      if data.drunk ~= nil then
        table.insert(elements, {label = _U('bac') .. data.drunk .. '%', value = nil})
      end

      if data.licenses ~= nil then

        table.insert(elements, {label = '--- Licenses ---', value = nil})

        for i=1, #data.licenses, 1 do
          table.insert(elements, {label = data.licenses[i].label, value = nil})
        end

      end

      ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'citizen_interaction',
        {
          title    = _U('citizen_interaction'),
          align    = 'top-left',
          elements = elements,
        },
        function(data, menu)

        end,
        function(data, menu)
          menu.close()
        end
      )

    end, GetPlayerServerId(player))

  else

    ESX.TriggerServerCallback('esx_sheriff:getOtherPlayerData', function(data)

      local jobLabel = nil

      if data.job.grade_label ~= nil and  data.job.grade_label ~= '' then
        jobLabel = 'Job : ' .. data.job.label .. ' - ' .. data.job.grade_label
      else
        jobLabel = 'Job : ' .. data.job.label
      end

        local elements = {
          {label = _U('name') .. data.name, value = nil},
          {label = jobLabel,              value = nil},
        }

      if data.drunk ~= nil then
        table.insert(elements, {label = _U('bac') .. data.drunk .. '%', value = nil})
      end

      if data.licenses ~= nil then

        table.insert(elements, {label = '--- Licenses ---', value = nil})

        for i=1, #data.licenses, 1 do
          table.insert(elements, {label = data.licenses[i].label, value = nil})
        end

      end

      ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'citizen_interaction',
        {
          title    = _U('citizen_interaction'),
          align    = 'top-left',
          elements = elements,
        },
        function(data, menu)

        end,
        function(data, menu)
          menu.close()
        end
      )

    end, GetPlayerServerId(player))

  end

end

function OpenBodySearchMenu(player)

  ESX.TriggerServerCallback('esx_sheriff:getOtherPlayerData', function(data)

    local elements = {}

    local blackMoney = 0

    for i=1, #data.accounts, 1 do
      if data.accounts[i].name == 'black_money' then
        blackMoney = data.accounts[i].money
      end
    end

    table.insert(elements, {
      label          = _U('confiscate_dirty') .. blackMoney,
      value          = 'black_money',
      itemType       = 'item_account',
      amount         = blackMoney
    })

    table.insert(elements, {label = '--- Armes ---', value = nil})

    for i=1, #data.weapons, 1 do
      table.insert(elements, {
        label          = _U('confiscate') .. ESX.GetWeaponLabel(data.weapons[i].name),
        value          = data.weapons[i].name,
        itemType       = 'item_weapon',
        amount         = data.ammo,
      })
    end

    table.insert(elements, {label = _U('inventory_label'), value = nil})

    for i=1, #data.inventory, 1 do
      if data.inventory[i].count > 0 then
        table.insert(elements, {
          label          = _U('confiscate_inv') .. data.inventory[i].count .. ' ' .. data.inventory[i].label,
          value          = data.inventory[i].name,
          itemType       = 'item_standard',
          amount         = data.inventory[i].count,
        })
      end
    end


    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'body_search',
      {
        title    = _U('search'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        local itemType = data.current.itemType
        local itemName = data.current.value
        local amount   = data.current.amount

        if data.current.value ~= nil then

          TriggerServerEvent('esx_sheriff:confiscatePlayerItem', GetPlayerServerId(player), itemType, itemName, amount)

          OpenBodySearchMenu(player)

        end

      end,
      function(data, menu)
        menu.close()
      end
    )

  end, GetPlayerServerId(player))

end

   function JailPlayer(player)
	ESX.UI.Menu.Open(
		'dialog', GetCurrentResourceName(), 'jail_menu',
		{
			title = _U('jail_menu_info'),
		},
	function (data2, menu)
		local jailTime = tonumber(data2.value)
		if jailTime == nil then
			ESX.ShowNotification(_U('invalid_amount'))
		else
			TriggerServerEvent("esx_jailer:sendToJail", player, jailTime * 60)
			menu.close()
		end
	end,
	function (data2, menu)
		menu.close()
	end
	)
end

function OpenFineMenu(player)

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'fine',
    {
      title    = _U('fine'),
      align    = 'top-left',
      elements = {
        {label = _U('traffic_offense'),   value = 0},
        {label = _U('minor_offense'),     value = 1},
        {label = _U('average_offense'),   value = 2},
        {label = _U('major_offense'),     value = 3}
      },
    },
    function(data, menu)

      OpenFineCategoryMenu(player, data.current.value)

    end,
    function(data, menu)
      menu.close()
    end
  )

end

function OpenFineCategoryMenu(player, category)

  ESX.TriggerServerCallback('esx_sheriff:getFineList', function(fines)

    local elements = {}

    for i=1, #fines, 1 do
      table.insert(elements, {
        label     = fines[i].label .. ' $' .. fines[i].amount,
        value     = fines[i].id,
        amount    = fines[i].amount,
        fineLabel = fines[i].label
      })
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'fine_category',
      {
        title    = _U('fine'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        local label  = data.current.fineLabel
        local amount = data.current.amount

        menu.close()

        if Config.EnablePlayerManagement then
          TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_sheriff', _U('fine_total') .. label, amount)
        else
          TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), '', _U('fine_total') .. label, amount)
        end

        ESX.SetTimeout(300, function()
          OpenFineCategoryMenu(player, category)
        end)

      end,
      function(data, menu)
        menu.close()
      end
    )

  end, category)

end

function OpenVehicleInfosMenu(vehicleData)

  ESX.TriggerServerCallback('esx_sheriff:getVehicleInfos', function(infos)

    local elements = {}

    table.insert(elements, {label = _U('plate') .. infos.plate, value = nil})

    if infos.owner == nil then
      table.insert(elements, {label = _U('owner_unknown'), value = nil})
    else
      table.insert(elements, {label = _U('owner') .. infos.owner, value = nil})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vehicle_infos',
      {
        title    = _U('vehicle_info'),
        align    = 'top-left',
        elements = elements,
      },
      nil,
      function(data, menu)
        menu.close()
      end
    )

  end, vehicleData.plate)

end

function OpenGetWeaponMenu()

  ESX.TriggerServerCallback('esx_sheriff:getArmoryWeapons', function(weapons)

    local elements = {}

    for i=1, #weapons, 1 do
      if weapons[i].count > 0 then
        table.insert(elements, {label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name), value = weapons[i].name})
      end
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory_get_weapon',
      {
        title    = _U('get_weapon_menu'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        menu.close()

        ESX.TriggerServerCallback('esx_sheriff:removeArmoryWeapon', function()
          OpenGetWeaponMenu()
        end, data.current.value)

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function OpenPutWeaponMenu()

  local elements   = {}
  local playerPed  = GetPlayerPed(-1)
  local weaponList = ESX.GetWeaponList()

  for i=1, #weaponList, 1 do

    local weaponHash = GetHashKey(weaponList[i].name)

    if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
      local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
      table.insert(elements, {label = weaponList[i].label, value = weaponList[i].name})
    end

  end

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'armory_put_weapon',
    {
      title    = _U('put_weapon_menu'),
      align    = 'top-left',
      elements = elements,
    },
    function(data, menu)

      menu.close()

      ESX.TriggerServerCallback('esx_sheriff:addArmoryWeapon', function()
        OpenPutWeaponMenu()
      end, data.current.value)

    end,
    function(data, menu)
      menu.close()
    end
  )

end

function OpenBuyWeaponsMenu(station)

  ESX.TriggerServerCallback('esx_sheriff:getArmoryWeapons', function(weapons)

    local elements = {}

    for i=1, #Config.PoliceStations[station].AuthorizedWeapons, 1 do

      local weapon = Config.PoliceStations[station].AuthorizedWeapons[i]
      local count  = 0

      for i=1, #weapons, 1 do
        if weapons[i].name == weapon.name then
          count = weapons[i].count
          break
        end
      end

      table.insert(elements, {label = 'x' .. count .. ' ' .. ESX.GetWeaponLabel(weapon.name) .. ' $' .. weapon.price, value = weapon.name, price = weapon.price})

    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory_buy_weapons',
      {
        title    = _U('buy_weapon_menu'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        ESX.TriggerServerCallback('esx_sheriff:buy', function(hasEnoughMoney)

          if hasEnoughMoney then
            ESX.TriggerServerCallback('esx_sheriff:addArmoryWeapon', function()
              OpenBuyWeaponsMenu(station)
            end, data.current.value)
          else
            ESX.ShowNotification(_U('not_enough_money'))
          end

        end, data.current.price)

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function OpenGetStocksMenu()

  ESX.TriggerServerCallback('esx_sheriff:getStockItems', function(items)

    print(json.encode(items))

    local elements = {}

    for i=1, #items, 1 do
      table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = _U('police_stock'),
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
          {
            title = _U('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(_U('quantity_invalid'))
            else
              menu2.close()
              menu.close()
              OpenGetStocksMenu()

              TriggerServerEvent('esx_sheriff:getStockItem', itemName, count)
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function OpenPutStocksMenu()

  ESX.TriggerServerCallback('esx_sheriff:getPlayerInventory', function(inventory)

    local elements = {}

    for i=1, #inventory.items, 1 do

      local item = inventory.items[i]

      if item.count > 0 then
        table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
      end

    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = _U('inventory'),
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
          {
            title = _U('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(_U('quantity_invalid'))
            else
              menu2.close()
              menu.close()
              OpenPutStocksMenu()

              TriggerServerEvent('esx_sheriff:putStockItems', itemName, count)
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)

  local specialContact = {
    name       = 'Polis',
    number     = 'sherif',
    base64Icon = 'data:image/png;base64,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'
  }

  TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)

end)

AddEventHandler('esx_sheriff:hasEnteredMarker', function(station, part, partNum)

  if part == 'Cloakroom' then
    CurrentAction     = 'menu_cloakroom'
    CurrentActionMsg  = _U('open_cloackroom')
    CurrentActionData = {}
  end

  if part == 'Armory' then
    CurrentAction     = 'menu_armory'
    CurrentActionMsg  = _U('open_armory')
    CurrentActionData = {station = station}
  end

  if part == 'VehicleSpawner' then
    CurrentAction     = 'menu_vehicle_spawner'
    CurrentActionMsg  = _U('vehicle_spawner')
    CurrentActionData = {station = station, partNum = partNum}
  end

  if part == 'HelicopterSpawner' then

    local helicopters = Config.PoliceStations[station].Helicopters

    if not IsAnyVehicleNearPoint(helicopters[partNum].SpawnPoint.x, helicopters[partNum].SpawnPoint.y, helicopters[partNum].SpawnPoint.z,  3.0) then

      ESX.Game.SpawnVehicle('polmav', {
        x = helicopters[partNum].SpawnPoint.x,
        y = helicopters[partNum].SpawnPoint.y,
        z = helicopters[partNum].SpawnPoint.z
      }, helicopters[partNum].Heading, function(vehicle)
        SetVehicleModKit(vehicle, 0)
        SetVehicleLivery(vehicle, 0)
      end)

    end

  end

  if part == 'VehicleDeleter' then

    local playerPed = GetPlayerPed(-1)
    local coords    = GetEntityCoords(playerPed)

    if IsPedInAnyVehicle(playerPed,  false) then

      local vehicle = GetVehiclePedIsIn(playerPed, false)

      if DoesEntityExist(vehicle) then
        CurrentAction     = 'delete_vehicle'
        CurrentActionMsg  = _U('store_vehicle')
        CurrentActionData = {vehicle = vehicle}
      end

    end

  end

  if part == 'BossActions' then
    CurrentAction     = 'menu_boss_actions'
    CurrentActionMsg  = _U('open_bossmenu')
    CurrentActionData = {}
  end

end)

AddEventHandler('esx_sheriff:hasExitedMarker', function(station, part, partNum)
  ESX.UI.Menu.CloseAll()
  CurrentAction = nil
end)

AddEventHandler('esx_sheriff:hasEnteredEntityZone', function(entity)

  local playerPed = GetPlayerPed(-1)

  if PlayerData.job ~= nil and PlayerData.job.name == 'sheriff' and not IsPedInAnyVehicle(playerPed, false) and isOnDuty == true then
    CurrentAction     = 'remove_entity'
    CurrentActionMsg  = _U('remove_object')
    CurrentActionData = {entity = entity}
  end

  if GetEntityModel(entity) == GetHashKey('p_ld_stinger_s') then

    local playerPed = GetPlayerPed(-1)
    local coords    = GetEntityCoords(playerPed)

    if IsPedInAnyVehicle(playerPed,  false) then

      local vehicle = GetVehiclePedIsIn(playerPed)

      for i=0, 7, 1 do
        SetVehicleTyreBurst(vehicle,  i,  true,  1000)
      end

    end

  end

end)

AddEventHandler('esx_sheriff:hasExitedEntityZone', function(entity)

  if CurrentAction == 'remove_entity' then
    CurrentAction = nil
  end

end)

RegisterNetEvent('esx_sheriff:handcuff')
AddEventHandler('esx_sheriff:handcuff', function()

  IsHandcuffed    = not IsHandcuffed;
  local playerPed = GetPlayerPed(-1)

  Citizen.CreateThread(function()

    if IsHandcuffed then

      RequestAnimDict('mp_arresting')

      while not HasAnimDictLoaded('mp_arresting') do
        Wait(100)
      end

      TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
      SetEnableHandcuffs(playerPed, true)
      SetPedCanPlayGestureAnims(playerPed, false)
      FreezeEntityPosition(playerPed,  true)

    else

      ClearPedSecondaryTask(playerPed)
      SetEnableHandcuffs(playerPed, false)
      SetPedCanPlayGestureAnims(playerPed,  true)
      FreezeEntityPosition(playerPed, false)

    end

  end)
end)

RegisterNetEvent('esx_sheriff:drag')
AddEventHandler('esx_sheriff:drag', function(cop)
  TriggerServerEvent('esx:clientLog', 'starting dragging')
  IsDragged = not IsDragged
  CopPed = tonumber(cop)
end)

Citizen.CreateThread(function()
  while true do
    Wait(0)
    if IsHandcuffed then
      if IsDragged then
        local ped = GetPlayerPed(GetPlayerFromServerId(CopPed))
        local myped = GetPlayerPed(-1)
        AttachEntityToEntity(myped, ped, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
      else
        DetachEntity(GetPlayerPed(-1), true, false)
      end
    end
  end
end)

RegisterNetEvent('esx_sheriff:putInVehicle')
AddEventHandler('esx_sheriff:putInVehicle', function()

  local playerPed = GetPlayerPed(-1)
  local coords    = GetEntityCoords(playerPed)

  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

    local vehicle = GetClosestVehicle(coords.x,  coords.y,  coords.z,  5.0,  0,  71)

    if DoesEntityExist(vehicle) then

      local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
      local freeSeat = nil

      for i=maxSeats - 1, 0, -1 do
        if IsVehicleSeatFree(vehicle,  i) then
          freeSeat = i
          break
        end
      end

      if freeSeat ~= nil then
        TaskWarpPedIntoVehicle(playerPed,  vehicle,  freeSeat)
      end

    end

  end

end)

RegisterNetEvent('esx_sheriff:OutVehicle')
AddEventHandler('esx_sheriff:OutVehicle', function(t)
  local ped = GetPlayerPed(t)
  ClearPedTasksImmediately(ped)
  plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
  local xnew = plyPos.x+2
  local ynew = plyPos.y+2

  SetEntityCoords(GetPlayerPed(-1), xnew, ynew, plyPos.z)
end)

-- Handcuff
Citizen.CreateThread(function()
  while true do
    Wait(0)
    if IsHandcuffed then
      DisableControlAction(0, 142, true) -- MeleeAttackAlternate
      DisableControlAction(0, 30,  true) -- MoveLeftRight
      DisableControlAction(0, 31,  true) -- MoveUpDown
      DisableControlAction(0, 24,  true) -- Shoot 
      DisableControlAction(0, 92,  true) -- Shoot in car
      DisableControlAction(0, 75,  true) -- Leave Vehicle
    end
  end
end)

-- Create blips
Citizen.CreateThread(function()

  for k,v in pairs(Config.PoliceStations) do

    local blip = AddBlipForCoord(v.Blip.Pos.x, v.Blip.Pos.y, v.Blip.Pos.z)

    SetBlipSprite (blip, v.Blip.Sprite)
    SetBlipDisplay(blip, v.Blip.Display)
    SetBlipScale  (blip, v.Blip.Scale)
    SetBlipColour (blip, v.Blip.Colour)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(_U('map_blip'))
    EndTextCommandSetBlipName(blip)

  end

end)

-- Display markers
Citizen.CreateThread(function()
  while true do

    Wait(0)

    if PlayerData.job ~= nil and PlayerData.job.name == 'sheriff' then

      local playerPed = GetPlayerPed(-1)
      local coords    = GetEntityCoords(playerPed)

      for k,v in pairs(Config.PoliceStations) do

        for i=1, #v.Cloakrooms, 1 do
          if GetDistanceBetweenCoords(coords,  v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z,  true) < Config.DrawDistance then
            DrawMarker(Config.MarkerType, v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
          end
        end

		if isOnDuty == true then
		
			for i=1, #v.Armories, 1 do
			  if GetDistanceBetweenCoords(coords,  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < Config.DrawDistance then
				DrawMarker(Config.MarkerType, v.Armories[i].x, v.Armories[i].y, v.Armories[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
			  end
			end

			for i=1, #v.Vehicles, 1 do
			  if GetDistanceBetweenCoords(coords,  v.Vehicles[i].Spawner.x,  v.Vehicles[i].Spawner.y,  v.Vehicles[i].Spawner.z,  true) < Config.DrawDistance then
				DrawMarker(Config.MarkerType, v.Vehicles[i].Spawner.x, v.Vehicles[i].Spawner.y, v.Vehicles[i].Spawner.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
			  end
			end

			for i=1, #v.VehicleDeleters, 1 do
			  if GetDistanceBetweenCoords(coords,  v.VehicleDeleters[i].x,  v.VehicleDeleters[i].y,  v.VehicleDeleters[i].z,  true) < Config.DrawDistance then
				DrawMarker(Config.MarkerType, v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
			  end
			end

			if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'sheriff' and PlayerData.job.grade_name == 'boss' then

			  for i=1, #v.BossActions, 1 do
				if not v.BossActions[i].disabled and GetDistanceBetweenCoords(coords,  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < Config.DrawDistance then
				  DrawMarker(Config.MarkerType, v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
				end
			  end

			end
			
		end

      end

    end

  end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()

  while true do

    Wait(0)

    if PlayerData.job ~= nil and PlayerData.job.name == 'sheriff' then

      local playerPed      = GetPlayerPed(-1)
      local coords         = GetEntityCoords(playerPed)
      local isInMarker     = false
      local currentStation = nil
      local currentPart    = nil
      local currentPartNum = nil

      for k,v in pairs(Config.PoliceStations) do

        for i=1, #v.Cloakrooms, 1 do
          if GetDistanceBetweenCoords(coords,  v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z,  true) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'Cloakroom'
            currentPartNum = i
          end
        end

		if isOnDuty == true then
		
			for i=1, #v.Armories, 1 do
			  if GetDistanceBetweenCoords(coords,  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < Config.MarkerSize.x then
				isInMarker     = true
				currentStation = k
				currentPart    = 'Armory'
				currentPartNum = i
			  end
			end

			for i=1, #v.Vehicles, 1 do

			  if GetDistanceBetweenCoords(coords,  v.Vehicles[i].Spawner.x,  v.Vehicles[i].Spawner.y,  v.Vehicles[i].Spawner.z,  true) < Config.MarkerSize.x then
				isInMarker     = true
				currentStation = k
				currentPart    = 'VehicleSpawner'
				currentPartNum = i
			  end

			  if GetDistanceBetweenCoords(coords,  v.Vehicles[i].SpawnPoint.x,  v.Vehicles[i].SpawnPoint.y,  v.Vehicles[i].SpawnPoint.z,  true) < Config.MarkerSize.x then
				isInMarker     = true
				currentStation = k
				currentPart    = 'VehicleSpawnPoint'
				currentPartNum = i
			  end

			end

			for i=1, #v.Helicopters, 1 do

			  if GetDistanceBetweenCoords(coords,  v.Helicopters[i].Spawner.x,  v.Helicopters[i].Spawner.y,  v.Helicopters[i].Spawner.z,  true) < Config.MarkerSize.x then
				isInMarker     = true
				currentStation = k
				currentPart    = 'HelicopterSpawner'
				currentPartNum = i
			  end

			  if GetDistanceBetweenCoords(coords,  v.Helicopters[i].SpawnPoint.x,  v.Helicopters[i].SpawnPoint.y,  v.Helicopters[i].SpawnPoint.z,  true) < Config.MarkerSize.x then
				isInMarker     = true
				currentStation = k
				currentPart    = 'HelicopterSpawnPoint'
				currentPartNum = i
			  end

			end

			for i=1, #v.VehicleDeleters, 1 do
			  if GetDistanceBetweenCoords(coords,  v.VehicleDeleters[i].x,  v.VehicleDeleters[i].y,  v.VehicleDeleters[i].z,  true) < Config.MarkerSize.x then
				isInMarker     = true
				currentStation = k
				currentPart    = 'VehicleDeleter'
				currentPartNum = i
			  end
			end

			if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'sheriff' and PlayerData.job.grade_name == 'boss' then

			  for i=1, #v.BossActions, 1 do
				if GetDistanceBetweenCoords(coords,  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < Config.MarkerSize.x then
				  isInMarker     = true
				  currentStation = k
				  currentPart    = 'BossActions'
				  currentPartNum = i
				end
			  end

			end
			
		end

      end

      local hasExited = false

      if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum) ) then

        if
          (LastStation ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
          (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
        then
          TriggerEvent('esx_sheriff:hasExitedMarker', LastStation, LastPart, LastPartNum)
          hasExited = true
        end

        HasAlreadyEnteredMarker = true
        LastStation             = currentStation
        LastPart                = currentPart
        LastPartNum             = currentPartNum

        TriggerEvent('esx_sheriff:hasEnteredMarker', currentStation, currentPart, currentPartNum)
      end

      if not hasExited and not isInMarker and HasAlreadyEnteredMarker then

        HasAlreadyEnteredMarker = false

        TriggerEvent('esx_sheriff:hasExitedMarker', LastStation, LastPart, LastPartNum)
      end

    end

  end
end)

-- Enter / Exit entity zone events
Citizen.CreateThread(function()

  local trackedEntities = {
    'prop_roadcone02a',
    'prop_barrier_work06a',
    'p_ld_stinger_s',
    'prop_boxpile_07d',
    'hei_prop_cash_crate_half_full'
  }

  while true do

    Citizen.Wait(0)

    local playerPed = GetPlayerPed(-1)
    local coords    = GetEntityCoords(playerPed)

    local closestDistance = -1
    local closestEntity   = nil

    for i=1, #trackedEntities, 1 do

      local object = GetClosestObjectOfType(coords.x,  coords.y,  coords.z,  3.0,  GetHashKey(trackedEntities[i]), false, false, false)

      if DoesEntityExist(object) then

        local objCoords = GetEntityCoords(object)
        local distance  = GetDistanceBetweenCoords(coords.x,  coords.y,  coords.z,  objCoords.x,  objCoords.y,  objCoords.z,  true)

        if closestDistance == -1 or closestDistance > distance then
          closestDistance = distance
          closestEntity   = object
        end

      end

    end

    if closestDistance ~= -1 and closestDistance <= 3.0 then

      if LastEntity ~= closestEntity then
        TriggerEvent('esx_sheriff:hasEnteredEntityZone', closestEntity)
        LastEntity = closestEntity
      end

    else

      if LastEntity ~= nil then
        TriggerEvent('esx_sheriff:hasExitedEntityZone', LastEntity)
        LastEntity = nil
      end

    end

  end
end)

-- Handcuff
Citizen.CreateThread(function()
  while true do
    Wait(0)
    if IsHandcuffed then
      DisableControlAction(0, 142, true) -- MeleeAttackAlternate
      DisableControlAction(0, 30,  true) -- MoveLeftRight
      DisableControlAction(0, 31,  true) -- MoveUpDown
      DisableControlAction(0, 24,  true) -- Shoot 
      DisableControlAction(0, 92,  true) -- Shoot in car
      DisableControlAction(0, 75,  true) -- Leave Vehicle
    end
  end
end)

-- Key Controls
Citizen.CreateThread(function()
  while true do

    Citizen.Wait(0)

    if CurrentAction ~= nil then

      SetTextComponentFormat('STRING')
      AddTextComponentString(CurrentActionMsg)
      DisplayHelpTextFromStringLabel(0, 0, 1, -1)

      if IsControlPressed(0,  Keys['E']) and PlayerData.job ~= nil and PlayerData.job.name == 'sheriff' and (GetGameTimer() - GUI.Time) > 150 then

        if CurrentAction == 'menu_cloakroom' then
          OpenCloakroomMenu()
        end

		if isOnDuty == true then
		
			if CurrentAction == 'menu_armory' then
			  OpenArmoryMenu(CurrentActionData.station)
			end

			if CurrentAction == 'menu_vehicle_spawner' then
			  OpenVehicleSpawnerMenu(CurrentActionData.station, CurrentActionData.partNum)
			end

			if CurrentAction == 'delete_vehicle' then

			  if Config.EnableSocietyOwnedVehicles then

				local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
				TriggerServerEvent('esx_society:putVehicleInGarage', 'police', vehicleProps)

			  else

				if
				  GetEntityModel(vehicle) == GetHashKey('police')  or
				  GetEntityModel(vehicle) == GetHashKey('police2') or
				  GetEntityModel(vehicle) == GetHashKey('police3') or
				  GetEntityModel(vehicle) == GetHashKey('police4') or
				  GetEntityModel(vehicle) == GetHashKey('policeb') or
				  GetEntityModel(vehicle) == GetHashKey('policet')
				then
				  TriggerServerEvent('esx_service:disableService', 'police')
				end

			  end

			  ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
			end

			if CurrentAction == 'menu_boss_actions' then

			  ESX.UI.Menu.CloseAll()

			  TriggerEvent('esx_society:openBossMenu', 'police', function(data, menu)

				menu.close()

				CurrentAction     = 'menu_boss_actions'
				CurrentActionMsg  = _U('open_bossmenu')
				CurrentActionData = {}

			  end)

			end

			if CurrentAction == 'remove_entity' then
			  DeleteEntity(CurrentActionData.entity)
			end
		
		end
		

        CurrentAction = nil
        GUI.Time      = GetGameTimer()

      end

    end

    if isOnDuty == true and IsControlPressed(0,  Keys['=']) and PlayerData.job ~= nil and PlayerData.job.name == 'sheriff' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'police_actions') and (GetGameTimer() - GUI.Time) > 150 then
      OpenPoliceActionsMenu()
      GUI.Time = GetGameTimer()
    end

  end
end)


------------------------------------- police cops blip

local allServiceCops = {}
local blipsCops = {}

RegisterNetEvent('police:resultAllCopsInService')
AddEventHandler('police:resultAllCopsInService', function(array)
	allServiceCops = array
	enableCopBlips()
	
end)

function ServiceOn()
	TriggerServerEvent("police:takeService")
	TriggerServerEvent('eden_garage:debug',"test2")
end

function ServiceOff()
	-- TriggerServerEvent("police:breakService")
	TriggerServerEvent('eden_garage:debug',"test3")
	allServiceCops = {}
	
	for k, existingBlip in pairs(blipsCops) do
        RemoveBlip(existingBlip)
    end
	blipsCops = {}
end

function enableCopBlips()
	TriggerServerEvent('eden_garage:debug',"test1")
	for k, existingBlip in pairs(blipsCops) do
        RemoveBlip(existingBlip)
    end
	blipsCops = {}
	
	local localIdCops = {}
	for id = 0, 64 do
		if(NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= GetPlayerPed(-1)) then
			for i,c in pairs(allServiceCops) do
				if(i == GetPlayerServerId(id)) then
					localIdCops[id] = c
					break
				end
			end
		end
	end
	
	for id, c in pairs(localIdCops) do
		local ped = GetPlayerPed(id)
		local blip = GetBlipFromEntity(ped)
		
		if not DoesBlipExist( blip ) then

			blip = AddBlipForEntity( ped )
			SetBlipSprite( blip, 1 )
			Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true )
			HideNumberOnBlip( blip )
			SetBlipNameToPlayerName( blip, id )
			
			SetBlipScale( blip,  0.85 )
			SetBlipAlpha( blip, 255 )
			
			table.insert(blipsCops, blip)
		else
			
			blipSprite = GetBlipSprite( blip )
			
			HideNumberOnBlip( blip )
			if blipSprite ~= 1 then
				SetBlipSprite( blip, 1 )
				Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true )
			end
			
			Citizen.Trace("Name : "..GetPlayerName(id))
			SetBlipNameToPlayerName( blip, id )
			SetBlipScale( blip,  0.85 )
			SetBlipAlpha( blip, 255 )
			
			table.insert(blipsCops, blip)
		end
	end
end

---------------- Police Radio Animation and Sound On/Off
local soundDistance = 2 -- Distance Radio sound

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 0 )
    end
end

function DisableActions(ped)
    DisableControlAction(1, 140, true)
    DisableControlAction(1, 141, true)
    DisableControlAction(1, 142, true)
    DisableControlAction(1, 37, true) -- Disables INPUT_SELECT_WEAPON (TAB)
    DisablePlayerFiring(ped, true) -- Disable weapon firing
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait( 0 )
        local ped = PlayerPedId()
     if PlayerData.job ~= nil and PlayerData.job.name == 'police' then    
        if DoesEntityExist( ped ) and not IsEntityDead( ped ) then
            if not IsPauseMenuActive() then 
                loadAnimDict( "random@arrests" )
                if IsControlJustReleased( 0, 20 ) then -- INPUT_CHARACTER_WHEEL (LEFT ALT)
                    TriggerServerEvent("InteractSound_SV:PlayWithinDistance", soundDistance, "off", 0.1)    
                    ClearPedTasks(ped)
                    SetEnableHandcuffs(ped, false)
                else
                    if IsControlJustPressed( 0, 20 )  and not IsPlayerFreeAiming(PlayerId()) then -- INPUT_CHARACTER_WHEEL (LEFT ALT)
                        TriggerServerEvent("InteractSound_SV:PlayWithinDistance", soundDistance, "on", 0.1)    
                        TaskPlayAnim(ped, "random@arrests", "generic_radio_enter", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
                        SetEnableHandcuffs(ped, true)
                    elseif IsControlJustPressed( 0, 20 ) and IsPlayerFreeAiming(PlayerId()) then -- INPUT_CHARACTER_WHEEL (LEFT ALT)
                    TriggerServerEvent("InteractSound_SV:PlayWithinDistance", soundDistance, "on", 0.1)    
                        TaskPlayAnim(ped, "random@arrests", "radio_chatter", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
                        SetEnableHandcuffs(ped, true)
                    end 
                    if IsEntityPlayingAnim(GetPlayerPed(PlayerId()), "random@arrests", "generic_radio_enter", 3) then
                        DisableActions(ped)
                    elseif IsEntityPlayingAnim(GetPlayerPed(PlayerId()), "random@arrests", "radio_chatter", 3) then
                        DisableActions(ped)
                    end
                end
            end 
        end
        end 
    end
end )