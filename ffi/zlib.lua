return {
	compressLua = function(s)
		return ffi.stringBuffer(
			js.pako:deflate(
				ffi.dataToArray(
					'Uint8Array',
					ffi.cast('void*', s)
				)
			)
		)
	end,
	uncompressLua = function(s)
		return ffi.stringBuffer(
			js.pako:inflate(
				ffi.dataToArray(
					'Uint8Array',
					ffi.cast('void*', s)
				)
			)
		)
	end,
}
