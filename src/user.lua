-- user, a player the user controls


assert(player)
assert(entity)


user = player:subclass{
	is_user = true,
	hand_y = 60,
	--selected_i = nil,

	update_input = function(_ENV)
		-- discarding
		if btnp(❎) and is_my_turn and selected_i then
			local removed_tile = _ENV:discard_selected_tile()
		end

		-- moving
		local di = 0
		if btnp(➡️) then
			di += 1
		end
		if btnp(⬅️) then
			di -= 1
		end

		if selected_i then
			selected_i = mid(1, selected_i+di, hand.length)
		elseif di < 0 then
			selected_i = 1
		elseif di > 0 or hand.pulled_tile then
			selected_i = hand.length
		end
		hand:set_selected_tile_i(selected_i)

		return _ENV
	end,
}