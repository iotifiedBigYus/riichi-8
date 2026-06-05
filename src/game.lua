

function new_game()
	return {
		i_turn_player = 1,
		n_tiles = {},
		i_tiles = {},
		init_wall = init_wall,
		get_tile = get_tile
	}
end


function init_game()

end


function init_wall(self)
	n_tiles = {}
	i_tiles = {}
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

	self.n_tiles = n_tiles
	self.i_tiles = i_tiles
end


function get_tile(self)
	assert(#self.i_tiles > 0)
	local t = self.i_tiles[1]
	del(self.i_tiles, t)
	self.n_tiles[t] -= 1
	return t
end