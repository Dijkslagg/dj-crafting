fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description 'DJ Crafting script'
version '1.0.0'
author 'Dijkslag#0'

shared_script 'config.lua'
server_script '@oxmysql/lib/MySQL.lua'
server_script 'server/server.lua'
client_script 'client/client.lua'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/styles.css',
    'html/script.js'
}

