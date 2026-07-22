-- tile stack


assert(stack)
assert(entity)


tile_stack = stack:subclass{
	
	set_tiles = stack.set_elements,
	
	get_values = function(_ENV)
		local values = empty_values()
		foreach(tiles, function(tile)
			values[tile.value] += 1
		end)
		return values
	end,

	apply_tile_states = function(_ENV)
		for i,tile in ipairs(tiles) do
			tile:set_state(tile_states[i])
		end
		return _ENV
	end,

	get_tile_state = function(_ENV, i)
		return {x+i*6-6, y, 1, 1, 1}
	end,

	update_tile_states = function(_ENV)
		tile_states = {}
		for i = 1,length do
			add(tile_states, _ENV:get_tile_state(i))
		end
		return _ENV -- do not call :update()
	end,

	update = function(_ENV)
		length = #elements
		tiles = elements
		return _ENV:update_tile_states()
	end,
	
	draw = function(_ENV)
		foreach(tiles, function(tile) tile:draw() end)
		return _ENV
	end,
}