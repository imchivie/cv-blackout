fx_version 'cerulean'
game 'gta5'
author 'imchivie'
github 'https://github.com/imchivie'
description 'Simple blackout toggle script for QB-WeatherSync with dramatic sound/effects'
version '1.1.0'

server_script {
    'server.lua'
}

client_script {
    'client.lua'
}

shared_script {
    'config.lua'
}
escrow_ignore {
    'config.lua',
    'sounds/*'
}