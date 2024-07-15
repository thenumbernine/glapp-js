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
    const fileContent = await fetch(file_path).then(data => data.text())
    await factory.mountFile(lua_path, fileContent)
}

await mountFile('./ffi.lua', 'ffi.lua');
await mountFile('./run-fengari.lua', 'run-fengari.lua');
await lua.doFile(`run-fengari.lua`);
//await lua.doString(`dofile'run-fengari.lua'`);
//await lua.doString(`print'hi'`);
//await factory.mountFile('/lua/glapp/test/test_es.lua', 'glapp/test/test_es.lua');
//lua.doFile('./run-fengari.lua');
/* */

/* fengari * /
const m = await require('./fengari-web.js');
fengari.load(`dofile'run-fengari.lua'`)();
/* */
