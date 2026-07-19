 
function _init()
	-- When running program, run this once.
	srand(0)

	printh("", "debug", true)
	game0 = game:new()
end

function _update60()
	-- update 60 times/sec.
	game0:update()
end

function _draw()
	-- similar to update 60, but skip frames if running takes too long.
	cls(1)

	game0:draw()

	color(6)

	print(game0.east)
	print(game0.turn)
end