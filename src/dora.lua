-- dora (with indicators)


-- TODO: make inherit from tile_stack


assert(empty_values)
assert(entity)
assert(wall)
assert(tile)


dora = entity:subclass{
	x = 48,
	y = 52,
	mapping    = split"2,3,4,5,6,7,8,9,1,  11,12,13,14,15,16,17,18,10, 20,21,22,23,24,25,26,27,19, 29,30,31,28, 33,34,32, 6,15,24",
	mapping_rf = split"0,0,0,35,0,0,0,0,0, 0,0,0,36,0,0,0,0,0,         0,0,0,37,0,0,0,0,0,         0,0,0,0,     0,0,0,    0,0,0",
	
	new = function(self)
		return entity.new(self, {
			indicators     = wall:new(),
			ura_indicators = wall:new(),
			n_tiles     = empty_values(),
			n_ura_tiles = empty_values(),
		})
	end,

	add_pair = function(_ENV, ind, ura_ind)
		assert(ura_ind)
		assert(indicators.length < 5)
		assert(ura_indicators.length < 5)

		indicators:add_tile(ind)
		n_tiles[mapping[ind]] += 1
		if mapping_rf[ind] > 0 then
			n_tiles[mapping_rf[ind]] += 1
		end

		ura_indicators:add_tile(ura_ind)
		n_ura_tiles[mapping[ura_ind]] += 1
		if mapping_rf[ura_ind] > 0 then
			n_ura_tiles[mapping_rf[ura_ind]] += 1
		end

		return _ENV
	end,

	draw = function(_ENV)
		local n = indicators.length
		assert( n < 6)
		for i = 1,5 do
			local x1 = x+i*6-6
			tile:new()
			:set_value(indicators.t_tiles[i])
			:set_status(i <= n and 1 or 2)
			:set_pos(x1, y)
			:draw()
		end
		
		return _ENV
	end,
}