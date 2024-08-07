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
		local found, result = xpcall(function()
			return require('ffi.'..search)
		end, function(err)
			return err..'\n'..debug.traceback()
		end)
		if found then
--DEBUG(ffi.req):print('ffi.req', req, search)
			return result
		end
		table.insert(errs, result)
	end
	error(table.concat(errs, '\n'))
end
