-- player


--TODO: fix class body


assert(empty_values)
assert(sum_values)
assert(class)
assert(hand)
assert(discard_pile)
assert(meld_stack)


player = entity:subclass{
	score = 25000,
	hand_x = 0,
	hand_y = 54,
	meld_stack_x = 48,
	meld_stack_y = 52,
	discard_pile_x = -18,
	discard_pile_y = 20,
	--in_tenpai = false,
	--in_riichi = false,
	--drawn_tile = nil,

	new = function(self)
		return entity.new(self,{
			hand = global.hand:new(),
			meld_stack = global.meld_stack:new(),
			discard_pile = global.discard_pile:new(),
			discard_values = empty_values(),
		})
	end,

	add_points = function(_ENV, points)
		score += points
		return _ENV
	end,

	apply_tile_states = function(_ENV)
		discard_pile:apply_tile_states()
		meld_stack:apply_tile_states()
		hand:apply_tile_states()
		return _ENV
	end,

	update = function(_ENV)
		discard_pile:set_rotation(rotation)
		:set_pos(_ENV:get_rotated_pos(discard_pile_x,discard_pile_y))
		meld_stack:set_rotation(rotation)
		:set_pos(_ENV:get_rotated_pos(meld_stack_x,meld_stack_y))
		hand:set_rotation(rotation)
		:set_pos(_ENV:get_rotated_pos(hand_x,hand_y))
		return _ENV
	end,

	draw = function(_ENV)
		discard_pile:draw()
		meld_stack:draw()
		hand:draw()
		return _ENV
	end,
}

function discard_tile(player, tile)
	assert(player)
	assert(tile)

	add(player.discard_pile.tiles, tile)

	player.hand.tiles[tile] -= 1
	assert(player.hand.tiles[tile] >= 0)
end


function update_player_tile_object_positions()
	assert(player)
	assert(user)
	if player == user then
		update_user_tile_object_positions()
	end
end


function print_player_hand(hand, i_player)
	assert(hand)
	assert(i_player)
	local x,y
	if i_player == 1 then
		x,y = 40, 100
	elseif i_player == 2 then
		x,y = 50, 80
	elseif i_player == 3 then
		x,y = 40, 5
	elseif i_player == 4 then
		x,y = 0,30
	end
	print(encode_tiles(hand.tiles,true),x,y,7)
end