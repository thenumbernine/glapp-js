async function require(path) {
	let _module = window.module;
	window.module = {};
	await import(path);
	let exports = module.exports;
	window.module = _module;
	return exports;
}

/* some lua emscripten build ... * /

window.LuaModule = {
	print : s => { console.log(s); },
	printErr : s => { console.log(s); },
	stdin : () => {},
};
const m = await require('./lua.vm.js');
window.LuaModule = undefined;

const Lua = m.Lua;
const FS = m.FS;

console.log(Lua.theGlobal);

Lua.execute(`
print(js.global)
`);
/* */


/* wasmoon * /
await import('./wasmoon.min.js');	// defines the global 'wasmoon', returns nothing, and that isn't documented in any corner of all of the internet
const LuaFactory = wasmoon.LuaFactory;
const factory = new LuaFactory();
const lua = await factory.createEngine();

// https://github.com/hellpanderrr/lua-in-browser
async function mountFile(file_path, lua_path) {
    const fileContent = await fetch(file_path).then(data => data.text());
    await factory.mountFile(lua_path, fileContent);
}

await mountFile('./ffi.lua', 'ffi.lua');
await mountFile('./init-jslua-bridge.lua', 'init-jslua-bridge.lua');
await mountFile('/lua/bit/bit.lua', 'bit/bit.lua');

class Foo {};

lua.global.set('js', {
	global : window,
	// welp looks like wasmoon wraps only some builtin classes (ArrayBuffer) into lambdas to treat them all ONLY AS CTORS so i can't access properties of them, because retarded
	// so I cannot pass them through lua back to js for any kind of operations
	// so all JS operations now have to be abstracted into a new api
	// but we're still passing this back to JS ... wasmoon will probably require its own whole different ffi.lua implementation ... trashy.
	newArrayBuffer : (...args) => new ArrayBuffer(...args),
	newDataView : (...args) => new DataView(...args),
	newUint8Array : (...args) => new Uint8Array(...args),
	newFloat32Array : (...args) => new Float32Array(...args),
	newInt32Array : (...args) => new Int32Array(...args),
	newTextDecoder : (...args) => new TextDecoder(...args),
});
lua.doString(`
xpcall(function()	-- wasmoon has no error handling ... just says "ERROR:ERROR"
	package.path = table.concat({
		'./?.lua',
		'./?/?.lua',
	}, ';')
	dofile'init-jslua-bridge.lua'
end, function(err)
	print(err)
	print(debug.traceback())
end)
`);
//await lua.doFile(`init-jslua-bridge.lua`);
/* */


/* fengari */
const m = await require('./fengari-web.js');
fengari.load(`

js.newArrayBuffer = function(...) return js.new(js.global.ArrayBuffer, ...) end
js.newDataView = function(...) return js.new(js.global.DataView, ...) end
js.newUint8Array = function(...) return js.new(js.global.Uint8Array, ...) end
js.newFloat32Array = function(...) return js.new(js.global.Float32Array, ...) end
js.newInt32Array = function(...) return js.new(js.global.Int32Array, ...) end
js.newTextDecoder = function(...) return js.new(js.global.TextDecoder, ...) end

--print(package.path)	-- ./lua/5.3/?.lua;./lua/5.3/?/init.lua;./?.lua;./?/init.lua
package.path = table.concat({
	'./?.lua',
	'/lua/?.lua',
	'/lua/?/?.lua',
}, ';')

-- fengari doesn't have a fake-filesystem so ...
assert(not package.io)
local io = require 'io'
package.loaded.io = io
_G.io = io

dofile'init-jslua-bridge.lua'
`)();
/* */
