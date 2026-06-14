

function new_game()
	assert(user)
	assert(cpu1)
	assert(cpu2)
	assert(cpu3)
	user.name = "user"
	cpu1.name = "cpu1"
	cpu2.name = "cpu2"
	cpu3.name = "cpu3"

	local east = rnd{1,2,3,4}

	return {
		turn = east,
		east = east,
		n_tiles = {},
		i_tiles = {},
		players = {user, cpu1, cpu2, cpu3}
	}
end


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