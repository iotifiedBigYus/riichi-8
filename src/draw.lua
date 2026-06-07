function draw_game()
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

	print(game.turn)
end