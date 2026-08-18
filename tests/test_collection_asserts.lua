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

-- triple with red fives
c = cn():add_value(5,2):add_value(35,0)
assert(#c:check_tuple(5,3) == 1)
assert(#c:check_tuple(35,3) == 1)
c = cn():add_value(5,1):add_value(35,1)
assert(#c:check_tuple(5,3) == 1)
assert(#c:check_tuple(35,3) == 1)

-- triple with red fives
c = cn():add_value(5,2):add_value(35,0)
assert(#c:check_tuple(5,3) == 1)
assert(#c:check_tuple(35,3) == 1)
c = cn():add_value(5,1):add_value(35,1)
assert(#c:check_tuple(5,3) == 1)
assert(#c:check_tuple(35,3) == 1)


-- triple with red fives, multiple choices
c = cn():add_value(5,3):add_value(35,0) -- nnn
assert(#c:check_tuple(5,3) == 1) -- nnn
assert( c:check_tuple(5,3)[1].values[5] == 3) -- nnn
assert(#c:check_tuple(35,3) == 1) -- nnr
assert( c:check_tuple(35,3)[1].values[5] == 2) -- nn
assert( c:check_tuple(35,3)[1].values[35] == 1) -- r
c = cn():add_value(5,2):add_value(35,1) -- nnr
assert(#c:check_tuple(5,3) == 2) -- nnn, nnr
assert(c:check_tuple(5,3)[1].values[5] == 3) -- nnn

-- quad with red fives
c = cn():add_value(5,3):add_value(35,0) -- nnn
assert(#c:check_tuple(5,4) == 1) -- nnnn
assert(#c:check_tuple(35,4) == 1) -- nnnr
c = cn():add_value(5,2):add_value(35,1) -- nnr
assert(#c:check_tuple(5,4) == 1) -- nnnr
assert(#c:check_tuple(35,4) == 1) -- nnrr

-- quad with red fives, multiple choices
c = cn():add_value(5,4):add_value(35,0) -- nnnn
assert(#c:check_tuple(5,4) == 1) -- nnnn
assert(#c:check_tuple(35,4) == 1) -- nnnr
c = cn():add_value(5,3):add_value(35,1) -- nnnr
assert(#c:check_tuple(5,4) == 2) -- nnnn, nnnr
assert(#c:check_tuple(35,4) == 2) -- nnnr, nnrr
