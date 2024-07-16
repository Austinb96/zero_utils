name "zero_utils"
author "ZeroShadow"
version "1.0.0"
description "Utils for zero stuff"
fx_version "cerulean"
game "gta5"
lua54 'yes'

client_scripts {
    'client/*.lua',
    'client/callbacks/*.lua',
    'client/imports/*.lua',
}

server_scripts {
    'server/*.lua',
    'server/callbacks/*.lua',
    'server/imports/*.lua',
}
shared_scripts {
    '@ox_lib/init.lua',
    'init.lua',
    'config.lua',
    'shared/*.lua',
    'shared/imports/*.lua',
}

files {
    'client/bridge/**.lua',
    'server/bridge/**.lua',
}

dependency '/assetpacks'