-- large tile


assert(tile)


function get_large_tile_face_sprites_vert()
	local sprites = {}

	for value = 1,37 do
		local spr_numbers_vert = 0x61
		local spr_honors_vert = 0x40-28
		local spr_fives_vert = 0x60

		if value <= 27 then
			-- number tiles
			add(sprites, spr_numbers_vert+(value-1)%9)
		elseif value <= 34 then
			-- honors
			add(sprites, spr_honors_vert+value)
		else
			-- "red" fives
			add(sprites, spr_fives_vert)
		end
	end
	
	return sprites
end


large_tile = tile:subclass{
	ws = split"8,8,8,8",
	hs = split"12,12,12,12",
	w = 8,
	h = 12,
	spr_y = 7,
	spr_h = 1.875,
	face_sprites_vert = get_large_tile_face_sprites_vert(), --TODO: replace with split table
}