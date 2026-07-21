-- discard pile

--TODO: make inherit from hand/wall

assert(fit_in_four)
assert(entity)
assert(tile)


discard_pile = entity:subclass{
	riichi_i = 0,
	--length = 0,
	--riichi_row = -1,

	new = function(self)
		return entity.new(self, {
			tiles = {},
			tile_states = {},
		})
	end,

	add_tile = function(_ENV, tile, in_riichi)
		add(tiles, tile)
		if in_riichi and riichi_i == 0 then
			riichi_i = #tiles
		end
		_ENV:update()
		return _ENV
	end,

	remove_latest_tile = function(_ENV, t)
		tile = deli(tiles)
		_ENV:update()
		return tile
	end,

	get_tile_state = function(_ENV, i)
		local row = flr((i-1)/6)
		local x = (i-1)%6*6+3
		local y = row*8+4
		local tile_rotation = rotation

		if riichi_row == row and i > riichi_i then
			x+=2
		elseif riichi_i == i then
			x+=1
			tile_rotation = rotation+1
		end

		local tile_x, tile_y = _ENV:get_rotated_pos(x,y)
		return {
			tile_x,
			tile_y,
			tile_rotation,
			1,
		}
	end,

	apply_tile_states = function(_ENV)
		for i,tile in ipairs(tiles) do
			tile:set_state(tile_states[i])
		end
		return _ENV
	end,

	update = function(_ENV)
		length = #tiles

		riichi_row = flr((riichi_i-1)/6)

		tile_states = {}
		for i = 1,length do
			add(tile_states, _ENV:get_tile_state(i))
		end

		return _ENV
	end,

	draw = function(_ENV)
		foreach(tiles, function(tile) tile:draw() end)
		return _ENV
	end,
}