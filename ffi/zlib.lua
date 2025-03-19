local js = require 'js'
return {
	compressLua = function(s)
		return ffi.stringBuffer(
			js.global.pako:deflate(
				ffi.dataToArray(
					'Uint8Array',
					ffi.cast('void*', s)
				)
			)
		)
	end,
	uncompressLua = function(s)
		return ffi.stringBuffer(
			js.global.pako:inflate(
				ffi.dataToArray(
					'Uint8Array',
					ffi.cast('void*', s)
				)
			)
		)
	end,
}
