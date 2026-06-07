-- the players the computer controls

function init_cpus()
	cpu1 = test_cpu()
	cpu2 = test_cpu()
	cpu3 = test_cpu()
end


function test_cpu()
	return new_player()
end


function test_cpu_hand()
	return {
		tiles = {1,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1},
		drawn_tile = 1,
		discarded_tiles = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		discard_pile = {
			riichi = 0,
			tiles = {}
		}
	}
end