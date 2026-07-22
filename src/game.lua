-- game


--TODO: clean up methods


assert(entity)
assert(wall)
assert(dora_stack)
assert(player)


game = entity:subclass{
	x = 63,
	y = 56,
	dora_x = -15,
	dora_y = -4,


	new = function(self)
		local _ENV = entity.new(self)

		east = rnd(split"1,2,3,4")
		turn = east

		-- init walls
		dead_wall = wall:new()
		live_wall = wall:new()
		live_wall:populate()
		for i = 1,14 do
			dead_wall:add_tile(live_wall:remove_latest_tile())
		end
		assert(live_wall.length == 122)
		assert(dead_wall.length == 14)

		dora_stack = dora_stack:new():add_tile(dead_wall:remove_latest_tile())
		uradora_stack = dora_stack:new():add_tile(dead_wall:remove_latest_tile())

		assert(dora_stack.length == 1)
		assert(uradora_stack.length == 1)
		assert(dead_wall.length == 12)

		-- init players
		players = {}

		for i = 1,4 do
			local player = global.player:new()
			player.hand:set_tiles(live_wall:remove_latest_tiles(13)):set_status(3)
			add(players, player)
			assert(live_wall.length == 122 - i*13)
		end

		players[turn].hand:add_tiles(live_wall:remove_latest_tile())
		assert(live_wall.length == 69)


		

		return _ENV:update()
	end,

	apply_tile_states = function(_ENV)
		dora_stack:set_pos(_ENV:get_rotated_pos(dora_x, dora_y)):apply_tile_states()
		for i,p in ipairs(players) do
			p:set_state({x, y, i}):apply_tile_states()
		end
		return _ENV
	end,

	update = function(_ENV)
		return _ENV
	end,

	draw = function(_ENV)
		dora_stack:draw()
		foreach(players, function(p)
			p:draw()
		end)
		color()
		?dora_stack.length
		?"game drawn"
		return _ENV
	end,
}


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