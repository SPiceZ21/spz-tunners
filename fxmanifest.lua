fx_version 'cerulean'
game 'gta5'

name 'spz-tunners'
description 'SPiceZ-Core — Dynamic Keyboard-Driven Vehicle Tuning & Customization Resource built with ox_lib'
version '1.3.1'
author 'SPiceZ'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'shared/colors.lua'
}

client_scripts {
    '@spz-hud/shim.lua',   -- NUI goes through spz-hud
    'client/cam.lua',
    'client/menu.lua',
    'client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

-- ui_page 'ui/index.html'  -- drawn by spz-hud now (web/public/apps/spz-tunners); uncomment + drop the shim to roll back

files {
    'data/carcols_gen9.meta',
    'data/carmodcols_gen9.meta',
    'ui/index.html',
    'ui/style.css',
    'ui/app.js',
    'ui/fonts/*.ttf',
}

-- Fubuki-jo chameleon paints (223-242). stream/vehicle_paint_ramps.ytd holds
-- their colour ramps.
data_file 'CARCOLS_GEN9_FILE' 'data/carcols_gen9.meta'
data_file 'CARMODCOLS_GEN9_FILE' 'data/carmodcols_gen9.meta'

dependencies {
    'spz-hud',
    'ox_lib'
}
