name "zero-utils"
author "ZeroShadow"
version "v0.0.1alpha"
description "Utils for Zero Scripts by ZeroShadow"
fx_version "cerulean"
game "gta5"
lua54 'yes'

shared_scripts {
	'PrintUtils.lua',
	'Shared/init.lua',
	'Shared/Utils/*.lua',
	'Shared/Compatability/*.lua'
}

server_scripts {
    'Server/*.lua' ,
    'Server/Compatability/*.lua' ,
}
client_scripts {
	'Client/Utils/*.lua',
	'Client/*.lua',
	'Client/Compatability/*.lua',
}

