-- tile debug helpers


assert(tile)


function draw_all_tiles()
	--debug
	for i = 1,4 do
		for j = 1,37 do
			tile:new()
			:set_value(j)
			:set_pos(
				1+tile.spr_x+(j-1)%16*8,
				1+tile.spr_y+flr((j-1)/16)*8 + (i-1)*32
			)
			:set_rotation(i)
			:draw()
		end
		for j = 1,4 do
			tile:new()
			:set_status(j)
			:set_pos(
				4+(j-1)%16*8,
				4+flr((j-1)/16)*8 + (i-1)*32 + 24
			)
			:set_rotation(i)
			:draw()
		end
	end
end


function draw_n_tiles(n_tiles)
	--debug
	local ox,oy,c = peek(0x5f26),peek(0x5f27),peek(0x5f25)
	local i = 1
	for value,n in ipairs(n_tiles) do
		for _ = 1,n do
			local x = ox+3+(i-1)%16*6
			local y = oy+4+flr((i-1)/16)*8
			tile:new():set_value(value):set_pos(x,y):draw()
			poke(0x5f27, y+10)
			i += 1
		end
	end
	poke(0x5f25,c)
end


function draw_i_tiles(i_tiles)
	--debug
	local ox,oy,c = peek(0x5f26),peek(0x5f27),peek(0x5f25)
	for i,value in ipairs(i_tiles) do
		local x = ox+3+(i-1)%16*6
		local y = oy+4+flr((i-1)/16)*8
		tile:new():set_value(value):set_pos(x,y):draw()
		poke(0x5f27, y+10)
	end
	poke(0x5f25,c)
end