Config                            = {}

Config.DrawDistance               = 100.0

Config.Marker                     = { type = 1, x = 1.5, y = 1.5, z = 1.5, r = 255, g = 204, b = 2, a = 100, rotate = false }

Config.ReviveReward               = 20000  -- revive reward, set to 0 if you don't want it enabled
Config.AntiCombatLog              = true -- enable anti-combat logging?
Config.LoadIpl                    = true -- disable if you're using fivem-ipl or other IPL loaders

Config.Locale                     = 'en'

local second = 1000
local minute = 60 * second

Config.EarlyRespawnTimer          = 500 * second  -- Time til respawn is available
Config.BleedoutTimer              = 500 * second -- Time til the player bleeds out

Config.EnablePlayerManagement     = true

Config.RemoveWeaponsAfterRPDeath  = true
Config.RemoveCashAfterRPDeath     = true
Config.RemoveItemsAfterRPDeath    = true

-- Let the player pay for respawning early, only if he can afford it.
Config.EarlyRespawnFine           = false
Config.EarlyRespawnFineAmount     = 5000

Config.RespawnPoint = { coords = vector3(380.02, -1400.46, 33.53), heading = 50.57 }

Config.Hospitals = {

	CentralLosSantos = {

		Blip = {
			coords = vector3(338.4, -1420.86, 32.51),
			sprite = 305,
			scale  = 1.2,
			color  = 1
		},

		AmbulanceActions = {
			vector3(372.76, -1393.27, 32.51)
		},

		Pharmacies = {
			vector3(380.64, -1405.56, 32.51)
		},

		Vehicles = {
			{
				Spawner = vector3(308.02, -1448.52, 29.97),
				InsideShop = vector3(446.7, -1355.6, 43.5),
				Marker = { type = 36, x = 1.0, y = 1.0, z = 1.0, r = 100, g = 50, b = 200, a = 100, rotate = true },
				SpawnPoints = {
					{ coords = vector3(292.8, -1431.34, 29.8), heading = 341.16, radius = 4.0 },
					{ coords = vector3(292.6, -1431.34, 29.86), heading = 340.83, radius = 4.0 },
					{ coords = vector3(292.7, -1431.34, 29.8), heading = 341.6, radius = 6.0 }
				}
			}
		},

		VehiclesDeleter = {
			{
				Marker = { type = 24, x = 1.0, y = 1.0, z = 1.0, r = 255, g = 0, b = 0, a = 100, rotate = true },
				Deleter = vector3(313.2, -1444.59, 29.8)
			},
			{
				Marker = { type = 24, x = 3.5, y = 3.5, z = 1.0, r = 255, g = 0, b = 0, a = 100, rotate = true },
				Deleter = vector3(352.15, -588.34, 74.17)
			}
		},

		Helicopters = {
			{
				Spawner = vector3(318.96, -1457.61, 46.51),
				InsideShop = vector3(305.6, -1419.7, 41.5),
				Marker = { type = 34, x = 1.5, y = 1.5, z = 1.5, r = 100, g = 150, b = 150, a = 100, rotate = true },
				SpawnPoints = {
					{ coords = vector3(299.52, -1453.27, 46.51), heading = 25.3, radius = 10.0 }
				}
			}
		},

		FastTravels = {
			--[[{
				From = vector3(294.7, -1448.1, 29.0),
				To = { coords = vector3(272.8, -1358.8, 23.5), heading = 0.0 },
				Marker = { type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }
			},

			{
				From = vector3(275.3, -1361, 23.5),
				To = { coords = vector3(295.8, -1446.5, 28.9), heading = 0.0 },
				Marker = { type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }
			},

			{
				From = vector3(247.3, -1371.5, 23.5),
				To = { coords = vector3(333.1, -1434.9, 45.5), heading = 138.6 },
				Marker = { type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }
			},

			{
				From = vector3(335.5, -1432.0, 45.50),
				To = { coords = vector3(249.1, -1369.6, 23.5), heading = 0.0 },
				Marker = { type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }
			},

			{
				From = vector3(234.5, -1373.7, 20.9),
				To = { coords = vector3(320.9, -1478.6, 28.8), heading = 0.0 },
				Marker = { type = 1, x = 1.5, y = 1.5, z = 1.0, r = 102, g = 0, b = 102, a = 100, rotate = false }
			},

			{
				From = vector3(317.9, -1476.1, 28.9),
				To = { coords = vector3(238.6, -1368.4, 23.5), heading = 0.0 },
				Marker = { type = 1, x = 1.5, y = 1.5, z = 1.0, r = 102, g = 0, b = 102, a = 100, rotate = false }
			}
			]]
		},

		FastTravelsPrompt = {
			{
				From = vector3(331.82, -595.36, 42.28),
				To = {coords = vector3(341.97, -586.11, 74.17), heading = 0.0},
				Marker = {type = 23, x = 1.5, y = 1.5, z = 0.5, r = 255, g = 255, b = 255, a = 100, rotate = false},
				Prompt = _U('fast_travel')
			},

			{
				From = vector3(339.43, -583.97, 73.17),
				To = {coords = vector3(331.82, -595.36, 42.28), heading = 0.0},
				Marker = {type = 23, x = 1.5, y = 1.5, z = 0.5, r = 255, g = 255, b = 255, a = 100, rotate = false},
				Prompt = _U('fast_travel')
			}
		}

	}
}

Config.AuthorizedVehicles = {

	ambulance = {
		{ model = 'tigerunimed', label = 'Ambulance motorn', price = 35000},
	},

	doctor = {
		{ model = 'tigerunimed', label = 'Ambulance motor', price = 35000},
		{ model = 'dodgeEMS', label = 'Doge', price = 70000},
	},

	chief_doctor = {
		{ model = 'tigerunimed', label = 'Ambulance motor', price = 35000},
		{ model = 'dodgeEMS', label = 'Doge', price = 70000},
		
	},

	boss = {
		{ model = 'tigerunimed', label = 'Ambulance motor', price = 35000},
		{ model = 'dodgeEMS', label = 'Doge', price = 70000},
	}

}

Config.AuthorizedHelicopters = {

	ambulance = {},

	doctor = {
		{ model = 'md902', label = 'md902', price = 150000 },
		{ model = 'seasparrow', label = 'seasparrow', price = 150000 },
		{ model = 'mh65c', label = 'heli', price = 150000 },
	},

	chief_doctor = {
		{ model = 'md902', label = 'md902', price = 150000 },
		{ model = 'seasparrow', label = 'seasparrow', price = 150000 },
		{ model = 'mh65c', label = 'heli', price = 150000 },
	},

	boss = {
		{ model = 'md902', label = 'md902', price = 10 },
		{ model = 'seasparrow', label = 'seasparrow', price = 10 },
		{ model = 'mh65c', label = 'heli', price = 150000 },
	}

}
