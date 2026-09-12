-- dora (indicator) stack


--[[
two stacks will be needed, one for dora and the other for uradora
]]

--TODO: use collection instead of empty_values


assert(empty_values)
assert(entity)
assert(tile_stack)


dora_stack = tile_stack:subclass{
	mapping = split[[
		2,3,4,5,6,7,8,9,1,
		11,12,13,14,15,16,17,18,10,
		20,21,22,23,24,25,26,27,19,
		29,30,31,28,
		33,34,32,
	]],

	get_dora_values = function(_ENV)
		local values = empty_values()
		foreach(tiles, function(tile)
			values[ mapping[tile.value] ] += 1
		end)
		return values
	end,
}