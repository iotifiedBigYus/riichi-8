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


function perform_cpu_turn(cpu)
	assert(cpu)

	for i = 1,37 do
		if cpu.hand.tiles[i] > 0 then
			discard_tile(cpu, i)
			break
		end
	end

	end_turn()
end