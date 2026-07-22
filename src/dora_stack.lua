-- dora (indicator) stack


--[[
two stacks will be needed, one for dora and the other for uradora
]]


assert(empty_values)
assert(entity)
assert(tile_stack)


dora_stack = tile_stack:subclass{
	x = 48,
	y = 52,
	mapping = split[[
		2,3,4,5,6,7,8,9,1, 
		11,12,13,14,15,16,17,18,10,
		20,21,22,23,24,25,26,27,19,
		29,30,31,28,
		33,34,32,
		6,15,24,

		0,0,0,35,0,0,0,0,0,
		0,0,0,36,0,0,0,0,0,
		0,0,0,37,0,0,0,0,0,
		0,0,0,0,
		0,0,0,
		0,0,0,
	]],

	get_dora_values = function(_ENV)
		local values = empty_values()
		foreach(tiles, function(tile)
			values[mapping[tile.value] ] += 1
			if mapping[tile.value+37] > 0 then
				values[mapping[tile.value+37] ] += 1
			end
		end)
		return values
	end,
}