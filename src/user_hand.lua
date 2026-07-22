-- user hand


-- TODO: remove size from normal hand and make tiles selectable


large_hand = hand:subclass{
	new = function(self)
		return entity.new(self, {
			tiles = {},
			previous_tiles = {},
			--tile_states = {},
			--[[
				state: desired {x, y, rotation, status}
				for each tile in tiles
			]]
		})
	end,

}
