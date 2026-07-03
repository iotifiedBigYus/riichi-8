-- game


assert(class)
assert(wall)



game = class:new{
	turn = 1,
	east = 1,

	new = function(self, table)
		assert(self)
		wall1 = wall:new()
		local o = class.new(self, table)
		o.live_wall = wall:new()
		o.dead_wall = wall:new()
		o.players = {}
		return o
	end,

	init = function(_ENV)
		east = rnd{1,2,3,4}
		turn = east
		live_wall:populate()
		for i = 1,14 do
			dead_wall:add_tile(live_wall:get_tile())
		end
		assert(#live_wall.t_tiles == 122)
		assert(live_wall.length == 122)
		assert(#dead_wall.t_tiles == 14)
		assert(dead_wall.length == 14)
	end,
}