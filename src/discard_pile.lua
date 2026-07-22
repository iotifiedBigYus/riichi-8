-- discard pile


assert(fit_in_four)
assert(tile_stack)
assert(tile)


discard_pile = tile_stack:subclass{
	riichi_i = 0,
	--length = 0,
	--riichi_row = -1,

	set_riichi_i = function(_ENV, i)
		--debug
		riichi_i = i
		return _ENV:update()
	end,

	add_tile = function(_ENV, tile, in_riichi)
		add(tiles, tile)
		if in_riichi and riichi_i == 0 then
			riichi_i = #tiles
		end
		return _ENV:update()
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

	update = function(_ENV)
		length = #tiles

		riichi_row = flr((riichi_i-1)/6)

		return _ENV:update_tile_states()
	end,
}