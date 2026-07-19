-- large tile


assert(util)
assert(small_tile)

function get_large_tile_face_sprites_vert()
	local sprites = {}

	for tile = 1,37 do
		local spr_numbers_vert = 0x61
		local spr_honors_vert = 0x40-28
		local spr_fives_vert = 0x60

		if tile <= 27 then
			-- number tiles
			add(sprites, spr_numbers_vert+(tile-1)%9)
		elseif tile <= 34 then
			-- honors
			add(sprites, spr_honors_vert+tile)
		else
			-- "red" fives
			add(sprites, spr_fives_vert)
		end
	end
	
	return sprites
end


large_tile = small_tile:subclass{
	ws = split"8,8,8,8",
	hs = split"12,12,12,12",
	w = 8,
	h = 12,
	spr_y = 7,
	spr_h = 1.875,
	face_sprites_vert = get_large_tile_face_sprites_vert(), --TODO: replace with split table

	draw_all_tiles = function(_ENV)
		--debug
		for j = 1,37 do
			_ENV:new()
			:set_tile(j)
			:set_pos(
				4+(j-1)%16*8,
				6+flr((j-1)/16)*12
			)
			:draw()
		end

		return _ENV
	end,

	draw_n_tiles = function(_ENV, n_tiles)
		--debug
		local ox,oy,c = peek(0x5f26),peek(0x5f27),peek(0x5f25)
		local i = 1
		for tile,n in ipairs(n_tiles) do
			for _ = 1,n do
				local x = ox+4+(i-1)%16*8
				local y = oy+6+flr((i-1)/16)*12
				_ENV:new():set_tile(tile):set_pos(x,y):draw()
				poke(0x5f27, y+10)
				i += 1
			end
		end
		poke(0x5f25,c)

		return _ENV
	end,

	draw_i_tiles = function(_ENV, i_tiles)
		--debug
		local ox,oy,c = peek(0x5f26),peek(0x5f27),peek(0x5f25)
		for i,tile in ipairs(i_tiles) do
			local x = ox+4+(i-1)%16*8
			local y = oy+6+flr((i-1)/16)*12
			_ENV:new():set_tile(tile):set_pos(x,y):draw()
			poke(0x5f27, y+10)
		end
		poke(0x5f25,c)

		return _ENV
	end,
}