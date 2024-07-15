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

/* wasmoon */
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

lua.global.set('js', {
	global : window,
	['log'] : (...args) => { console.log(...args); },
	['new'] : (cl, ...args) => {
		//console.log(window.ArrayBuffer);	// ArrayBuffer
		//console.log('cl', cl);	// ArrayBuffer wrapped in wasmoon trash
		//console.log('cl', cl());	// error requires 'new' ... so it is passing me a js function that can be used as the class constructor ... why not just pass the class?!?!?!
		//return cl(...args);		// "Error: TypeError: Constructor ArrayBuffer requires 'new'"
		return new cl(...args);		// "TypeError: cl is not a constructor"
	},
});
lua.doString(`
xpcall(function()	-- wasmoon has no error handling ... just says "ERROR:ERROR"
	js.log('js', js)
	js.log('global', js.global)
	js.log('ArrayBuffer', js.global.ArrayBuffer)
	print(js.new(js.global.ArrayBuffer, 10, 20))
end, function(err)
	print(err)
	print(debug.traceback())
end)
`);
//await lua.doFile(`init-jslua-bridge.lua`);
/* */


/* fengari * /
const m = await require('./fengari-web.js');
fengari.load(`

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
