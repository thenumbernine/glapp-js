-- fengari launcher
-- Lua 5.3
xpcall(function()
	--print(package.path)	-- ./lua/5.3/?.lua;./lua/5.3/?/init.lua;./?.lua;./?/init.lua
	package.path = './?.lua;./?/?.lua'

	-- fengari doesn't have a fake-filesystem so ...
	-- [[ require 'io'
	assert(not package.io)
	local io = require 'io'
	package.loaded.io = io
	_G.io = io
	--]]

	-- add DEBUG lines
	-- needs io to exist first ...
	--require 'ext.debug'

	-- TODO while we're here, connect gles3 calls to webgl

--[=[
	local ffi = require 'ffi'
	ffi.cdef[[
struct A {
	int a[1];
	int b[1];
};
]]
	local c = ffi.new'struct A';
	print('ffi.null', ffi.null)
	print('c', c)
	print('ffi.typeof(c)', ffi.typeof(c))
	print('ffi.typeof(c.a)', ffi.typeof(c.a))	-- should be: ctype<int (&)[1]>
	assert(type(c) == 'cdata')
	assert(type(c.b) == 'cdata')
	assert(ffi.sizeof(c) == 8)
	assert(ffi.sizeof(c.b) == 4)
	c.b[0] = 1				-- TODO this should be an error: cannot convert 'number' to 'int [1]'
	print('c.b', c.b)		-- should be: cdata<int (&)[1]>: 0x7485879aea1c
	print('c.b[0]', c.b[0])
	assert(c.b[0] == 1)
	local v = ffi.cast('int', 2)
	c.b[0] = v
	print('c.b[0]', c.b[0])
	assert(c.b[0] == 2)
--]=]
--[=[
	local ffi = require 'ffi'
	print'mem: null'
	if ffi.memdump then print('mem', ffi.memdump()) end
	local s = 'testing'

	local l = ffi.new'int[1]'
	print'mem: null, int[1] l'
	if ffi.memdump then print('mem', ffi.memdump()) end
	print('l', l)
	print('l[0]', l[0])
	l[0] = #s
	print('l[0]', l[0])
	print('mem: null, int[1] l='..#s)
	if ffi.memdump then print('mem', ffi.memdump()) end

	local p = ffi.new'const char*[1]'	-- luajit requires const char*, not char*
	print('mem: null, int[1] l='..#s..' char*[1] p')
	if ffi.memdump then print('mem', ffi.memdump()) end
	print('p', p)
	print('p[0]', p[0])
	p[0] = s
	print('mem: null, int[1] l='..#s..' char*[1] p=0xc char[8] s='..s)
	if ffi.memdump then print('mem', ffi.memdump()) end

	print('p[0]', p[0])	-- pointer has changed
	print("ffi.cast('intptr_t', p[0])", ffi.cast('intptr_t', p[0]))
	if ffi.memdump then print('mem', ffi.memdump()) end
	print('p[0]', p[0])
	--print('memGetPtr(p[0])', ffi.memGetPtr(p[0]))
	--print('memGetPtr(20)', ffi.memGetPtr(20))
	print('ffi.string(p[0])', ffi.string(p[0]))
--]=]
-- [=[
	local ffi = require 'ffi'
	if ffi.memdump then print('mem', ffi.memdump()) end
	local v = ffi.new'void*'
	print('v', v)
	if ffi.memdump then print('mem', ffi.memdump()) end
--]=]
--[=[
	local ffi = require 'ffi'
	local i = ffi.new('int32_t', 42)
	print(i)
	print(tonumber(i))

	local a = ffi.new('char[20]')
	local p = ffi.cast('char*', a)
	print('p', p)
	print(ffi.cast('intptr_t', p))	-- should assign the pointer to the new intptr_t
	print(ffi.cast('intptr_t', a))	-- same
--]=]
--[=[
	--assert(assert(loadfile'glapp/tests/info.lua')())
	dofile'glapp/tests/test_es.lua'
--]=]
	print'done'
end, function(err)
	print(tostring(err)..'\n'..debug.traceback())
end)
