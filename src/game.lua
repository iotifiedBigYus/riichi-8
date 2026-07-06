-- game


assert(class)
assert(wall)



game = class:new{
	turn = 1,
	east = 1,

	new = function(self, table)
		assert(self)
		local o = class.new(self, table)
		o.live_wall = wall:new()
		o.dead_wall = wall:new()
		o.t_dora_indicators = {}
		--o.n_dora_tiles = {}
		o.t_uradora_indicators = {}
		--o.n_uradora_tiles = {}
		return o
	end,

	init = function(_ENV)
		east = rnd{1,2,3,4}
		turn = east
		-- init walls
		live_wall:populate()
		for i = 1,14 do
			dead_wall:add_tile(live_wall:get_tile())
		end
		assert(#live_wall.t_tiles == 122)
		assert(live_wall.length == 122)
		assert(#dead_wall.t_tiles == 14)
		assert(dead_wall.length == 14)
		-- init dora
		_ENV:add_dora()
	end,

	add_dora = function(_ENV)
		local t = dead_wall:get_tile()
		add(t_dora_indicators, t)
		--local indicated = split"2,3,4,5,6,7,8,9,1   11,12,13,14,15,16,17,18,10   20,21,22,23,24,25,26,27,19   29,30,31,28   33,34,32"
		--n_dora_tiles[indicated[t]] += 1
	end,

	update = function(_ENV)

	end,

	draw = function(_ENV)

	end,
}


function init_game()
	init_walls()
	init_dora()
	init_cpus()
	init_user()

	game = new_game()
	player = game.players[game.turn]

	for i,p in ipairs(game.players) do
		get_starting_hand(p,i)
	end

	pick_up_tile(player)
	update_user_tile_object_positions()

	if player != user then
		perform_cpu_turn(player)
	end
end


function update_game()
	update_user()

end


function end_turn()
	assert(game)
	assert(user)
	if check_calls() then

	else
		game.turn = game.turn%4+1
		player = game.players[game.turn]

		pick_up_tile(player)
		debug(player)
		if player != user then
			perform_cpu_turn(player)
		end
	end
end


function check_calls()
	-- ron > kan/pon > chi

	return false
end


function draw_game()
	draw_wall()
	draw_turn_indicator()
	draw_dora()
	for i,p in ipairs(game.players) do
		draw_discard_pile(p.discard_pile,i)
		print_player_hand(p.hand, i)
	end
	draw_user()
end


function draw_turn_indicator()
	assert(game)

	camera(-X_CENTER,-Y_CENTER)

	local dx = DX_P1_TURN_INDICATOR
	local dy = DY_P1_TURN_INDICATOR
	local w = W_P1_TURN_INDICATOR
	local h = H_P1_TURN_INDICATOR
	for i = 1,4 do
		rectfill(
			dx,
			dy,
			dx+w,
			dy+h,
			game.turn == i and 10 or 0
		)
		dx,dy,w,h = dy,-dx,h,-w
	end

	camera(0,0)
end