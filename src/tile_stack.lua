-- tile stack


assert(entity)


tile_stack = entity:subclass{
	--length = 0,

	new = function(self)
		return entity.new(self, {
			tiles = {},
			--tile_states = {},
		})
	end,

	set_tiles = function(_ENV, new_tiles)
		tiles = new_tiles
		return _ENV:update()
	end,

	get_values = function(_ENV)
		local values = empty_values()
		foreach(tiles, function(tile)
			values[tile.value] += 1
		end)
		return values
	end,

	get_tile_state = function(_ENV, i)
		return {x+i*6-6, y, 1, 1}
	end,

	add_tile = function(_ENV, tile)
		add(tiles, tile)
		return _ENV:update()
	end,

	add_tiles = function(_ENV, new_tiles)
		--trim
		foreach(new_tiles, function(tile)
			add(tiles, tile)
		end)
		return _ENV:update()
	end,
	
	remove_tile = function(_ENV, tile)
		local removed_tile = del(tiles, tile)
		_ENV:update()
		return removed_tile
	end,

	remove_latest_tile = function(_ENV)
		local tile = deli(tiles)
		_ENV:update()
		return tile
	end,

	remove_latest_tiles = function(_ENV, n)
		local removed_tiles = {}
		for _ = 1,n do
			add(removed_tiles, deli(tiles))
		end
		_ENV:update()
		return removed_tiles
	end,

	apply_tile_states = function(_ENV)
		for i,tile in ipairs(tiles) do
			tile:set_state(tile_states[i])
		end
		return _ENV
	end,

	update_tile_states = function(_ENV)
		tile_states = {}
		for i = 1,length do
			add(tile_states, _ENV:get_tile_state(i))
		end
		return _ENV -- do not call :update()
	end,

	update = function(_ENV)
		length = #tiles
		return _ENV:update_tile_states()
	end,
	
	draw = function(_ENV)
		foreach(tiles, function(tile) tile:draw() end)
		return _ENV
	end,
}