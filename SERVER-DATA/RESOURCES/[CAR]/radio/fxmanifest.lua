fx_version 'bodacious'
game 'gta5'

author 'nimaiso'
description 'This resource allows you to integrate your own radios in place of the original radios'
version '2.0.0'

-- Example custom radios
-- supersede_radio "RADIO_01_CLASS_ROCK" { url = "https://playload.ir/mamad.ogg", volume = 0.8 }
supersede_radio "RADIO_02_POP" { url = "https://cdn.discordapp.com/attachments/873650700595376148/923278506484449290/nima.ogg", volume = 0.8 }
-- supersede_radio "RADIO_03_HIPHOP_NEW" { url = "https://playload.ir/moji.ogg", volume = 0.8 }
supersede_radio "RADIO_04_PUNK" { url = "https://cdn.discordapp.com/attachments/873650700595376148/923278506987749387/ZedBazi_Obi_320.ogg", volume = 0.8 }
-- supersede_radio "RADIO_05_TALK_01" { url = "https://playload.ir/Parsalip_-_Bazandeh.ogg", volume = 0.8 }

files {
	'index.html'
}

ui_page 'index.html'

client_scripts {
	'data.js',
	'client.js'
}
