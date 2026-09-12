assert(collection)

local cn = function() return collection:new() end

c = cn():add_value(1,3)
assert(c.values[1] == 3)

c = cn():add_sequence(1)
?c:tostr()
assert(c.values[1] == 1)
assert(c.values[2] == 1)
assert(c.values[3] == 1)

-- triple / quad
c = cn():add_value(3,2)
assert(#c:check_tuple(1,3) == 0)
assert(#c:check_tuple(3,3) == 1)
assert(#c:check_tuple(3,4) == 0)
c:add_value(3,1)
assert(#c:check_tuple(3,4) == 1)

-- sequence
c = cn():add_sequence(4):add_sequence(7):add_sequence(10)
assert(#c:check_sequence(4) == 1)
assert(#c:check_sequence(5) == 2)
assert(#c:check_sequence(6) == 3)
assert(#c:check_sequence(7) == 3)
assert(#c:check_sequence(8) == 2)
assert(#c:check_sequence(9) == 1)
assert(#c:check_sequence(10) == 1)