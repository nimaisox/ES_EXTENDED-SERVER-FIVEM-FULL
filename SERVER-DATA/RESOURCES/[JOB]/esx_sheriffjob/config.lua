Config                            = {}
Config.DrawDistance               = 100.0
Config.MarkerType                 = 1
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 1.0 }
Config.MarkerColor                = { r = 50, g = 50, b = 204 }
Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = true -- only turn this on if you are using esx_identity
Config.EnableNonFreemodePeds      = true -- turn this on if you want custom peds
Config.EnableSocietyOwnedVehicles = false
Config.EnableLicenses             = false
Config.MaxInService               = -1
Config.Locale                     = 'en'

Config.PoliceStations = {

  Sherif = {

    Blip = {
      Pos     = { x = 1851.81, y = 3690.65, z = 34.267 },
      Sprite  = 60,
      Display = 4,
      Scale   = 1.2,
      Colour  = 29,
    },
	


    AuthorizedWeapons = {
      { name = 'WEAPON_NIGHTSTICK',       price = 200 },
      { name = 'WEAPON_COMBATPISTOL',     price = 300 },
      { name = 'WEAPON_SMG',       price = 1250 },
      { name = 'WEAPON_CARBINERIFLE',     price = 1500 },
      { name = 'WEAPON_PUMPSHOTGUN',      price = 600 },
      { name = 'WEAPON_STUNGUN',          price = 500 },
      { name = 'WEAPON_FLASHLIGHT',       price = 80 },
      { name = 'WEAPON_FIREEXTINGUISHER', price = 120 },
      { name = 'WEAPON_FLAREGUN',         price = 60 },
      { name = 'WEAPON_STICKYBOMB',       price = 250 },
      { name = 'GADGET_PARACHUTE',        price = 300 },
	  { name = 'WEAPON_SMOKEGRENADE',        price = 200 },
    },

    AuthorizedVehicles = {
      { name = 'police',  label = 'Véhicule de patrouille 1' },
      { name = 'police2', label = 'Véhicule de patrouille 2' },
      { name = 'police3', label = 'Véhicule de patrouille 3' },
      { name = 'police4', label = 'Véhicule civil' },
      { name = 'policeb', label = 'Moto' },
      { name = 'policet', label = 'Van de transport' },
    },

    Cloakrooms = {
      { x = 1851.81, y = 3690.65, z = 33.267 },
    },

    Armories = {
      { x = 1857.32, y = 3688.91, z = 33.267 },
    },

    Vehicles = {
      {
        Spawner    = { x = 1861.88, y = 3680.12, z = 32.6832 },
        SpawnPoint = { x = 1872.48, y = 3685.04, z = 32.6055 },
        Heading    = 90.0,
      }
    },

    Helicopters = {
      {
        Spawner    = { x = 466.477, y = -982.819, z = 35.691 },
        SpawnPoint = { x = 450.04, y = -981.14, z = 35.691 },
        Heading    = 0.0,
      }
    },

    VehicleDeleters = {
      { x = 1869.8, y = 3691.84, z = 33.6469 },
    },

    BossActions = {
      { x = 1853.42, y = 3689.48, z = 33.267 }
    },

  },

}
