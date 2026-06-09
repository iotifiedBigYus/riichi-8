 
function _init()
	-- When running program, run this once.
	srand(0)

	printh("", "debug", true)
	init_game()
	
	debug("dead wall:",dead_wall)

	--local line = "01m402p403s19z"
	local line = "024m024p024s17z"
	debug("encoding", line, encode_tiles(parse_tiles(line)))
end

function _update60()
	-- update 60 times/sec.
	update_user()
end

function _draw()
	-- similar to update 60, but skip frames if running takes too long.
	cls(1)

	draw_game()

	draw_user(user)

	color(6)
end