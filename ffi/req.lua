-- copy of the original, though the rest of the ffi/ folder has changed
local ffi = require 'ffi'
return function(req)
	assert(type(req) == 'string', 'expected string')
	-- first search $os/$arch/$req
	-- then search $os/$req
	-- (then search $arch/$req?)
	-- then search $req
	local errs = {}
	for _,search in ipairs{
		ffi.os..'.'..ffi.arch..'.'..req,
		ffi.os..'.'..req,
		ffi.arch..'.'..req,
		req,
	} do
		local found, result = pcall(require, 'ffi.'..search)
		if found then return result end
		table.insert(errs, result)
	end
	error(table.concat(errs, '\n'))
end
