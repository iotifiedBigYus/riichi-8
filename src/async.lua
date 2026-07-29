-- routines


assert(class)


async = class:subclass{
	new = function(self)
		return self:subclass({
			routines = {},
		})
	end,

	create = function(_ENV, func)
		add(routines, cocreate(func))
	end,

	create_many = function(_ENV, funcs)
		foreach(funcs, function(f)
			add(routines, cocreate(f))
		end)
	end,

	kill = function(_ENV)
		routines = {}
	end,

	resume = function(_ENV, func)
		foreach(routines, coresume)
	end,

	set_later = function(_ENV, obj, key, value, frames)
		add(routines, cocreate(function()
			for _ = 1,frames do
				yield()
			end
			obj[key] = value
		end))
	end,
}