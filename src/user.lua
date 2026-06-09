-- the player the user controls

function new_user()
	local user = new_player()

	user.is_user = true
	user.tile_objs = {}
	user.i_selected_tile_obj = nil
	user.pick_up_tile_obj = new_tile_object(8)
	user.selected_obj = nil

	return user
end

function init_user()
	user = new_user()
end


function test_user_hand()
	local dt = {tile = 35, x = 0x71, y = 114}
	return {
		tiles = {1,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0},

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
		if user.selected_obj and user.selected_obj.is_tile then
			discard_selected_tile()
		end
	end

	--⬆️, ⬇️, ⬅️, ➡️, 
	if btnp(⬅️) and not btn(➡️) then
		switch_selected_horz(-1)
	elseif btnp(➡️) and not btn(⬅️) then
		switch_selected_horz(1)
	end

	update_user_tile_objects()
end


function update_user_tile_objects()
	assert(user)

	local ox = 63 - #user.tile_objs*4
	for i,to in ipairs(user.tile_objs) do
		local x = to == user.pick_up_tile_obj and ox + (i-1)*8+2 or ox + (i-1)*8
		set_tile_object_position(to, x)
	end
end


function set_tile_object_position(tile_obj, x, y)
	assert(tile_obj)
	tile_obj.x = x
	tile_obj.y = tile_obj.is_selected and Y_P1_SELECTED_TILE or Y_P1_TILE
end


function switch_selected_horz(dx)
	if not user.selected_obj then
		select_tile_object(dx < 0 and #user.tile_objs or 1)
	elseif user.selected_obj.is_tile then
		deselect_object()
		select_tile_object((user.i_selected_tile_obj-1+dx)%#user.tile_objs+1)
	end
end


function select_object(obj)
	assert(user)
	assert(obj)
	user.selected_obj = obj
	obj.is_selected = true
end


function select_tile_object(i_tile_obj)
	assert(user)
	assert(i_tile_obj)
	select_object(user.tile_objs[i_tile_obj])
	user.i_selected_tile_obj = i_tile_obj
end


function deselect_object()
	user.selected_obj.is_selected = false
	user.selected_obj = nil
end


function discard_selected_tile()
	assert(user)

	discard_tile(user, user.selected_obj.tile)
	user.pick_up_tile_obj = nil

	del(user.tile_objs, user.selected_obj)
	user.selected_obj = nil

	sort_tile_objects()
end


function sort_tile_objects()
	assert(user)

	local objs = user.tile_objs

	foreach(objs, function(to)
		to.prev_x = to.x
	end)
	
	for i = 1,#objs do
		local j = i
		while j > 1 and objs[j-1].tile > objs[j].tile do
			objs[j],objs[j-1] = objs[j-1],objs[j]
			j = j - 1
		end
	end
end


function draw_user()
	assert(user)
	draw_user_tile_objects(user.tile_objs)
	draw_melds(user.meld_objs,1)
end


function draw_user_tile_objects(tile_objs)
	assert(tile_objs)
	for to in all(tile_objs) do
		draw_large_tile(to.tile, to.x, to.y)
	end
end
