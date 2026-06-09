

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


function new_dead_wall()
	local n_tiles, i_tiles = empty_tiles(), {}
	debug(n_tiles, i_tiles)
	for _ = 1,14 do
		local t = get_tile()
		n_tiles[t] += 1
		add(i_tiles,t)
	end
	return {
		length = 14,
		n_tiles = n_tiles,
		i_tiles = i_tiles
	}
end


function init_walls()
	wall = new_wall()
	dead_wall = new_dead_wall()
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


function get_dead_tile()
	assert(dead_wall)
	assert(#dead_wall.i_tiles > 0)
	local t = dead_wall.i_tiles[1]
	del(dead_wall.i_tiles, t)
	dead_wall.n_tiles[t] -= 1
	dead_wall.length -= 1
	return t
end


function draw_wall()
	assert(wall)
	print(wall.length, X_WALL, Y_WALL, 7)
end
