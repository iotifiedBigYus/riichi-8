-- util


util = {}


function empty_tiles()
	local n_tiles = {}
	for _ = 1,37 do add(n_tiles,0) end
	return n_tiles
end