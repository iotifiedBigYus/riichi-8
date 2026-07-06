-- wall


assert(util)
assert(class)

wall = class:new{
	length = 0,

	new = function(self, table)
		assert(self)
		local o = class.new(self, table)
		o.n_tiles = empty_tiles()
		o.t_tiles = {}
		return o
	end,

	get_tile = function(_ENV)
		if #t_tiles == 0 then return end
		local t = deli(t_tiles)
		n_tiles[t] -= 1
		length -= 1
		return t
	end,

	add_tile = function(_ENV, t)
		add(t_tiles, t)
		n_tiles[t] += 1
		length += 1
	end,

	populate = function(_ENV)
		for i = 1,34 do
			n_tiles[i] = 4
			for _ = 1,4 do
				add(t_tiles,i)
			end
		end
		length = 136
	
		-- make red fives
		for i = 0,2 do
			n_tiles[5+i*9] -= 1
			n_tiles[35+i] += 1
			del(t_tiles,5+i*9)
			add(t_tiles,35+i)
		end
	
		-- shuffle i_tiles
		for i = 136,1,-1 do
			add(t_tiles, deli(t_tiles, flr(rnd(i))))
		end
	end,

	draw = function(_ENV)
		print(length, X_WALL, Y_WALL, 7)
	end
}