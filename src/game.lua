-- game


--TODO: make positions global instead of relative to game xy


assert(entity)
assert(new_instance)
assert(wall)
assert(dora_stack)
assert(player)
assert(cpu)
assert(user)


game = entity:subclass{
	x = 63,
	y = 56,
	round = 1,
	hand = 1,
	repetition = 0,
	dora_x = -12,
	dora_y = 0,

	new = function(self)
		local _ENV = self:subclass()

		east = rnd(split"1,2,3,4")
		seat = east

		-- init walls
		dead_wall = wall:new()
		live_wall = wall:new()
		assert(live_wall.length == 0)
		live_wall:populate()
		assert(live_wall.length == 136)
		for _ = 1,14 do
			dead_wall:push(live_wall:pop())
		end
		assert(dead_wall.length == 14)
		assert(live_wall.length == 122)

		dora_stack = dora_stack:new():push(dead_wall:pop())
		uradora_stack = dora_stack:new():push(dead_wall:pop())

		assert(dora_stack.length == 1)
		assert(uradora_stack.length == 1)
		assert(dead_wall.length == 12)

		-- init players
		players = {
			global.user:new(),
			global.cpu:new(),
			global.cpu:new(),
			global.cpu:new()
		}

		for i,p in ipairs(players) do
			for _ = 1,13 do
				p.hand:add(live_wall:pop())
			end
			p.hand:set_tiles(p.hand.tiles)

			assert(p.hand.length == 13)
		end

		players[1].hand:set_size(2):set_status(1)

		-- starting player
		players[seat].is_my_turn = true
		players[seat].hand:add(live_wall:pop())
		assert(live_wall.length == 69)
		assert(#players == 4)

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
		assert(players)

		foreach(players, function(p) p:update_input() end)

		--next turn
		if not players[seat].is_my_turn then
			seat = fit_in(seat +1)
			players[seat].is_my_turn = true

			players[seat].hand:add(live_wall:pop())
		end

		return _ENV:apply_tile_states()
	end,

	draw = function(_ENV)
		camera(-63,-56)
		rectfill(-20,-20,20,20,0)
		rectfill(
			split"-12, 19,-12,-19"[seat],
			split" 19,-12,-19,-12"[seat],
			split" 12, 17, 12,-17"[seat],
			split" 17, 12,-17, 12"[seat],
			9
		)
		for i = -9,10,6 do
			spr(1,i,-3)
		end
		print(split"e,s,w,n"[round]..hand, -3,-11,7)
		print(live_wall.length, -3,7,7)

		camera(0,0)
		dora_stack:draw()

		foreach(players, function(p)
			p:draw()
		end)
		return _ENV
	end,
}


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
			game.seat == i and 10 or 0
		)
		dx,dy,w,h = dy,-dx,h,-w
	end

	camera(0,0)
end