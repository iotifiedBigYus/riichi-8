-- large tile debug helpers


assert(large_tile)


draw_all_large_tiles = function()
	--debug
	for j = 1,37 do
		large_tile:new()
		:set_value(j)
		:set_pos(
			4+(j-1)%16*8,
			6+flr((j-1)/16)*12
		)
		:draw()
	end
end


draw_large_n_tiles = function(n_tiles)
	--debug
	local ox,oy,c = peek(0x5f26),peek(0x5f27),peek(0x5f25)
	local i = 1
	for tile,n in ipairs(n_tiles) do
		for _ = 1,n do
			local x = ox+4+(i-1)%16*8
			local y = oy+6+flr((i-1)/16)*12
			large_tile:new():set_value(tile):set_pos(x,y):draw()
			poke(0x5f27, y+10)
			i += 1
		end
	end
	poke(0x5f25,c)
end


draw_large_i_tiles = function(i_tiles)
	--debug
	local ox,oy,c = peek(0x5f26),peek(0x5f27),peek(0x5f25)
	for i,tile in ipairs(i_tiles) do
		local x = ox+4+(i-1)%16*8
		local y = oy+6+flr((i-1)/16)*12
		large_tile:new():set_value(tile):set_pos(x,y):draw()
		poke(0x5f27, y+10)
	end
	poke(0x5f25,c)
end,