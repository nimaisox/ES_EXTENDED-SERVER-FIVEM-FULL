fx_version 'cerulean'
games { 'rdr3', 'gta5' }

author 'nimasiso'
description 'playtime'
version '1.0.0'

server_scripts {
	"@mysql-async/lib/MySQL.lua",
	"server.lua",
	"config.lua"
}

client_scripts {
	"client.lua",
	"config.lua"
}

dependencies {
	'mysql-async',
	'es_extended',
	'async',
}