

function new_wall()
	local n_tiles, i_tiles = {}, {}

	for i = 1,34 do
		add(n_tiles,4)
		for _ = 1,4 do
			add(i_tiles,i)
		end
	end

	-- make red fives
	for i = 0,2 do
		n_tiles[5+i*9] -= 1
		add(n_tiles,1)
		del(i_tiles,5+i*9)
		add(i_tiles,35+i)
	end

	-- shuffle i_tiles
	for i = 136,1,-1 do
		add(i_tiles, del(i_tiles, i_tiles[flr(rnd(i))]))
	end

	return {
		length = 136,
		n_tiles = n_tiles,
		i_tiles = i_tiles
	}
end


function init_wall()
	wall = new_wall()
end


function get_tile()
	assert(wall)
	assert(#wall.i_tiles > 0)
	local t = wall.i_tiles[1]
	del(wall.i_tiles, t)
	wall.n_tiles[t] -= 1
	wall.length -= 1
	return t
end


function draw_wall()
	assert(wall)
	print(wall.length, X_WALL, Y_WALL, 7)
end
