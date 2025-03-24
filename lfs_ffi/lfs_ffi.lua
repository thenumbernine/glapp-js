local M = {}

-- https://emscripten.org/docs/api_reference/Filesystem-API.html

-- hmm another way to communicate lua<->js other than through window ?
local FS = require 'js'.global.FS

function M.setmode(path, mode)
	FS:chmod(path, mode)
end

function M.link(old, new, sym)
	if sym then
		FS:symlink(old, new)
	else
		error('not supported?')
	end
end

function M.dir(path)
	return coroutine.wrap(function()
		--[[ TODO get iterators working with wrappers
		for _,dir in ipairs(FS:readdir(path)) do
		--]]
		-- [[ until then
		local dir = FS:readdir(path)
		for i=0,#dir-1 do
			local f = dir[i]
		--]]
			-- good of emscripten readdir() to provide . and .. for lfs compat
			coroutine.yield(f)
		end
	end)
end

function M.currentdir() return FS:cwd() end
function M.chdir(path) FS:chdir(path) end	-- what happens upon fail?
function M.mkdir(path, mode) FS:mkdir(path, mode) end
function M.rmdir(path) FS:rmdir(path) end

local has_table_new, new_tab = pcall(require, "table.new")
if not has_table_new or type(new_tab) ~= "function" then
	new_tab = function() return {} end
end

local STAT = {
	FMT   = 0xF000,
	FSOCK = 0xC000,
	FLNK  = 0xA000,
	FREG  = 0x8000,
	FBLK  = 0x6000,
	FDIR  = 0x4000,
	FCHR  = 0x2000,
	FIFO  = 0x1000,
}

local ftypeNameMap = {
	[STAT.FREG]  = 'file',
	[STAT.FDIR]  = 'directory',
	[STAT.FLNK]  = 'link',
	[STAT.FSOCK] = 'socket',
	[STAT.FCHR]  = 'char device',
	[STAT.FBLK]  = "block device",
	[STAT.FIFO]  = "named pipe",
}

local function modeToFType(mode)
	local ftype = mode & STAT.FMT
	return ftypeNameMap[ftype] or 'other'
end

local function modeToPerms(mode)
	local permbits = mode & 511	-- tonumber('777', 8)
	local perm = new_tab(9, 0)
	local i = 9
	while i > 0 do
		local perm_bit = permbits & 7
		perm[i] = (perm_bit & 1) > 0 and 'x' or '-'
		perm[i-1] = (perm_bit & 2) > 0 and 'w' or '-'
		perm[i-2] = (perm_bit & 4) > 0 and 'r' or '-'
		i = i - 3
		permbits = permbits >> 3
	end
	return table.concat(perm)
end

local function getattr(src)
	return {
		blksize = src.blksize,
		blocks = src.blocks,
		dev = src.dev,
		gid = src.gid,
		ino = src.ino,
		mode = modeToFType(src.mode),
		nlink = src.nlink,
		permissions = modeToPerms(src.mode),
		rdev = src.rdev,
		size = src.size,
		uid = src.uid,
	}
end

function M.attributes(path, attr)
	local attr, err, code
	xpcall(function()
		attr = getattr(FS:stat(path))
	end, function(e)
		-- ErrnoError?
		err = tostring(e.name)
		code = e.errno
	end)
	if not err then return attr end
	return attr, err, code
end
function M.symlinkattributes(path, attr)
	local attr, err, code
	xpcall(function()
		attr = getattr(FS:lstat(path))
	end, function(e)
		-- ErrnoError?
		err = tostring(e.name)
		code = e.errno
	end)
	if not err then return attr end
	return attr, err, code
end

function M.touch(path, actime, modtime) end
function M.lock(fh, mode, start, len) end
function M.lock_dir(path) end
function M.unlock(fh, start, len) end

return M
