fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'MakSSym'
description 'Skrypt na windy'
version '2.0.0'

client_scripts {
	'config.lua',
	'main/client.lua',
}

shared_scripts {
    '@ox_lib/init.lua',
}

files {
    'html/music.mp3',
	'html/index.html',
}

ui_page 'html/index.html'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
    'main/server.lua',
}

dependencies {
    'es_extended',
    'ox_lib',
}

