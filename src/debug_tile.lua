-- tile debug helpers


assert(tile)


function draw_all_tiles()
	--debug
	for i = 1,4 do
		for j = 1,37 do
			tile:new()
			:set_value(j)
			:set_pos(
				1+tile.spr_xs[1]+(j-1)%16*8,
				1+tile.spr_ys[1]+flr((j-1)/16)*8 + (i-1)*32
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


draw_all_large_tiles = function()
	--debug
	for j = 1,37 do
		tile:new()
		:set_value(j)
		:set_size(2)
		:set_pos(
			4+(j-1)%16*8,
			6+flr((j-1)/16)*12
		)
		:draw()
	end
end