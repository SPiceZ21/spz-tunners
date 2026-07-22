fx_version 'cerulean'
game 'gta5'

name 'spz-tunners'
description 'SPiceZ-Core — Dynamic Keyboard-Driven Vehicle Tuning & Customization Resource built with ox_lib'
version '1.0.0'
author 'SPiceZ'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'shared/colors.lua'
}

client_scripts {
    'client/cam.lua',
    'client/menu.lua',
    'client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

dependencies {
    'ox_lib'
}
