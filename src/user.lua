-- the player the user controls

function init_user()
	user = test_user()
end


function test_user()
	local user = new_player()
	user.hand = test_user_hand()
	return user
end


function test_user_hand()
	local dt = {tile = 35, x = 0x71, y = 114}
	return {
		tiles = {1,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1},

		is_closed = false,
		drawn_tile = 14,
		i_selected_obj = 14,
		selected_obj = dt,

		tile_objs = {
			{tile = 1, x = 0x07, y = 116},
			{tile = 9, x = 0x0F, y = 116},
			{tile = 10, x = 0x17, y = 116},
			{tile = 18, x = 0x1F, y = 116},
			{tile = 19, x = 0x27, y = 116},
			{tile = 27, x = 0x2F, y = 116},
			{tile = 28, x = 0x37, y = 116},
			{tile = 29, x = 0x3F, y = 116},
			{tile = 30, x = 0x47, y = 116},
			{tile = 31, x = 0x4F, y = 116},
			{tile = 32, x = 0x57, y = 116},
			{tile = 33, x = 0x5F, y = 116},
			{tile = 34, x = 0x67, y = 116},
			dt
		},

		meld_objs = {
			--{tiles = {-1,2,3}},
			--{tiles = {-2,1,3}},
			--{tiles = {-3,1,2}},
			--{tiles = {-5,5,35}},
			--{tiles = {5,-5,5}},
			--{tiles = {5,5,-5}},
			--{tiles = {-14,14,14,14}},
			--{tiles = {14,-14,14,14}},
			--{tiles = {14,14,14,-14}},
			--{tiles = {0,14,14}},
			--{tiles = {14,0,14}},
			--{tiles = {14,14,0}},
			--{tiles = {0,14,14,0}}
		}
	}
end


function update_user()
	assert(user)


	if btnp(🅾️) then
		discard_tile(user, user.hand.selected_obj.tile)
	end


	update_user_hand(user.hand)
end


function update_user_hand(hand)
	assert(hand)


	--⬆️, ⬇️, ⬅️, ➡️, 
	if btnp(⬅️) then
		switch_selected_tile(hand, (hand.i_selected_obj-2)%#hand.tile_objs+1)
	elseif btnp(➡️) then
		switch_selected_tile(hand, (hand.i_selected_obj  )%#hand.tile_objs+1)
	end

	local ox = 63 - #hand.tile_objs*4
	for i,to in ipairs(hand.tile_objs) do
		to.x = ox + (i-1)*8
	end
end


function switch_selected_tile(hand, i)
	if(hand.selected_obj) hand.selected_obj.y = Y_P1_HAND
	hand.i_selected_obj = i
	hand.selected_obj = hand.tile_objs[i]
	hand.selected_obj.y = Y_P1_HAND - 2
end


function draw_user()
	assert(user)
	draw_user_hand(user.hand)
end


function draw_user_hand(hand)
	assert(hand)
	draw_user_tiles(hand.tile_objs)
	draw_melds(hand.meld_objs,1)
end


function draw_user_tiles(tile_objs)
	for to in all(tile_objs) do
		draw_large_tile(to.tile, to.x, to.y)
	end
end