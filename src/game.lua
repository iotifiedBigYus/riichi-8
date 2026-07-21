-- game


--TODO: clean up methods


assert(entity)
assert(wall)
assert(dora_stack)


game = entity:subclass{
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

		dora_stack = dora_stack:new()
		uradora_stack = dora_stack:new()
		dora_stack:add_tile(dead_wall:remove_latest_tile())
		uradora_stack:add_tile(dead_wall:remove_latest_tile())

		assert(dora_stack.length == 1)
		assert(uradora_stack.length == 1)
		assert(dead_wall.length == 12)

		-- init players
		players = {
		}

		init_game = function()
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


		return _ENV
	end,

	get_starting_hand = function(player, i_player)
		assert(wall)
		for _ = 1,13 do
			local t = get_tile()
			player.hand.tiles[t] += 1
		end
	
		if i_player == 1 then
			for t,n in ipairs(player.hand.tiles) do
				for _ = 1,n do
					add(player.tile_objs, new_tile_object(t))
				end
			end
		end
	end,

	update = function(_ENV)
		return _ENV
	end,

	draw = function(_ENV)
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