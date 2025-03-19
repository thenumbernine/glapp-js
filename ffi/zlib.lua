local js = require 'js'
local window = js.global
return {
	compressLua = function(s)
		return ffi.stringBuffer(
			js.global.pako:deflate(
				window:dataToArray(
					'Uint8Array',
					ffi.cast('void*', s)
				)
			)
		)
	end,
	uncompressLua = function(s)
		return ffi.stringBuffer(
			js.global.pako:inflate(
				window:dataToArray(
					'Uint8Array',
					ffi.cast('void*', s)
				)
			)
		)
	end,
}
