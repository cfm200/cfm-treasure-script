fx_version 'cerulean'
game 'gta5'

lua54 'yes'

author 'cfm200'
description 'Treasure hunt script'
version '1.0.0'

client_scripts {
  'client/main.lua',
}

server_scripts {
  'server.lua'
}

shared_scripts {
  'config.lua',
  '@ox_lib/init.lua'
}