-- Manifest Version
fx_version 'adamant'
--

-- Game
game 'gta5'
--

-- Lua 54 
lua54 'yes'
--

-- Description
description 'Progressive Code Crosshair Menu'
--

-- Author
author 'ZaYn'
--

-- Client Files
client_scripts {
    'Config/Main.lua',

    'Client/Main.lua'
}
--

-- Design
ui_page 'Html/Crosshair.html'

files {
	'Html/Crosshair.html',
    
	'Html/Webfonts/*.ttf',

	'Html/Images/Crosshairs/*.png',
	
	'Html/Css/*.css',

	'Html/Js/Crosshair.js',
}
--

-- Ignore Escrow Files
escrow_ignore 'Config/Main.lua'
--