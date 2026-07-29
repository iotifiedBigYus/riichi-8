-- player


--TODO: fix class body


assert(empty_values)
assert(sum_values)
assert(entity)
assert(new_instance)
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
	--is_my_turn = false,

	new = function(self)
		return new_instance(self,{
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

	discard_selected_tile = function(_ENV)
		local removed_tile = hand:deli(selected_i)
		discard_pile:push(removed_tile)

		discard_values[removed_tile.value] += 1
		hand.selected_tile = nil
		selected_i = nil
		-- do not _ENV:update()
		return removed_tile
	end,

	apply_tile_states = function(_ENV)
		discard_pile:set_rotation(rotation)
		:set_pos(_ENV:get_rotated_pos(discard_pile_x,discard_pile_y))
		:apply_tile_states()
		meld_stack:set_rotation(rotation)
		:set_pos(_ENV:get_rotated_pos(meld_stack_x,meld_stack_y))
		:apply_tile_states()
		hand:set_rotation(rotation)
		:set_pos(_ENV:get_rotated_pos(hand_x,hand_y))
		:apply_tile_states()
		return _ENV
	end,

	draw = function(_ENV)
		discard_pile:draw()
		meld_stack:draw()
		hand:draw()
		return _ENV
	end,
}