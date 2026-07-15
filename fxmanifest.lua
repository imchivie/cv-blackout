fx_version 'cerulean'
game 'gta5'
author 'imchivie'
github 'https://github.com/imchivie'
description 'Simple blackout toggle script for QB-WeatherSync with dramatic sound/effects'
version '1.1.1'

server_script {
    'server/server.lua',
    'server/versioncheck.lua'
}

client_script {
    'client/client.lua'
}

shared_script {
    'config.lua'
}
escrow_ignore {
    'config.lua',
    'sounds/*'
}