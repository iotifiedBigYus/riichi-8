-- wall


--TODO: rewrite shuffle using rnd(table)


assert(empty_values)
assert(tile_stack)
assert(tile)


wall = tile_stack:subclass{
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
		local shuffled_tiles = {}
		for i = 1,136 do
				add(shuffled_tiles, del(tiles,rnd(tiles)))
		end
		tiles = shuffled_tiles

		return _ENV:update()
	end,
}