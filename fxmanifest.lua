fx_version 'cerulean'
game 'gta5'

description 'Electrician Job - By Spinks'
version '1.0.0'

shared_script 'config.lua'

client_script 'client/main.lua'
server_script 'server/main.lua'

lua54 'yes'

escrow_ignore {
    'config.lua'
}