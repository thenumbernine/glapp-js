--[[
TODO just maybe implement a full emulated filesystem ...
--]]
local io = {}

local filemt = {}
setmetatable(filemt, {
	-- filemt ctor:
	__call = function(mt, filename, mode, buffer)
		local o = setmetatable({}, mt)
		o.filename = filename
		o.mode = mode
		o.ofs = 0
		-- TODO only for buffered files (as opposed to pipes/processes)
		o.buffer = assert(buffer)
		return o
	end,
})
filemt.__index = filemt

function filemt:close()
	self.closed = true
end

function filemt:flush()
	error('TODO file.flush()')
end

function filemt:lines(...)
	error('TODO file.lines()')
end

function filemt:read(amount)
	if self.closed then return nil, "closed" end
	if type(amount) == 'number' then
		local result = self.buffer:sub(self.ofs+1, self.ofs+amount)
		self.ofs = self.ofs + self.amount
		return result
	-- TODO backwards compat for *a etc?
	elseif amount == 'n' then
	elseif amount == 'a' or amount == '*a' then
		local result = self.buffer:sub(self.ofs+1, #self.buffer)
		self.ofs = #self.buffer
		return result
	elseif amount == 'l' or amount == '*l' then
	elseif amount == 'L' then
	end
	
	return nil, 'TODO file.read()'
end

function filemt:seek(whence, offset)
	whence = whence or 'cur'
	offset = offset or 0
	local prevofs = self.ofs
	if whence == 'set' then
		self.ofs = offset
	elseif whence == 'cur' then
		self.ofs = self.ofs + offset
	elseif whence == 'end' then
		self.ofs = #self.buffer + offset
	end
	return prevofs
end

function filemt:setvbuf(mode, size)
	error('TODO file.setvbuf()')
end

function filemt:write(...)
	error('TODO file.write()')
end

function io.close(fh)
	return (fh or io.stdout):close()
end

function io.type(obj)
	if getmetatable(obj) == filemt then
		if obj.closed then return 'closed file' end
		return 'file'
	end
	return nil
end

function io.input(...)
	if select('#', ...) == 0 then
		return io.stdin
	end
	local f = ...
	if type(f) == 'string' then
		io.stdin = assert(io.open(f, 'r'))
	elseif not io.type(f) then
		error("expected a string or a file handle")
	end
	io.stdin = f
end

function io.open(filename, mode)
	assert(type(filename) == 'string')
	assert(type(mode) == 'string' or type(mode) == 'nil')
	-- TODO try to open, return false + reason if you can't
	return false, 'TODO io.open('..tostring(filename)..', '..tostring(mode)..')'
	-- only return filemt upon success
	--return filemt(filename, mode or 'r', filebuffer)
end

function io.output(...)
	if select('#', ...) == 0 then
		return io.stdout
	end
	local f = ...
	if type(f) == 'string' then
		f = assert(io.open(f, 'w'))
	elseif not io.type(f) then
		error("expected a string or a file handle")
	end
	io.stdout = f
end

function io.popen(program, mode)
	-- special hack for uname ...
	-- popen always returns a handle
	-- in the case of an exe missing, it'll stdout/err "not found", just like running sh would
	print("sh: 1: "..program..": not found")
	return filemt('popen '..program, mode, '')
end

function io.flush(...)
	return io.output():flush(...)
end

function io.lines(...)
	return io.stdin:lines(...)
end

function io.read(...)
	return io.input():read(...)
end

function io.write(...)
	return io.output():write(...)
end

function io.tmpfile()
	error('TODO io.tmpfile()')
end

--[[
-- really trashy way to insert io.write into print
local oldprint = print

io.stdout = {}
io.stdout.linebuf = ''
function io.stdout:write(...)
	local l = io.stdout.linebuf
	for i=1,select('#', ...) do
		l = l .. tostring((select(i, ...)))
	end
	
	repeat
		local i = l:find'\n'
		if not i then break end
		oldprint(l:sub(1, i-1))
		l = l:sub(i+1)
	until false

	io.stdout.linebuf = l
end
io.stderr = io.stdout

function print(...)
	if io.stdout.linebuf ~= '' then
		print(io.stdout.linebuf)
		io.stdout.linebuf = ''
	end
	oldprint(...)
end

print'hi'
io.write'hi'
print()
assert(io.stdout)
--]]
-- [[ until then
io.stderr = {}
function io.stderr:write() end
function io.stderr:flush() end
--]]

return io
