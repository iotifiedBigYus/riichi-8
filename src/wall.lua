-- wall


--TODO: make entity, with tiles instead of values


assert(empty_values)
assert(entity)
assert(tile)


wall = entity:subclass{
	--length = 0,

	new = function(self)
		return entity.new(self, {
			tiles   = {}
		})
	end,

	populate = function(_ENV, seed)
		tiles = {}
		for i = 1,34 do
			for _ = 1,4 do
				add(tiles,tile:new():set_value(i))
			end
		end
	
		-- make red fives
		for i = 0,2 do
			tiles[4*(5+i*9)]:set_value(35+i)
		end
	
		-- shuffle
		if seed then srand(seed) end
		for i = 136,1,-1 do
			add(tiles, deli(tiles, flr(rnd(i))))
		end

		_ENV:update()
		return _ENV
	end,

	add_tile = function(_ENV, tile)
		add(tiles, tile)
		_ENV:update()
		return _ENV
	end,

	remove_latest_tile = function(_ENV)
		local tile = deli(tiles)
		_ENV:update()
		return tile
	end,

	get_values = function(_ENV)
		local values = empty_values()
		foreach(tiles, function(tile)
			values[tile.value] += 1
		end)
		return values
	end,

	update = function(_ENV)
		length = #tiles

		return _ENV
	end,
}