

function new_game()
	assert(user)
	assert(cpu1)
	assert(cpu2)
	assert(cpu3)

	return {
		turn = 1,
		n_tiles = {},
		i_tiles = {},
		players = {user, cpu1, cpu2, cpu3}
	}
end


function init_game()
	init_wall()
	init_dora()
	init_cpus()
	init_user()

	game = new_game()
end


function next_turn()
	assert(game)
	game.turn = game.turn%4+1
end


function draw_game()
	draw_turn_indicator()
	draw_dora()
	for i,p in ipairs(game.players) do
		draw_discard_pile(p.discard_pile,i)
	end
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