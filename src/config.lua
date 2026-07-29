-- config


--TODO: make 0,0 in the center of the screen
--TODO: change colors


poke(0x5f5c, 8) -- set the initial delay before repeating. 255 means never repeat.
poke(0x5f5d, 2) -- set the repeating delay.