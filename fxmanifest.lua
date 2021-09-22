fx_version 'adamant'

author 'Ice Cube 🧊#2334'
game 'gta5'
shared_script '@es_extended/imports.lua'


dependencies {
	'ghmattimysql',
	'linden_inventory'
}

server_scripts {
	'server/main.lua',
	'config_SV.lua',
}

client_scripts {
	'client/main.lua',
	'config.lua',
}


