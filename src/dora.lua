

function new_dora()
	assert(wall)
	return {get_tile()}
end


function init_dora()
	dora = new_dora()
end


function draw_dora()
	assert(dora)
	local n = #dora
	for i = 1,5 do
		local x = X_DORA+i*6-6
		if i <= n then
			draw_tile(dora[i], x, Y_DORA)
		else
			draw_tile_flipped(x, Y_DORA)
		end
	end
end