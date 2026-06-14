 
function _init()
	-- When running program, run this once.
	srand(0)

	printh("", "debug", true)
	init_game()
	
end

function _update60()
	-- update 60 times/sec.
	update_game()
end

function _draw()
	-- similar to update 60, but skip frames if running takes too long.
	cls(1)

	draw_game()

	color(6)

	print(game.east)
	print(game.turn)
end