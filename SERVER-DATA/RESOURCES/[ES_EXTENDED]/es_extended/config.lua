Config = {}
Config.Locale = 'en'

Config.Accounts = {
	bank = _U('account_bank'),
	money = _U('account_money')
}

Config.StartingAccountBank = {bank = 1000000}
Config.StartingAccountMoney = {money = 1000000}

Config.EnableSocietyPayouts = false -- pay from the society account that the player is employed at? Requirement: esx_society
Config.EnableHud            = false -- enable the default hud? Display current job and accounts (black, bank & cash)
Config.MaxWeight            = 24   -- the max inventory weight without backpack
Config.PaycheckInterval     = 7 * 60000 -- how often to recieve pay checks in milliseconds
Config.EnableDebug          = true
