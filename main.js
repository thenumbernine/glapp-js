// stop emscripten from doing its shit
const eventListeners = new Map();	// eventListeners.get(dom)[eventType] = [ [addEventListenr's call args], ...];

// This is just gonna override for window,
// but the underlying code is extensible to all DOM types,
// You would only need to insert the function into each one's prototype.
// Until then, only `eventListeners.get(window)` will be present.
const oldWindowAddEventListener = window.addEventListener;
window.addEventListener = function(eventType, ...args) {
	let listenersForThis = eventListeners.get(this);
	if (!listenersForThis) {
		listenersForThis = {};
		eventListeners.set(this, listenersForThis);
	}
	listenersForThis[eventType] ??= [];
	const listenersForType = listenersForThis[eventType];
	listenersForType.push(Array.prototype.slice.call(args));	// pushes [func, opts, ...]
	oldWindowAddEventListener.call(this, eventType, ...args);
};

const arrayseq = (a,b) => {
	if (a.length !== b.length) return false;
	for (let i = 0; i < a.length; ++i) {
		if (a[i] !== b[i]) return false;
	}
	return true;
};

const oldWindowRemoveEventListener = window.removeEventListener;
window.removeEventListener = function(eventType, ...args) {
	oldWindowRemoveEventListener.call(this, eventType, ...args);

	// if we find a matching entry then erase it
	const listenersForThis = eventListeners.get(window);
	if (!listenersForThis) return;

	const listenersForType = listenersForThis[eventType];
	if (!listenersForType) return;

	// remove any that match
	for (let i = listenersForType.length-1; i >= 0; --i) {
		const listener = listenersForType[i];
		if (arrayseq(listener, args)) {
			listenersForType.splice(i, 1);
		}
	}

	// remove the field if all are gone
	if (!listenersForType.length) {
		delete listenersForThis[eventType];
	}
};

// only works on window , sicne window is the only thing I've installed the above traps on.
const removeAllElemEventListeners = (elem, eventTypes) => {
	const listenersForThis = eventListeners.get(elem);
	if (!listenersForThis) return;
	eventTypes.forEach(eventType => {
		const listenersForType = listenersForThis[eventType];
		if (listenersForType) {
			// test in reverse-order so if we remove in reverse-order we don't invalidate this iterator
			for (let i = listenersForType.length-1; i >= 0; --i) {
				const listener = listenersForType[i];
				elem.removeEventListener(eventType, ...listener);
			}
			delete listenersForThis[eventType];
		}
	});
};


import {addPackage} from '/js/util.js';
import {newLua} from '/js/lua-interop.js';
import {luaPackages} from '/js/lua-packages.js';
import {A, Br, Button, Canvas, Div, Img, Input, Option, Select, Span, TextArea} from '/js/dom.js';

const urlparams = new URLSearchParams(location.search);

let rundir = urlparams.get('dir');
let runfile = urlparams.get('file');

let runargs = urlparams.get('args') || '';	//store it in JSON

let editmode = !!urlparams.get('edit');
if (!runfile || !rundir) {
	rundir = 'glapp/tests';
	runfile = 'test_tex.lua';
	editmode = true;
}
if (rundir) {
	if (rundir.substr(0, 1) != '/') rundir = '/' + rundir;
	if (rundir.substr(-1) == '/') rundir = rundir.substr(0, rundir.length-1);
}

/* progress so far
rundir='glapp/tests'; runfile='test_es.lua';				-- WORKS README
rundir='glapp/tests'; runfile='test_es_directcalls.lua';	-- WORKS README
rundir='glapp/tests'; runfile='test_tex.lua';				-- WORKS README
rundir='glapp/tests'; runfile='test.lua';					-- fails, glmatrixmode
rundir='glapp/tests'; runfile='minimal.lua';
rundir='glapp/tests'; runfile='pointtest.lua';
rundir='glapp/tests'; runfile='info.lua';
rundir='line-integral-convolution'; runfile='run.lua';		-- WORKS README
rundir='rule110'; runfile='rule110.lua';					-- WORKS README ... but mouse click is so-so
rundir='fibonacci-modulo'; runfile='run.lua';				-- WORKS README ... but imgui is buggy
rundir='n-points'; runfile='run.lua';						-- WORKS README ... but mouse click is so-so
rundir='n-points'; runfile='run_orbit.lua';					-- todo esp. glPointSize ... or not, it's kinda dumb i guess
rundir='geographic-charts'; runfile='test.lua';				-- starts up, but gets some gl error
rundir='prime-spiral'; runfile='run.lua';					-- used to work ... now ffi/cpp/vector-lua.lua
rundir='lambda-cdm'; runfile='run.lua';						-- WORKS README
rundir='seashell'; runfile='run.lua';						-- WORKS README ... I had to scale down the mesh from 2000x2000 to 200x200 or it ran too slow to finish ... TODO needs menubar support
rundir='SphericalHarmonicGraphs'; runfile='run.lua';		-- very slow (didn't finish)
rundir='metric'; runfile='run.lua';							-- fails, uses GL_TEXTURE_1D
rundir='sand-attack'; runfile='run.lua';					-- freezes, needs imgui ImFontAtlas_GetTexDataAsRGBA32
rundir='surface-from-connection'; runfile='run.lua';		-- WORKS README ... but slow
rundir='mesh'; runfile='view.lua'; cmdline=['meshes/cube.obj'];	-- WORKS README
rundir='sphere-grid'; runfile='run.lua';					-- WORKS README
rundir='topple'; runfile='topple-glsl.lua';					-- WORKS README ... mouse
rundir='topple'; runfile='topple-gpu-display.lua'; but through cl-cpu ... but webgl doesn't support compute kernels or multithreading so it'd be software-driven ... so it'd be way too slow ...
rundir='topple'; runfile='topple-gpu-3d-display.lua'; but through cl-cpu
rundir='earth-magnetic-field';								-- TODO running out of memory ...
rundir='VectorFieldDecomposition';							-- TODO doesn't run
rundir='geo-center-earth';									-- TODO ... ?
rundir='chess-on-manifold';									-- TODO running out of memory ...
rundir='numo9'; runfile='run.lua';							-- "missing declaration for function/global GL_UNSIGNED_SHORT_1_5_5_5_REV" ... ugh GL has standard 1555 ABGR but not 5551 RGBA ... meanwhile 40 years of hardware supports 5551 RGBA and not 1555 ABGR ...
rundir='chompman'; runfile='run.lua';						-- TODO running out of memory
TODO tetris-attack
TODO zeta2d/dumpworld
TODO farmgame
TODO imgui library <-> html shim layer
TODO hydro-cl ... haha with opencl ...
TODO zeta3d / zetatron 3d metroidvania voxel
TODO nbody-gpu
TODO waves-in-curved space ... ?
TODO celestial-gravitomagnetics ... ?
TODO seismograph-stations ... ?
TODO gravitational-waves
TODO cdfmesh
TODO asteroids3d
TODO tacticslua
TODO inspiration engine
TODO ... solarsystem graph ... takes GBs of data ...
TODO black-hole-skymap, but the lua ver is in a subdir of the js ver ... but maybe i'll put the js vers on here too ...
*/

let stdoutTA;
let luaJsScope;
let lua = await newLua({
	print : s => {
		if (stdoutTA) stdoutTA.value += s + '\n';
		console.log('>', s);	//log here too?
	},
	printErr : s => {
		if (stdoutTA) stdoutTA.value += s + '\n';
		console.log('1>', s);	//log here too?
		console.log(new Error().stack);
	},
});
// lua = lua<->js interop layer
// lua.M = lua wasm lib

const M = lua.lib;
const FS = M.FS;

//debugging ... or it's also in the js<->lua interop using js.global (TODO a better way to talk between them?)
window.lua = lua;
window.M = M;
window.FS = FS;

lua.newState();

{
	const pkgs = [];
	//push local glapp-js package
	pkgs.push([
		//{from : '.', to : '.', files : ['ffi.lua']},	// now in wasm
		{
			from : './ffi',
			to : 'ffi',
			files : [
				'EGL.lua',
				'OpenGL.lua',
				'OpenGLES3.lua',
				'cimgui.lua',
				'jpeg.lua',
				'load.lua',
				'libwrapper.lua',
				'png.lua',
				'req.lua',
				'sdl2.lua',
				'zlib.lua',
			]
		},
		{
			from : './ffi/KHR',
			to : 'ffi/KHR',
			files : [
				'khrplatform.lua',
			],
		},
		{
			from : './ffi/c',
			to : 'ffi/c',
			files : [
				'ctype.lua',
				'errno.lua',
				'inttypes.lua',
				'math.lua',
				'setjmp.lua',
				'stdarg.lua',
				'stddef.lua',
				'stdio.lua',
				'stdint.lua',
				'stdlib.lua',
				'string.lua',
				'time.lua',
				'wchar.lua',
			],
		},
		{from : './ffi/c/sys', to : 'ffi/c/sys', files : ['time.lua', 'types.lua']},
		{from : './ffi/cpp', to : 'ffi/cpp', files : ['vector-lua.lua', 'vector.lua']},
		{from : './ffi/gcwrapper', to : 'ffi/gcwrapper', files : ['gcwrapper.lua']},
		{from : './lfs_ffi', to : 'lfs_ffi', files : ['lfs_ffi.lua']},
		{from : './tests', to : 'glapp/tests', files : ['test-js.lua', 'test-ffi.lua']},
	]);
	//push all other packages
	for (let k in luaPackages) pkgs.push(luaPackages[k]);
	// and wait for them all to load
	await Promise.all(pkgs.map(pkg => addPackage(FS, pkg)))
	.catch(e => { throw e; });
}
// why is this here when it's not down there in FS.readdir'/' ?
//console.log('glapp', FS.stat('/glapp'));

// shim layer filesystem stuff here:

FS.writeFile('audio/currentsystem.lua', `return 'null'\n`, {encoding:'binary'});

// remove ffi check from complex
FS.writeFile(
	'/complex/complex.lua',
	FS.readFile('/complex/complex.lua', {encoding:'utf8'}).replace(` = pcall(require, 'ffi')`, ``),
	{encoding:'binary'});

// override ext.gcmem since emscripten's dlsym is having trouble finding its own malloc and free ...
FS.writeFile('ext/gcmem.lua', `
local ffi = require 'ffi'
return {
	new = function(T, n)
		n = math.floor(tonumber(n))			-- get rid of pesky decimals ...
		return ffi.new(T..'['..n..']')		-- no mem leaks here? no ref->0 and immediately free?
	end,
	free = function(ptr)
		-- TODO M._free(ptr)
	end,
}
`, {encoding:'utf8'});

// this is usually clip.so
FS.writeFile('clip.lua', `
return {
	text = function() end,
	image = function() end,
}
`, {encoding:'utf8'});


const refreshEditMode = () => {
	if (editmode) {
		fsDiv.style.display = 'block';
		titleBarDiv.style.display = 'block';
		taDiv.style.display = 'block';
		outDiv.style.display = 'block';
		rootSplit.setVisible(true);
	} else {
		fsDiv.style.display = 'none';
		taDiv.style.display = 'none';
		titleBarDiv.style.display = 'none';
		outDiv.style.display = 'none';
		rootSplit.setVisible(false);
	}
	glappResize();
};

// edit button
A({
	innerText : '+',
	style : {
		position : 'absolute',
		top : '0px',
		right : '0px',
		height : '14px',
		width : '14px',
		background : 'Transparent',
		outline : 'none',
		textDecoration : 'none',
		color : '#ffffff',
		cursor : 'pointer',	//not by default for anchorss?
	},
	events : {
		click : e => {
			editmode = !editmode;
			refreshEditMode();	// refresh size
		},
	},
	appendTo : document.body,
});

// imgui binding code.
// TODO do this in lua with the js api
const imgui = {
	init : function() {
		this?.div?.parentNode.removeChild(this.div);

		// I was using id, but knowing browser software quality standards, any builtin functions are probably ridiculously slow
		this.cache = {};

		// TODO make sure this.div is attached too? or trust it's not tampered with ...
		this.div = Div({
			style : {
				position : 'absolute',
				left : '0px',
				top : '0px',
				backgroundColor : '#000000',
				opacity : .8,
				border : '1px solid #5f5f5f',
				padding : '3px',
				borderRadius : '7px',
			},
			appendTo : document.body,
		});
	},
	clear : function() {
		for (let i = this.div.children.length-1; i >= 0; --i) {
			const ch = this.div.children[i];
			this.div.removeChild(ch);
		}
		this.cache = {};
	},
	newFrame : function() {
		//clear all taggedThisFrame
		for (let i = this.div.children.length-1; i >= 0; --i) {
			const ch = this.div.children[i];
			ch.taggedThisFrame = false;
		}
		this.lastTouchedDom = undefined;
	},
	render : function() {
		//remove old dom elements that didn't get tagged
		for (let i = this.div.children.length-1; i >= 0; --i) {
			const ch = this.div.children[i];
			if (!ch.taggedThisFrame) {
				this.div.removeChild(ch);
				this.cache[ch.id] = undefined;
			}
		}
	},
	create : function(idsuffix, createCB) {
		// TODO maybe I should be using order of creation instead of text names?
		const id = 'imgui_'+idsuffix; // ... plus id stack
		let dom = this.cache[id];
		if (dom) {
			// TODO and make sure the dom tag is correct
			dom.taggedThisFrame = true;
			this.lastTouchedDom = dom;
			return dom;
		}
//console.log('rebuilding', id);
		dom = createCB();
		dom.id = id;
		this.cache[id] = dom;
		if (!this.div) throw "imgui.create called before imgui.newFrame...";
		if (this.lastTouchedDom && this.lastTouchedDom.nextSibling) {
			this.div.insertBefore(dom, this.lastTouchedDom.nextSibling);
		} else {
			this.div.appendChild(dom);
		}
		dom.taggedThisFrame = true;
		this.lastTouchedDom = dom;
		return dom;
	},

	text : function(fmt) {
		this.create(fmt, () => Div({innerText : fmt}));
	},

	button : function(label, size) {
		const button = this.create(label, () => {
			const button = Button({
				innerText : label,
				style : {
					display : 'block',
				},
				events : {
					click :  e => {
						button.imguiClicked = true;
					},
				},
			});
			return button;
		});
		const clicked = button.imguiClicked;
		button.imguiClicked = false;
		return clicked;
	},

	inputFloat : function(label, v, v_min, v_max, format, flags) {
		this.create(label, () => Span({
			innerText : label,
			style : {
				paddingRight : '20px',
			},
		}));
		// TODO use id stack instead of label, or something, idk
		const input = this.create(label+'_value', () => Input({
			value : v,
		}));
		// TODO upon creation set this, then monitor its changes and return' true' if found
		// TODO this will probably trigger 'change' upon first write/read, or even a few, thanks to string<->float
		const iv = parseFloat(input.value);
		const changed = v !== iv;
		this.lastValue = iv;
		this.create(label+'_bf', Br);
		return changed;
	},

	inputInt : function(label, v, v_min, v_max, format, flags) {
		this.create(label, () => Span({
			innerText : label,
			style : {
				paddingRight : '20px',
			},
		}));
		// TODO use id stack instead of label, or something, idk
		const input = this.create(label+'_value', () => Input({
			value : v,
		}));
		// TODO upon creation set this, then monitor its changes and return' true' if found
		// TODO this will probably trigger 'change' upon first write/read, or even a few, thanks to string<->float
		const iv = parseInt(input.value);
		const changed = v !== iv;
		this.lastValue = iv;
		this.create(label+'_bf', Br);
		return changed;
	},

	inputText : function(label, v) {
		this.create(label, () => Span({
			innerText : label,
			style : {
				paddingRight : '20px',
			},
		}));
		const input = this.create(label+'_value', () => Input({
			value : v,
		}));
		const iv = input.value;
		const changed = v !== iv;
		this.lastValue = iv;
		this.create(label+'_bf', Br);
		return changed;
	},

	inputCombo : function(label, v, items) {
		this.create(label, () => Span({
			innerText : label,
			style : {
				paddingRight : '20px',
			},
		}));
		const sel = this.create(label+'_value', () => Select({
			children : items.map(item => Option({
				innerText : item,
			})),
		}));
		const iv = sel.selectedIndex;
		const changed = v !== iv;
		this.lastValue = iv;
		this.create(label+'_bf', Br);
		return changed;
	},

	inputRadio : function(label, variableValue, radioValue, radioGroup) {
		const input = this.create(label+'_value', () => Input({
			type : 'radio',
			name : radioGroup,
			value : radioValue,
			checked : variableValue == radioValue,
		}));
		this.create(label, () => Span({
			innerText : label,
			style : {
				paddingRight : '20px',
			},
		}));
		const inputValue = input.value;
		const changed = input.checked && variableValue != inputValue;	// value is stored as a string so you gotta coerce
		this.lastValue = inputValue;
		this.create(label+'_br', Br);
		return changed;
	},
};
window.imgui = imgui; 	//debugging

let splitDragging;
class Split {
	static size = 2;

	constructor(args) {
		const thiz = this;
		this.dir = args.dir;
		this.onDrag = args.onDrag;
		this.divider = Div({
			style : {
				position : 'absolute',
				backgroundColor : '#ffffff',
				cursor : this.dir == 'horz' ? 'ns-resize' : 'ew-resize',
				zIndex : 1,
				userSelect : 'none',
			},
			events : {
				mousedown : e => {
					splitDragging = thiz;
				},
			},
			appendTo : document.body,
		});

		this.bounds = args.bounds || [0,0,1,1];
		this.offset = args.offset;
		this.L = args.L;
		this.R = args.R;

		this.refreshOffset();
	}

	setVisible(x) {
		this.divider.style.display = x ? 'block' : 'none';
		this.L?.setVisible(x);
		this.R?.setVisible(x);
	}

	dragMouse(x,y) {
		const [rectX, rectY, rectW, rectH] = this.bounds;
		if (this.dir == 'horz') {
			this.offset = y - rectY;
		} else if (this.dir == 'vert') {
			this.offset = x - rectX;
		} else {
			throw 'idk '+this.dir;
		}
		this.refreshOffset();
	}

	refreshOffset() {
		const childBounds = this.getChildBounds();
		this.refreshDom();
		this.onDrag(this, childBounds);
		this.L?.setBounds(...childBounds.L);
		this.L?.refreshOffset();
		this.R?.setBounds(...childBounds.R);
		this.R?.refreshOffset();
	}

	//called by refreshOffset after dragMouse and after ctor
	setBounds(...bounds) {
		this.bounds = [...bounds];
		this.refreshDom();
		const childBounds = this.getChildBounds();
		this.onDrag(this, childBounds);
		this.L?.setBounds(...childBounds.L);
		this.R?.setBounds(...childBounds.R);
	}

	//called upon resize
	resizeBounds(...bounds) {
		const f = this.offset / (this.dir == 'horz' ? this.bounds[3] : this.bounds[2]);
		this.bounds = [...bounds];
		this.offset = parseInt(f * (this.dir == 'horz' ? this.bounds[3] : this.bounds[2]));
		this.refreshDom();
		const childBounds = this.getChildBounds();
		this.onDrag(this, childBounds);
		this.L?.resizeBounds(...childBounds.L);
		this.R?.resizeBounds(...childBounds.R);
	}

	refreshDom() {
		const [rectX, rectY, rectW, rectH] = this.bounds;
		if (this.dir == 'horz') {
			this.divider.style.left = rectX+'px';
			this.divider.style.top = (rectY + this.offset)+'px';
			this.divider.style.width = rectW+'px';
			this.divider.style.height = Split.size+'px';
		} else if (this.dir == 'vert') {
			this.divider.style.left = (rectX + this.offset)+'px';
			this.divider.style.top = rectY+'px';
			this.divider.style.width = Split.size+'px';
			this.divider.style.height = rectH+'px';
		} else {
			throw 'idk '+this.dir;
		}
	}

	getChildBounds() {
		const [rectX, rectY, rectW, rectH] = this.bounds;
		if (this.dir == 'horz') {
			return {
				L : [
					rectX,
					rectY,
					rectW,
					this.offset-1,
				],
				R : [
					rectX,
					rectY + this.offset+1,
					rectW,
					rectH - this.offset - 1,
				],
			};
		} else if (this.dir == 'vert') {
			return {
				L : [
					rectX,
					rectY,
					this.offset-1,
					rectH,
				],
				R : [
					rectX + this.offset+1,
					rectY,
					rectW - this.offset-1,
					rectH,
				],
			};
		}
	}
}
window.addEventListener('mousemove', e => {
	splitDragging?.dragMouse(e.pageX, e.pageY);
});
window.addEventListener('mouseup', e => {
	splitDragging = undefined;
});

// resize uses this too
let fsDiv;
let taDiv;
let titleBarDiv;
let outDiv;
let stdinTA;
// store as pixel <=> smoother scrolling when resizing divider, store as fraction <=> smoother when resizing window ... shrug

let aceEditor;
let editorPath;
let editorFileNameSpan;
let editorArgsInput;
let editorSaveButton;
const editorRun = () => {
	editorSave();			// auto-save before run?
	const parts = editorPath.split('/');
	runfile = parts.pop();
	rundir = parts.join('/');
	runargs = editorArgsInput.value;
	doRun();
};
const editorSave = () => {
	FS.writeFile(editorPath, new TextEncoder().encode(
		aceEditor.getValue()
	), {encoding:'binary'});
	editorSaveButton.setAttribute('disabled', 'disabled');
};
const editorLoad = () => {
	let failed;
	try {
		const fileStr = new TextDecoder().decode(FS.readFile(editorPath, {encoding:'binary'}));
		aceEditor.setValue(fileStr);
		aceEditor.clearSelection();
	} catch (e) {		// TODO file went wrong ... what to do
		e = ''+e;
		M.printErr(e);	// or if this happens at init, is stdoutTA cleared shortly after?
		failed = true;
	}
	if (failed && !editmode) {
		editmode = true;
		refreshEditMode();
	}
	aceEditor.focus();
};

const fileInfoForPath = {};
let openedFileInfo;
const setEditorFilePath = path => {
	if (openedFileInfo) {
		openedFileInfo.titleDiv.style.backgroundColor = '#000000';	//reset
	}
	openedFileInfo = fileInfoForPath[path];
	if (openedFileInfo) {
		openedFileInfo.titleDiv.style.backgroundColor = '#003f7f';							//select

		// here reveal folder and all children
		let fileInfo = openedFileInfo;
		while (fileInfo) {
			if (fileInfo.childrenDiv) fileInfo.childrenDiv.style.display = 'block';
			fileInfo = fileInfo.parentFileInfo;
		}
	}

	if (editorPath) {
		editorSave();		// auto-save before changing files?
	}

	editorPath = path;
	editorFileNameSpan.innerText = editorPath;
	editorLoad();
};

const isDir = path => FS.lstat(path).mode & 0x4000;

{
	fsDiv = Div({
		style : {
			position : 'absolute',
			display : 'none',
			zIndex : -1,	//under imgui div
			backgroundColor : '#000000',
			color : '#ffffff',
			overflow : 'auto',
		},
		appendTo : document.body,
	});

	const makeFileDiv = (path, name, parentFileInfo) => {
		//FS.chdir(path);

		const fileDiv = Div({
			style : {
				border : '1px solid #5f5f5f',
				borderRadius : '7px',
				padding : '3px',
			},
			appendTo : parentFileInfo ? parentFileInfo.childrenDiv : fsDiv,
		});

		const titleDiv = Div({
			appendTo : fileDiv,
		});

		const pathIsDir = isDir(path);
		const fileInfo = {
			path : path,
			name : name,
			isDir : pathIsDir,
			parentFileInfo : parentFileInfo,
			fileDiv : fileDiv,
			titleDiv : titleDiv,
			sortChildren : function(){
				const childrenDiv = this.childrenDiv;
				[...childrenDiv.children].sort((a, b) => {
					return a.fileInfo.name.localeCompare(b.fileInfo.name);
				}).forEach(node => {
					childrenDiv.removeChild(node);
					childrenDiv.appendChild(node);
				});
			},
		};
		fileDiv.fileInfo = fileInfo;
		fileInfoForPath[path] = fileInfo;

		if (pathIsDir) {
			// if it's a dir then this holds all the children and turns display:none/block upon clikc
			const childrenDiv = Div({
				style : {
					marginLeft : '16px',
					display : path == '/' ? 'block' : 'none',
				},
				appendTo : fileDiv,
			});
			fileInfo.childrenDiv = childrenDiv;
			name = name.substr(0,1) == '/' ? name : '/' + name;
			try {
				if (path != '/dev' && path != '/proc') {	//giving exceptions from accessing them
					FS.readdir(path).forEach(f => {
						if (f != '.' && f != '..') {
							let chpath = path.substr(-1) == '/' ? path + f : path + '/' + f;
							makeFileDiv(chpath, f, fileInfo);
						}
					});
					fileInfo.sortChildren();
				}
			} catch (e) {
				console.log('for path '+path+' thought it was a dir but it wasnt: '+e);
			}
			titleDiv.style.cursor = 'pointer';
			titleDiv.addEventListener('click', e => {
				if (childrenDiv.style.display == 'none') {
					childrenDiv.style.display = 'block';
				} else {
					childrenDiv.style.display = 'none';
				}
			});
		} else {
			titleDiv.style.cursor = 'pointer';
			titleDiv.addEventListener('click', e => {
				setEditorFilePath(path);
			});
		}
		titleDiv.innerText = name;	//update name if it's a dir

		const onUpload = () => {
			Input({
				type : 'file',
				events : {
					change : e => {
						const filesrc = e.target.files[0];
						const reader = new FileReader();
						reader.addEventListener('load', e => {
							const result = e.target.result;
							const newname = filesrc.name;
							const newpath = path == '/' ? ('/' + newname) : (path + '/' + newname);
							FS.writeFile(newpath, new Uint8Array(result), {encoding:'binary'});

							makeFileDiv(newpath, newname, fileInfo);
							fileInfo.sortChildren();
							// TODO will aceEditor screw up binary files if i select them + my auto-save-upon-changing-viewed-file ?
							//setEditorFilePath(newpath);		// set it as our current file too? or bad idea if it's a binary file ...
						});
						reader.readAsArrayBuffer(filesrc);
					},
				},
			}).click();
		};

		const onDownload = () => {
			const data = FS.readFile(path, {encoding:'binary'});
			const blob = new Blob([data]);	//TODO {type:mimeType} based on extension or something idk
			const url = URL.createObjectURL(blob);
			//TODO URL.revokeObjectURL eventually / upon finish

			A({
				href : url,
				download : name,
			}).click();
		};

		const onNewFile = () => {
			const newname = prompt('File Name:', '');
			if (!newname) return;

			const newpath = path == '/' ? ('/' + newname) : (path + '/' + newname);
			FS.writeFile(newpath, '', {encoding:'binary'});
			makeFileDiv(newpath, newname, fileInfo);
			fileInfo.sortChildren();
			setEditorFilePath(newpath);			//auto-open?
		};

		const onNewFolder = () => {
			const newname = prompt('File Name:', '');
			if (!newname) return;

			const newpath = path == '/' ? ('/' + newname) : (path + '/' + newname);
			FS.mkdir(newpath);
			makeFileDiv(newpath, newname, fileInfo);
			fileInfo.sortChildren();
		};

		const onDelete = () => {
			if (pathIsDir) {
				FS.rmdir(path);	// can we rmdir empty dirs? nope.
			} else {
				FS.unlink(path);
			}

			// remove from children ...
			parentFileInfo?.childrenDiv.removeChild(fileInfo.fileDiv);

			if (editorPath == path) {
				 // TODO what to set the editor path to if we delete the current file?
			}
		};

		const cmds = [];
		if (pathIsDir) cmds.push({name:'Upload', func:onUpload});
		if (!pathIsDir) cmds.push({name:'Download', func:onDownload});
		if (pathIsDir) cmds.push({name:'New File', func:onNewFile});
		if (pathIsDir) cmds.push({name:'New Folder', func:onNewFolder});
		cmds.push({name:'Delete', func:onDelete});

		/* as context menu * /
		let popupDiv;
		const openContextMenu = e => {
			e.preventDefault();		// no brower right-click
			e.stopPropagation();	// sometimes two files will get hit ...
			popupDiv.parentNode?.removeChild(popupDiv);

			// hmm how to handle this ...
			const closeEH = () => {
				window.removeEventListener('click', closeEH);
				window.removeEventListener('contextmenu', closeEH);
			};
			closeEH();

			popupDiv = Div({
				style : {
					zIndex : -1,
					position : 'absolute',
					left : e.pageX + 'px',
					top : e.pageY + 'px',
					backgroundColor : '#000000',
					border : '1px solid #5f5f5f',
					borderRadius : '7px',
					padding : '1px 3px 1px 3px',
					cursor : 'pointer',
				},
				appendTo : document.body,
				children : cmds.map(cmd =>
					Div({
						innerText : cmd.name,
						style : {
							backgroundColor : '#000000',
							border : '1px solid #5f5f5f',
							borderRadius : '7px',
							padding : '1px 3px 1px 3px',
						},
						events : {
							click : e => {
								e.stopPropagation();
								closeEH();
								cmd.func();
							},
						},
					})
				),
			});

			window.addEventListener('click', closeEH);
		};
		titleDiv.addEventListener('contextmenu', e => {
			e.preventDefault();
			openContextMenu(e);
		});
		/* */
		/* as buttons ... easier than handling page-wise mouse events ... but takes up more UI space ... */
		const imgsForCmds = {
			['Upload'] : 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAABhGlDQ1BJQ0MgcHJvZmlsZQAAKJF9kT1Iw0AcxV9TpVIqDhYUEcxQnSz4hThqFYpQIdQKrTqYXPoFTRqSFhdHwbXg4Mdi1cHFWVcHV0EQ/ABxdnBSdJES/5cUWsR4cNyPd/ced+8AoV5imtUxBmh6xUzGY2I6syoGXhFAH4IYwrjMLGNOkhLwHF/38PH1LsqzvM/9ObrVrMUAn0g8ywyzQrxBPL1ZMTjvE4dZQVaJz4lHTbog8SPXFZffOOcdFnhm2Ewl54nDxGK+jZU2ZgVTI54ijqiaTvlC2mWV8xZnrVRlzXvyF4ay+soy12kOIo5FLEGCCAVVFFFCBVFadVIsJGk/5uEfcPwSuRRyFcHIsYAyNMiOH/wPfndr5SYn3KRQDOh8se2PYSCwCzRqtv19bNuNE8D/DFzpLX+5Dsx8kl5raZEjoGcbuLhuacoecLkD9D8Zsik7kp+mkMsB72f0TRmg9xYIrrm9Nfdx+gCkqKvEDXBwCIzkKXvd491d7b39e6bZ3w+f+3K5+WF7fQAAAAZiS0dEAP8A/wD/oL2nkwAAAAlwSFlzAAAuIwAALiMBeKU/dgAAAAd0SU1FB+gHFwokALVS5AkAAAAZdEVYdENvbW1lbnQAQ3JlYXRlZCB3aXRoIEdJTVBXgQ4XAAABdklEQVRYw+2Wz0rDQBDGv+1JRRFfQHwfQdDYHPzXehYvgo+hb+VJvKkXPXhR20boUZAmn5cpLtNJG7ebFrELA8nOZr7fzu5OFghsBJsEM7EUs2wETwjmBCmWE2zNSrylxIdW1A4xRtyHaNcl3hYBTrCC4GkdM68iHj8TJWm3liGPvieM3U6CX3IEdUYS8cWBILhviA+GZ14BFNKXyhidmWYIwJshfuD5RwCk/9AA74QAZGoWR8pvAojvWEFkIQAJwQ/JRGL4SwG8Ut2RieyW6bgpNij9VwfXCInTwJzbnwbgv8/AAiAuAMEdKRxdgnsVvu15z90KdWNb4vfMOyTBV6+yvVcImEql7FuV0hj/4sXvjVRCKafux+FczFSXxV9swnkB0AL4VGu2EXH9V9Wft28B3KnvrgmuRxBfA3Cluh+tgWdjrtjTmBXzwgJYInj/i7t/qD0RXClL1ybBhxrFnwluTVqzZYLnBG+Me36IDQjeEry0Zv4Nnn4rczHjuc4AAAAASUVORK5CYII=',
			['Download'] : 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAABhGlDQ1BJQ0MgcHJvZmlsZQAAKJF9kT1Iw0AcxV9TpVIqDhYUEcxQnSz4hThqFYpQIdQKrTqYXPoFTRqSFhdHwbXg4Mdi1cHFWVcHV0EQ/ABxdnBSdJES/5cUWsR4cNyPd/ced+8AoV5imtUxBmh6xUzGY2I6syoGXhFAH4IYwrjMLGNOkhLwHF/38PH1LsqzvM/9ObrVrMUAn0g8ywyzQrxBPL1ZMTjvE4dZQVaJz4lHTbog8SPXFZffOOcdFnhm2Ewl54nDxGK+jZU2ZgVTI54ijqiaTvlC2mWV8xZnrVRlzXvyF4ay+soy12kOIo5FLEGCCAVVFFFCBVFadVIsJGk/5uEfcPwSuRRyFcHIsYAyNMiOH/wPfndr5SYn3KRQDOh8se2PYSCwCzRqtv19bNuNE8D/DFzpLX+5Dsx8kl5raZEjoGcbuLhuacoecLkD9D8Zsik7kp+mkMsB72f0TRmg9xYIrrm9Nfdx+gCkqKvEDXBwCIzkKXvd491d7b39e6bZ3w+f+3K5+WF7fQAAAAZiS0dEAP8A/wD/oL2nkwAAAAlwSFlzAAAuIwAALiMBeKU/dgAAAAd0SU1FB+gHFwojIi9zMyoAAAAZdEVYdENvbW1lbnQAQ3JlYXRlZCB3aXRoIEdJTVBXgQ4XAAABd0lEQVRYw+2XsU4CQRCGP8CChMTEIL6BFZFC6Qwd5T0Jb2DlY1BQm0hLbEgIJTZgoq3wAEYDrQ38Fi5hPEDYu4PqJpnk7vZ2/m9mLzt7ENWkGtKH8xpHN6mPJOf9qGGyMRBOt1wfDSARSwFSgBQgBUgBsjsaTgWpi/SAVPJoVCU3p4tUidPxBqbjvSFdmLGhGRuGxF/N2CCpJbgCen8gNmUOPcBmrTgVuEaammxWlQhXYD1zIc2QbuIePKpbIMbmfrxFvJrU6WcTxH+eoLg/hKe4VEZqId0h5WJC7BaXck6rhVQGaWICNGJUYr/MpYaZMyEUpBlxOfYvu9S0mtG24kxmCNSBAfAM1N0zbzsBFmZDyntAvAC3ETStxgKkkSnJJ1LhgD8zBaex1BtlgY555RxoHwTiN+aj01haJ4NUBN6BMzPwBTwB3wnJ54EgJD4DLpd0AdLcY6eL63OkIFyiwHO7jerTdfEVRBHp3n2Y84QzHrnYRSv5AyPcp+z8NxXpAAAAAElFTkSuQmCC',
			['New File'] : 'data:image/png;base64,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IlhNUCBDb3JlIDQuNC4wLUV4aXYyIj4KIDxyZGY6UkRGIHhtbG5zOnJkZj0iaHR0cDovL3d3dy53My5vcmcvMTk5OS8wMi8yMi1yZGYtc3ludGF4LW5zIyI+CiAgPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIKICAgIHhtbG5zOnhtcE1NPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvbW0vIgogICAgeG1sbnM6c3RFdnQ9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZUV2ZW50IyIKICAgIHhtbG5zOmRjPSJodHRwOi8vcHVybC5vcmcvZGMvZWxlbWVudHMvMS4xLyIKICAgIHhtbG5zOkdJTVA9Imh0dHA6Ly93d3cuZ2ltcC5vcmcveG1wLyIKICAgIHhtbG5zOnRpZmY9Imh0dHA6Ly9ucy5hZG9iZS5jb20vdGlmZi8xLjAvIgogICAgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIgogICB4bXBNTTpEb2N1bWVudElEPSJnaW1wOmRvY2lkOmdpbXA6NzU4NjMwMGYtNjRmYS00MDMyLTlkYWMtN2IxMTdkOGQyYjgyIgogICB4bXBNTTpJbnN0YW5jZUlEPSJ4bXAuaWlkOjAwYTExNjRmLWFiNDgtNGVhMy04NzFhLWU2YmQ2ZWNjNGRkYyIKICAgeG1wTU06T3JpZ2luYWxEb2N1bWVudElEPSJ4bXAuZGlkOjI4ZmViYjVjLTRlMWEtNDAzMC1hODIwLTZjZTg0Y2U2MTA2NyIKICAgZGM6Rm9ybWF0PSJpbWFnZS9wbmciCiAgIEdJTVA6QVBJPSIyLjAiCiAgIEdJTVA6UGxhdGZvcm09IkxpbnV4IgogICBHSU1QOlRpbWVTdGFtcD0iMTcyMTM3NTg4NTExNDc2OCIKICAgR0lNUDpWZXJzaW9uPSIyLjEwLjM4IgogICB0aWZmOk9yaWVudGF0aW9uPSIxIgogICB4bXA6Q3JlYXRvclRvb2w9IkdJTVAgMi4xMCIKICAgeG1wOk1ldGFkYXRhRGF0ZT0iMjAyNDowNzoxOVQxMzo1ODowMyswNjowMCIKICAgeG1wOk1vZGlmeURhdGU9IjIwMjQ6MDc6MTlUMTM6NTg6MDMrMDY6MDAiPgogICA8eG1wTU06SGlzdG9yeT4KICAgIDxyZGY6U2VxPgogICAgIDxyZGY6bGkKICAgICAgc3RFdnQ6YWN0aW9uPSJzYXZlZCIKICAgICAgc3RFdnQ6Y2hhbmdlZD0iLyIKICAgICAgc3RFdnQ6aW5zdGFuY2VJRD0ieG1wLmlpZDo3ZDA3YjY4My1mMjMwLTQ1MjUtOWU5Ni0zZDhhZDc4ZjRjYTQiCiAgICAgIHN0RXZ0OnNvZnR3YXJlQWdlbnQ9IkdpbXAgMi4xMCAoTGludXgpIgogICAgICBzdEV2dDp3aGVuPSIyMDI0LTA3LTE5VDEzOjU4OjA1KzA2OjAwIi8+CiAgICA8L3JkZjpTZXE+CiAgIDwveG1wTU06SGlzdG9yeT4KICA8L3JkZjpEZXNjcmlwdGlvbj4KIDwvcmRmOlJERj4KPC94OnhtcG1ldGE+CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAKPD94cGFja2V0IGVuZD0idyI/Pihzw7IAAAAGYktHRAD/AP8A/6C9p5MAAAAJcEhZcwAALiMAAC4jAXilP3YAAAAHdElNRQfoBxMHOgWWwytdAAAAGXRFWHRDb21tZW50AENyZWF0ZWQgd2l0aCBHSU1QV4EOFwAAAQlJREFUWMPtlz0OgkAQhR/EwphszUk8B0fwAtzAeAYL76OFVlhoYaW3oKHA5FmwBEGQZXf5S5gpaJjZb+btQAYYrRE+iBOIBFT2F4gdiJXp4fsWh1b5HYRnUjlBxCACEEIxzilBPPQg0rYTRKAR+324JkSuuTAA8PQhshR68uWx2hBmAJGMXldA3NSmwwzg0DAd264BlhIiqgF4dgugMqIlc3v5qjr1BbmGlYUgQtv/AHUJLLzbjwR/bGIAqeb8aWdx1MJJdWC+hIMDLAzjr8PeAQt55zswSoC31ExY1F8UcjcAXORzY7HQLNe5u8WkrvI0Ryxz+n2tZlW+11nRji2X07InMoePsdoHHAdgdUB5RO8AAAAASUVORK5CYII=',
			['New Folder'] : 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAABhGlDQ1BJQ0MgcHJvZmlsZQAAKJF9kT1Iw0AcxV9bpUUqDi0i4pCh6mJBVMRRq1CECqFWaNXB5NIvaNKQpLg4Cq4FBz8Wqw4uzro6uAqC4AeIs4OToouU+L+k0CLGg+N+vLv3uHsH+BsVpppd44CqWUY6mRCyuVUh+IogIgihH6MSM/U5UUzBc3zdw8fXuzjP8j735+hV8iYDfALxLNMNi3iDeHrT0jnvE0dZSVKIz4nHDLog8SPXZZffOBcd9vPMqJFJzxNHiYViB8sdzEqGSjxFHFNUjfL9WZcVzluc1UqNte7JXxjOayvLXKc5hCQWsQQRAmTUUEYFFuK0aqSYSNN+wsM/6PhFcsnkKoORYwFVqJAcP/gf/O7WLExOuEnhBND9Ytsfw0BwF2jWbfv72LabJ0DgGbjS2v5qA5j5JL3e1mJHQN82cHHd1uQ94HIHGHjSJUNypABNf6EAvJ/RN+WAyC3Qs+b21trH6QOQoa5SN8DBITBSpOx1j3eHOnv790yrvx9hlHKgn1zBvAAAAAZiS0dEAP8A/wD/oL2nkwAAAAlwSFlzAAAuIwAALiMBeKU/dgAAAAd0SU1FB+gHEwgXENBo0mQAAAAZdEVYdENvbW1lbnQAQ3JlYXRlZCB3aXRoIEdJTVBXgQ4XAAAA1klEQVRYw+2WPQrCQBCFH9EiQTxO+tzEU3gFY59brb3XENKHz2YCKiHkZ7MbZB8MW8ww8+aXlRIS9gZQDmpALYgfeYFqULYlgWYg8FppzW8+hUCfeTmgq0DdCiLNFAKAGNHXZvMEFROrWvaV8EGgsOCA6hmtHfU7y9Ay6kyq4ATM7rZkDnwSOIDutprhCcxc7VNUAmN+s9iX9xgw1sPvvnpC9BZsSgDkQM7LtPqc/P9ugZX9K/OPS+h2V4FZH5ItZsDXl8wtJTB0Ca/2XiSdg1y/hISYeAMW5MAnrSYD2QAAAABJRU5ErkJggg==',
			Delete : 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAABhGlDQ1BJQ0MgcHJvZmlsZQAAKJF9kT1Iw1AUhU9TpSIVh3YQcchQnSxIleKoVShChVArtOpg8tI/aGJIUlwcBdeCgz+LVQcXZ10dXAVB8AfE2cFJ0UVKvC8ptIjxweV9nPfO4b77AKFZY5rVMwFoum1m0ykxX1gRQ68IIUKVREJmljErSRn4rq97BPh+F+dZ/vf+XANq0WJAQCSeYYZpE68TJzdtg/M+cZRVZJX4nHjcpAaJH7muePzGueyywDOjZi47RxwlFstdrHQxq5ga8RRxTNV0yhfyHquctzhrtTpr98lfGC7qy0tcpxpBGgtYhAQRCuqoogYbcdp1Uixk6Tzl4x92/RK5FHJVwcgxjw1okF0/+B/8nq1Vmkx4SeEU0PviOB+jQGgXaDUc5/vYcVonQPAZuNI7/o0mMP1JeqOjxY6AwW3g4rqjKXvA5Q4w9GTIpuxKQSqhVALez+ibCkDkFuhf9ebWPsfpA5CjWWVugINDYKxM2Ws+7+7rntu/d9rz+wHKUnLK2aV6FwAAAAZiS0dEAP8A/wD/oL2nkwAAAAlwSFlzAAAuIwAALiMBeKU/dgAAAAd0SU1FB+gHEwgBHitISrQAAAAZdEVYdENvbW1lbnQAQ3JlYXRlZCB3aXRoIEdJTVBXgQ4XAAACIElEQVRYw+2WTWsTURSGnzszZmgSdzKSgm5cKGjVCmlFaBCl7vQfdGndSVuwXWkqAdeWqosu6kcFoSCCrkRQzELwKxSTSiP4C0pdFdNMnFwX02DmZqKTZsYvemAW99wz8z5c3nPuCALE12OZx8BZOosn8UL+3K+KhCIkgINKTT9wj63FCEIseTJSLscLedlYGsoLT4FhwosFpFRzz4AzjYWmbJ4m+jjVvND4w/HXAXz+DZoeDdWEw5uPHpG4s2lC/zZsasd9qllCiOfxQr7lhI02xQ+AdMgAb4GBoCbsieD4e/6JLtgGaHtlxeZnMR/dR2QG2pbJwaNs3LlBdeYaCBEegDh5Av3IYbS9ezBzWURm0Fe8MjWBk0rx7cB+5E9AOwaQL17hfCi6MMkkZu6KB6IhLhMJt7dXyoiXr8P1gH1hHKdYaoFoES9/wpyaDuyBdpOwCBxq2YjtIDZ3Hb3P3ZLr63xZW/OKT2Zhw/b7bCleyPd11wV2DXt0zHMSAcVDbEO7Ru32AjjOj1y9TmzxYcfiWwIQQ2nMq5dBb7owNY3KxEXk8f5oAcRQGjM3jdiZdO/W0jLGStn1QyJBZXK8YwitG3F7dAzzUrYriGAAvZY7gBRxqjbYNV8Ieq0QJ2HKQiR9xJuMqUJIa1cgACPQJHxfojp7C7HbwpmZ84orEPr5EcTqKmLpY3gAAPW7i4Fa1Lg5v/0/8H8AvItA641f8jtDCMZ/I7Ih8wAAAABJRU5ErkJggg==',
		};
		[...cmds].reverse().forEach(cmd => {
			A({
				href : '#',
				title : cmd.name,
				style : {
					color : '#ff3f3f',
					cssFloat : 'right',
					//textAlign : 'right',	// for children?
					right : '0px',
					backgroundColor : '#000000',
					border : '1px solid #5f5f5f',
					borderRadius : '7px',
					paddingLeft : '3px',
					paddingRight : '3px',
				},
				events : {
					click : e => {
						e.stopPropagation();	//stop fallthru to title click
						cmd.func();
					},
				},
				appendTo : titleDiv,
				children : [
					Img({
						src : imgsForCmds[cmd.name],
						height : 14,
					}),
				],
			});
		});
		/**/
	};
	FS.chdir('/');
	makeFileDiv('/', '/', undefined);
	FS.chdir('/');

	taDiv = Div({
		id : 'taDiv',
		style : {
			position : 'absolute',
			display : 'none',
			//overflow : 'hidden',
			zIndex : -1,	//under imgui div
		},
		events : {
			keydown : async (e) => {
				//what's a good hotkey for run?
				// ctrl-r ? nah that's "reload"
				// shift-f5?  can browser trap f-keys?
				// shift-enter?
				if (e.shiftKey && e.key == 'Enter') {
					e.preventDefault();
					editorRun();
				}
			},
		},
		appendTo : document.body,
	});

	titleBarDiv = Div({
		style : {
			height : '1em',
			position : 'absolute',
			display : 'none',
			border : '1px solid #5f5f5f',
			borderRadius : '7px',
			padding : '1px',
			backgroundColor : '#000000',
		},
		appendTo : document.body,
		children : [
			//run
			A({
				href : '#',
				title : 'Shift+Enter to Run',
				style : {
					border : '1px solid #5f5f5f',
					borderRadius : '7px',
					padding : '3px',
				},
				events : {
					click : async (e) => {
						editorRun();
					},
				},
				children : [
					Img({
						src : 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAABhGlDQ1BJQ0MgcHJvZmlsZQAAKJF9kT1Iw0AcxV/TSkUqDu0g4pChOlkRFXHUKhShQqgVWnUwufQLmhiSFBdHwbXg4Mdi1cHFWVcHV0EQ/ABxdnBSdJES/5cUWsR4cNyPd/ced+8AoVFlmhUaAzTdNjOppJjLr4jhV4QRRQijiMjMMmYlKQ3f8XWPAF/vEjzL/9yfo1ctWAwIiMQzzDBt4nXiqU3b4LxPHGNlWSU+Jx4x6YLEj1xXPH7jXHJZ4JkxM5uZI44Ri6UOVjqYlU2NeJI4rmo65Qs5j1XOW5y1ao217slfGCnoy0tcpzmIFBawCAkiFNRQQRU2ErTqpFjI0H7Sxz/g+iVyKeSqgJFjHhvQILt+8D/43a1VnBj3kiJJoOvFcT6GgPAu0Kw7zvex4zRPgOAzcKW3/RsNYPqT9Hpbix8BfdvAxXVbU/aAyx2g/8mQTdmVgjSFYhF4P6NvygPRW6Bn1euttY/TByBLXaVvgINDYLhE2Ws+7+7u7O3fM63+fgBQSXKZtanoYgAAAAZiS0dEAP8A/wD/oL2nkwAAAAlwSFlzAAAuIwAALiMBeKU/dgAAAAd0SU1FB+gHEwQwFATaXXwAAAAZdEVYdENvbW1lbnQAQ3JlYXRlZCB3aXRoIEdJTVBXgQ4XAAACRklEQVRYw8WXzWsTURTFfzMdMBWLXai4cOUi0hakdVLIUtpVCvkHFNx0PSAoFsUKGhAEC8ZZu3GRjd0VGgQV3Qk6tAgGHKEgfmEiWKmYFmqfmxt5bVN985HxbGfenPPOvHfvuRaG8ALrIDAFTABjQB4YkMdrwFtgCXgM1H1XrZp81zIgzgMzwBkgZ6h3HagBt3xXhbEEeIHVD1SA80Af8bAJVIFrvqt+GgvwAus4sAAMkw4aQNl31co/BXiBVQAWgcOkixZQ8l0V7ClAdv68B+S6iKLuhKWR7wdepGj7335HwXdVG8DWHtzIgBzhqGxzQK5aI8Fpj4pfwLDvqrDjwIwp+dWh91wf+cLJA1eSCOgTTiwvsAaBz6ZF5u6pLQAUiqD5jAefLtDeWoojYh04agOlCBVOuz4WhSOnuTz0MK4bOWDKBiaTeDm47xDT+Qrnjj2h3x6LunzSBkaTnqgEboza0tVSQQw38rbWUlNBx42LJxZMXh+w+c+wJUykBoXiZfMpt9+UTV5fc4AQcNMgX934yvy7O7z6cdN0SegAy0kFJChKy45kuOkMd63jkQPUpSzmMtq1XorrtqTXmumqZvsj3zZa3Atnuf9hIi45QM131Xe9Hb8GnIxu3yYw8qcdS3SuZnj9q524rheiWQklvUZDuNgmQDJaWYJjr9CSeN7eJUBErEg+aPWIvLRzNtjVCyS3F+VQpml7cedM0FWA5sQ4MCcBMslpnwPGu01FUYbTS8DZTIfTPcbzkkS4buN5KH0l0nj+GwVB22gu8TRJAAAAAElFTkSuQmCC',
						height : 14,
					}),
				],
			}),

			//save
			editorSaveButton = A({
				href : '#',
				style : {
					border : '1px solid #5f5f5f',
					borderRadius : '7px',
					padding : '3px',
				},
				attrs : {
					disabled : 'disabled',		// bleh, only works with buttons ... why is js behavior so unevenly applied?
				},
				events : {
					click : e => { editorSave(); },
				},
				children : [
					Img({
						src : 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAABhGlDQ1BJQ0MgcHJvZmlsZQAAKJF9kT1Iw0AcxV/TSkUqDu0g4pChOlkRFXHUKhShQqgVWnUwufQLmhiSFBdHwbXg4Mdi1cHFWVcHV0EQ/ABxdnBSdJES/5cUWsR4cNyPd/ced+8AoVFlmhUaAzTdNjOppJjLr4jhV4QRRQijiMjMMmYlKQ3f8XWPAF/vEjzL/9yfo1ctWAwIiMQzzDBt4nXiqU3b4LxPHGNlWSU+Jx4x6YLEj1xXPH7jXHJZ4JkxM5uZI44Ri6UOVjqYlU2NeJI4rmo65Qs5j1XOW5y1ao217slfGCnoy0tcpzmIFBawCAkiFNRQQRU2ErTqpFjI0H7Sxz/g+iVyKeSqgJFjHhvQILt+8D/43a1VnBj3kiJJoOvFcT6GgPAu0Kw7zvex4zRPgOAzcKW3/RsNYPqT9Hpbix8BfdvAxXVbU/aAyx2g/8mQTdmVgjSFYhF4P6NvygPRW6Bn1euttY/TByBLXaVvgINDYLhE2Ws+7+7u7O3fM63+fgBQSXKZtanoYgAAAAZiS0dEAP8A/wD/oL2nkwAAAAlwSFlzAAAuIwAALiMBeKU/dgAAAAd0SU1FB+gHEwQxBXdxTM8AAAAZdEVYdENvbW1lbnQAQ3JlYXRlZCB3aXRoIEdJTVBXgQ4XAAAB5UlEQVRYw+2XPU9UQRiFn3ddE9aG0KF0WBHDR03cBBMLQ0VDgYmdriUVDQUk/gBMSCz0DxD+AIWJ8WOBihCjhZ0fBUpJISwhsIfmHXO9XHZW7u6NxZ5mPt6ZOWfOfWduBgBJVUl1SU11D28lVUjDyU9UDC6IMEl14C7QAF4CB4n4LHAH+Am84nI8BW4Cv3yNdN83YNL73wHTZtYIDgTbn2e4s+6xnRbkSNpJj0v2Sar47i84UQLM5xzQJfhup333AFPAhqRKiYJwmYjCBKREbAcR5Q6t/Qi4ARy1I0LS65CUMQFNL69FFv3SInzWam5MwA8vJyTNA5ttOjIBjHl9l8gRCljOiA1LOsxx8RxLGs1YdzkMKEWs/Qo8AL5fIS/2gRkz+5znE2BmdUnDwHgsF1K588nMzmIDy20eHwEfu3E0y5H8GASGcnLsm9nePwmQ1AesAk86sUtJa8BjMztq14GVTpE75rx8GBUgqT9Bvg0sAr+vSFwBngH3gDlJC+nPkeXA7UT/CzN7n9P+JaDuzUHgLwFZ94Al6qcdsL/RKljo37AnoCegJ+C/FSCvDxTIG7hUBrb8aVaTFO7vP08zSSM5yW4l6jVJDaDm7U2TVAXeANcLdv8EuJ98IX/o8vM8oOlcVYBzQKxhLYk+dM8AAAAASUVORK5CYII=',
						height : 14,
					}),
				],
			}),

			// reload
			A({
				href : '#',
				style : {
					border : '1px solid #5f5f5f',
					borderRadius : '7px',
					padding : '3px',
				},
				events : {
					click : e => { editorLoad(); },
				},
				children : [
					Img({
						src : 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAABhGlDQ1BJQ0MgcHJvZmlsZQAAKJF9kT1Iw0AcxV/TSkUqDu0g4pChOlkRFXHUKhShQqgVWnUwufQLmhiSFBdHwbXg4Mdi1cHFWVcHV0EQ/ABxdnBSdJES/5cUWsR4cNyPd/ced+8AoVFlmhUaAzTdNjOppJjLr4jhV4QRRQijiMjMMmYlKQ3f8XWPAF/vEjzL/9yfo1ctWAwIiMQzzDBt4nXiqU3b4LxPHGNlWSU+Jx4x6YLEj1xXPH7jXHJZ4JkxM5uZI44Ri6UOVjqYlU2NeJI4rmo65Qs5j1XOW5y1ao217slfGCnoy0tcpzmIFBawCAkiFNRQQRU2ErTqpFjI0H7Sxz/g+iVyKeSqgJFjHhvQILt+8D/43a1VnBj3kiJJoOvFcT6GgPAu0Kw7zvex4zRPgOAzcKW3/RsNYPqT9Hpbix8BfdvAxXVbU/aAyx2g/8mQTdmVgjSFYhF4P6NvygPRW6Bn1euttY/TByBLXaVvgINDYLhE2Ws+7+7u7O3fM63+fgBQSXKZtanoYgAAAAZiS0dEAP8A/wD/oL2nkwAAAAlwSFlzAAAuIwAALiMBeKU/dgAAAAd0SU1FB+gHEwQyJWcyP8QAAAAZdEVYdENvbW1lbnQAQ3JlYXRlZCB3aXRoIEdJTVBXgQ4XAAAB+UlEQVRYw8WXT0hUURTGv2tiOA0ECmXhIoKQBEEEcdHCTeBOaCmtAikH3LUUWwRCIG1duHHhwl2LRKQQXAgRWePGRX8wEHUmhFaDimL82lxDXvdeZ95943yrx3vnfN85755z7r1SBIA+NRLAZ2AGaG1kAACbQHcjAwA4BJ5dprgBvvA/3gDX6yF4BRgG5oBvhLENPMhSfNSS1oI/wAvAxAh3AmvE4R3Qkka8B9iNFP+RalYAd4BypPg8cC2N+FVg4wLyX8ACsO/4VgFGYtZ9IiC8AzwGmhxzAGAduBsj3mYzcGENaAsMolepii1B+Nwj/h3IeyZhGRjKqt8/eAIY9NhPAR1Zibd6xD/Wc6Q3nXu+77FZrGcAzeeeb3psfkb81W5JBcenOWNMMRmA71BxGJHgPUnjjverkorJJSh5SGKK7JbnfclVA7se48GIAHy+e74123N0wQHQnmL9261vEiVfF0jSWwdXTtJ0iuynra+q0PgXdX9gHxirIfuxAM/ARc7LAefXQC7gm7M2PrxP+hgHSZekjUBb7kualbRii8lIui3poaSnkm54/I4k9RljvlbzC5+QPUZrreLJDMVfph2lBeA4QvgEGI/dJXsdJ59qUMz08movJUvAaUD01HbRo2p5TYpA8pL67UZzNiF/S9qS9MkYU6mF7y+NXuL7i6ZMtwAAAABJRU5ErkJggg==',
						height : 14,
					}),
				],
			}),

			//share / rewrite url
			A({
				href : '#',
				style : {
					border : '1px solid #5f5f5f',
					borderRadius : '7px',
					padding : '3px',
				},
				events : {
					click : e => {
						const newUrlParams = new URLSearchParams();
						newUrlParams.set('file', runfile);
						newUrlParams.set('dir', rundir);
						newUrlParams.set('args', runargs);
						const url = location.origin + location.pathname + '?' + newUrlParams.toString();
						history.replaceState({
							runfile : runfile,
							rundir : rundir,
							runargs : runargs,
						}, document.title, url);

						navigator.clipboard.writeText(url);

						navigator?.share({
							title : document.title,
							text : 'GLApp',
							url : url,
						})
					},
				},
				children : [
					Img({
						src : 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAABhGlDQ1BJQ0MgcHJvZmlsZQAAKJF9kT1Iw0AcxV/TSqVUHNpBxCFDdbIgWsRRq1CECqFWaNXB5NIvaNKSpLg4Cq4FBz8Wqw4uzro6uAqC4AeIs4OToouU+L+k0CLGg+N+vLv3uHsHCK0q08zABKDplpFJJcVcflUMviKICEJIICAzsz4nSWl4jq97+Ph6F+dZ3uf+HANqwWSATySeZXXDIt4gnt606pz3iaOsLKvE58TjBl2Q+JHristvnEsOCzwzamQz88RRYrHUw0oPs7KhESeIY6qmU76Qc1nlvMVZqzZY5578heGCvrLMdZojSGERS5AgQkEDFVRhIU6rToqJDO0nPfzDjl8il0KuChg5FlCDBtnxg//B727N4tSkmxROAn0vtv0xCgR3gXbTtr+Pbbt9AvifgSu966+1gJlP0ptdLXYEDG4DF9ddTdkDLneAoae6bMiO5KcpFIvA+xl9Ux6I3AKhNbe3zj5OH4AsdZW+AQ4OgbESZa97vLu/t7d/z3T6+wFaYXKdgHsyPwAAAAZiS0dEAP8A/wD/oL2nkwAAAAlwSFlzAAAuIwAALiMBeKU/dgAAAAd0SU1FB+gHEwo1B/eNxe0AAAAZdEVYdENvbW1lbnQAQ3JlYXRlZCB3aXRoIEdJTVBXgQ4XAAADAUlEQVRYw81XPUwUQRSeO3KJgViAhbHDaAXG4kqJnQ2NVEaiiVpamAsWGq0oDFEbLbAT7DQEzEFIKDhOExGN5AINajbcBvnZHLe3t7u3fzN7szvzbHbNcZ4Rwy74mknmTfb75u2b772HUAy2trbWqev6c9d1t33fB9d1TULIzPr6+gUUt4mieIZS+gMCM00TPM8DAADOObUs63qc+AnXdQsAABjjRVEUexBCKJfLnTAM4xFjDBhjtFKp9MaCXi6X+wEA6vV6cWFhoaPZb9v2YwAA27Zfx0LAsqynAACO4zxo5V9eXj4NAOB5XjHcS0ZJgDF2HCGEOOd6K//ExIQcnOuMJQKmad4JItAyxNVqtR8AgBDyJXLwjY2NboxxLkh+uru7e6XJf6perxcBAKrVaiYy4Hw+n9J1/aHneQQAgFJqAQAwxgBjPKvr+rDjOC9839eC2y9NTk6mIgEvlUoXCSHfQ0DTNF8GInTb930TGoxzDhjjN+VyueOvHx4aGkptbW2lVVXtW11d7W72C4LQZVnWOGMMglt9lSRpj8oVCoUuRVFuGIYxrGnaXUEQzu3rVoqi3KOUVpqYf5IkKR0k0i1KaRUAwPd9W9O0+2NjY9GE1DCMVyGo4zjfNE1bCslwzm1CyOeQmOM4s4IgdEeWTJqmDQRJZO/s7FwK97PZ7LFarTYaAlNKtxVFGYj8GWGM3wMA1Gq1m6384e1VVb0aJW6jEqY552hubi77h7NvEUKovb39fFwEjtYwxu+O4hc0JuHlMAklSfqVhNPT04eThMEzHD+yZ/hfCFFomUwmtbm5mVZVtW9lZeVAUmya5r9JcYTFyGouRoSQN7Isd0RKYp/leLSxHE9NTaUij0ZjQ8I5p6VS6XAakoO2ZJEqIee8J1gXW/lHRkY+IIRQIpE4GwuBZDJpBWvLrndwcPAkQgi1tbXpsQ8m+Xy+1WDyBADAsqx4BpOm0eyjKIq9CCE0Pz+/ZzSTZbk3LgL7GU6vxV5ZAzF61jCeG4SQmWKx+Nt4/hMEvsjczhecQwAAAABJRU5ErkJggg==',
						height : 14,
					}),
				],
			}),

			editorFileNameSpan = Span({
				style : {
					paddingLeft : '5px',
				},
			}),

			editorArgsInput = Input({
				value : runargs,
				placeholder : 'args in JSON format',
				style : {
					color : '#ffffff',
					background : 'Transparent',
					position : 'absolute',
					right : '0px',
				},
			}),
		],
	});

	outDiv = Div({
		style : {
			position : 'absolute',
			display : 'none',
			zIndex : -1,	//under imgui div
		},
		appendTo : document.body,
		children : [
				// save to window for debugging
				window.stdoutTA = stdoutTA = TextArea({
				readOnly : true,
				style : {
					backgroundColor : '#000000',
					color : '#ffffff',
					width : '100%',
					height : '100%',
					tabSize : 4,
					MozTabSize : 4,
					OTabSize : 4,
					whiteSpace : 'pre',
					overflowWrap : 'normal',
					overflow : 'auto',
				},
			}),
			stdinTA = TextArea({
				style : {
					position : 'absolute',	// \_ these two together put it at the bottom of its container
					bottom : '0px',			// /
					backgroundColor : '#000000',
					color : '#ffffff',
					width : '100%',
					height : '1em',
					tabSize : 4,
					MozTabSize : 4,
					OTabSize : 4,
					whiteSpace : 'pre',
					overflowWrap : 'normal',
					overflow : 'hidden',
				},
				events : {
					keypress : e => {
						// what should execute? enter or shift+enter ?
						if (e.code == 'Enter') {
							e.preventDefault();
							const txt = stdinTA.value;
							stdinTA.value = '';
							if (lua) {
								lua.doString(txt);
							} else {
								M.printErr('lua state not present');
							}
						}
					},
				},
			}),
		],
	});

	// ace editor: https://github.com/ajaxorg/ace
	aceEditor = ace.edit("taDiv");
	aceEditor.setBehavioursEnabled(false);
	aceEditor.setTheme("ace/theme/tomorrow_night_bright");
	const LuaMode = ace.require("ace/mode/lua").Mode;
	aceEditor.session.setMode(new LuaMode());
}

document.body.style.overflow = 'hidden';	//slowly sorting this out ...
let canvas;
let canvasOutputSplit;

const rootSplit = new Split({
	bounds : [0, 0, window.innerWidth, window.innerHeight],
	dir : 'vert',
	offset : window.innerWidth / 4,
	onDrag : (split, childBounds) => {
		const L = childBounds.L;
//console.log('setting fsDiv to', L);
		fsDiv.style.left = L[0]+'px';
		fsDiv.style.top = L[1]+'px';
		fsDiv.style.width = L[2]+'px';
		fsDiv.style.height = L[3]+'px';
	},
	R : new Split({
		dir : 'vert',
		offset : window.innerWidth / 2,
		onDrag : (split, childBounds) => {
			const L = childBounds.L;
//console.log('setting taDiv to', L);
			titleBarDiv.style.left = L[0] + 'px';
			titleBarDiv.style.top = L[1] + 'px';
			titleBarDiv.style.width = (L[2] - 2) + 'px';	// minus 1px padding x2
			titleBarDiv.style.height = '20px';

			taDiv.style.left = L[0] + 'px';
			taDiv.style.top = (L[1] + 24) + 'px';
			taDiv.style.width = L[2] + 'px';
			taDiv.style.height = (L[3] - 24) + 'px';

			const R = childBounds.R;
		},
		R : canvasOutputSplit = new Split({
			dir : 'horz',
			offset : window.innerHeight / 2,
			onDrag : (split, childBounds) => {
				const U = childBounds.L;
				if (canvas) {
					let canvasWidth, canvasHeight;
					if (editmode) {
						canvas.style.left = U[0] + 'px';
						canvas.style.top = U[1] + 'px';
						canvasWidth = U[2];
						canvasHeight = U[3];
					} else {
						canvas.style.left = '0px';
						canvas.style.top = '0px';
						canvasWidth = window.innerWidth;
						canvasHeight = window.innerHeight;
					}
					canvas.width = canvasWidth;
					canvas.height = canvasHeight;
					canvas.style.width = canvasWidth+'px';
					canvas.style.height = canvasHeight+'px';

					if (luaJsScope && luaJsScope.sdlWindow) {
						// NOTICE: SDL shows that for fullscreen, this will call "SDL_UpdateFullscreenMode", which might be more baggage than I want.
						// Lucky for me I'm using windowed SDL and not fullscren SDL.
						// For windows all it does is set the window size and issue a SDL_WINDOWEVENT_SIZE_CHANGED
						//
						// I wonder why it flickers while it's resizing ...
						M._SDL_SetWindowSize(luaJsScope.sdlWindow, canvasWidth, canvasHeight);
					}

					const D = childBounds.R;
					outDiv.style.left = D[0] + 'px';
					outDiv.style.top = D[1] + 'px';
					outDiv.style.width = D[2] + 'px';
					outDiv.style.height = D[3] + 'px';
				} else {
					// no canvas? don't split ...
					const D = split.bounds;
					outDiv.style.left = D[0] + 'px';
					outDiv.style.top = D[1] + 'px';
					outDiv.style.width = D[2] + 'px';
					outDiv.style.height = D[3] + 'px';
				}
			},
		}),
	}),
});
window.rootSplit = rootSplit;	// debugging
const glappResize = e => {
	//hide/show the split if canvas is present
	// i'm 50/50 on giving the splits child divs themselves and not resizing based on the child bounds
	// and then i could dynamically add/remove this split ...
	canvasOutputSplit.divider.style.display = (editmode && canvas) ? 'block' : 'none';

	rootSplit.resizeBounds(0, 0, window.innerWidth, window.innerHeight);
};
window.addEventListener('resize', glappResize);
refreshEditMode();	// will trigger glappResize()


// make sure to do this after initializing the Splits / editor UI, in case we need to popup the editor
// in fact, why not do this within doRun?
if (rundir && runfile) {
	setEditorFilePath(rundir+'/'+runfile);
}

let gl;
const closeCanvas = () => {
	canvas?.parentNode?.removeChild(canvas);
	canvas = undefined;
	glappResize(); // refresh split
};

const doRun = async () => {

	// we need to make sure the old setInterval is dead before starting the new one ...
	// ... or else the next update could kill us ...
	if (luaJsScope && luaJsScope.glappMainInterval) {
		clearInterval(luaJsScope.glappMainInterval);
		luaJsScope.glappMainInterval = undefined;
	}

	imgui.init();	// make the imgui div

	document.title = runfile;

	//TODO maybe, if our run file is dif from the last run file then window.history.pushState() ?
	{
		const newParams = new URLSearchParams();
		newParams.set('file', runfile);
		newParams.set('dir', rundir);
		if (runargs) newParams.set('args', runargs);
		if (editmode) newParams.set('edit', editmode);
		const url = location.origin + location.pathname + '?' + newParams.toString();
		history.pushState({
			runfile : runfile,
			rundir : rundir,
			runargs : runargs,
		}, document.title, url);
	}

	closeCanvas();
	//if (lua) lua.close();	//tf why are all these essential functions hidden?

	// emscripten cleanup
	// every time I start up SDL stuff, emscripten installs some window event listeners
	// remove everything that emscripten already added:
	// only works in console ... retards trying to make code retard-proof , smh ...
	//const listeners = window.getEventListeners(window);
	const resetListeners = () => {
		// remove all listeners of these types
		removeAllElemEventListeners(window, ['beforeunload', 'blur', 'focus', 'keydown', 'keypress', 'keyup', 'resize']);

		// re-add my resize listener
		window.addEventListener('resize', glappResize);	// now re-add mine
	};
	resetListeners();
	glappResize();



	// make a new state
	lua.newState();
	luaJsScope = {}
	luaJsScope.imgui = imgui;	//save it here to pass to js.imgui for ffi/cimgui.lua to use
window.luaJsScope = luaJsScope;
	luaJsScope.resetWindowListeners = () => {
		/*
		This is called right after SDL_CreateWindow, right after emscripten  tries to take total control of your JS environment
		It overrides all key events, so that text fields outside the canvas no longer work.
		It also does nothing useful with window resizing.
		I'd like to keep its key events, but simply not throw them away.
		*/

		// let Lua tell us once the window is made to clear the Emscripten listeners once again
		// this gets our control back to DOM elements, but removes it from the canvas.  I want both.
		//resetListeners();

		// Remove emscripten's resize event.  what was it doing anyways?  I had to call SDL_SetWindowSize myself upon resize.
		removeAllElemEventListeners(window, ['resize']);
		window.addEventListener('resize', glappResize);	// now re-add mine

		// save emscripten's window listeners
		const saveEmscriptenListeners = {};

		const windowListeners = eventListeners.get(window);
		if (windowListeners) {
			['beforeunload', 'blur', 'focus', 'keydown', 'keypress', 'keyup'].forEach(eventType => {
				const listenersForType = windowListeners[eventType];
				if (listenersForType) {
if (listenersForType.length != 1) {
	console.log(listenersForType);
	console.log('got irregular window event listener size back from emscripten -- something will probably go wrong');
}
					const listener = listenersForType[0];
					saveEmscriptenListeners[eventType] = listener.slice();
					//window.removeEventListener(eventType, ...listenArgs);
				}
			});
		}

		// click the canv
		canvas.addEventListener('focus', e => {
			// enable/add all the emscripten events
			for (const [eventType, listener] of Object.entries(saveEmscriptenListeners)) {
				window.addEventListener(eventType, ...listener);
			}
		});
		canvas.addEventListener('blur', e => {
			// disable/remove all the emscripten events
			for (const [eventType, listener] of Object.entries(saveEmscriptenListeners)) {
				window.removeEventListener(eventType, ...listener);
			}
		});
	};

	// useful function , maybe store in luaJsScope?
	window.dataToArray = (jsArrayClassName, addr, count) => {
		if (addr == null) return null;	// ???
		const cl = window[jsArrayClassName];
		if (count === null || count === undefined) {
			return new cl(M.HEAPU8.buffer, addr);
		} else {
			return new cl(M.HEAPU8.buffer, addr, count);
		}
	};


	// Would be nice if emscripten's sdl lib had callbacks
	// I guess I can just wrap my own shim layer in
	// Sucks that I have to do this in each JS project that wants to use SDL ...
	// Looks like emscripten wants a canvas with id 'canvas' or something? idk
	// In my pure-lua implementation of ffi/sdl/etc I had this in SDL_CreateWindow
	canvas = Canvas({
		id : 'canvas',
		style : {
			position : 'absolute',
			userSelect : 'none',
		},

		// https://stackoverflow.com/a/55971481/2714073
		// how to stop emscripten from capturing all events
		// https://stackoverflow.com/a/46086615/2714073 -- my implementation is the eventListenrs stuff at the top, and the stuff in resetWindowListeners
		attrs : {
			tabindex : -1,
		},

		prependTo : document.body,
	});
	M.canvas = canvas;	// simple as that to make Emscripten work?  Yes but good luck resizing it.
	glappResize();


	imgui.clear();
	stdoutTA.value = '';

	// ofc you can't push extra args into the call, i guess you only can via global assignments?
	FS.chdir(rundir);
	// TODO HERE reset the Lua state altogether
	let args = [];
	try {
		args = runargs == '' ? [] : JSON.parse(runargs) || [];
	} catch (e) {
		console.log('failed to parse args as JSON:', e);
	}
	lua.doString(`
-- store Lua objects in here that will be shared across JavaScript.
-- beats writing everything to window
local luaJsScope = ...

local ffi = require 'ffi'
local js = require 'js'
local window = js.global

-- save this for use in ffi/cimgui.lua
js.imgui = luaJsScope.imgui

ffi.dataToArray = function(ctype, data, ...)
	return window:dataToArray(ctype, tonumber(ffi.cast('intptr_t', data)), ...)
end

-- this is only for redirecting errors to output
-- TODO find where in FS stderr to do this and get rid of this function
xpcall(function()

	local ffi = require 'ffi'
	function ffi.stringBuffer(s)
		local ptr = ffi.new('char[?]', #s+1)
		ffi.copy(ptr, s, #s)
		ptr[#s] = 0
		return ptr
	end

	-- TODO this in luaffifb
	local oldffistring = ffi.string
	ffi.string = function(ptr, ...)
		if type(ptr) == 'string' then return ptr end
		if ptr == nil then return '(null)' end	-- but in vanilla luajit it segfaults ...
		return oldffistring(ptr, ...)
	end

	local rundir = '`+rundir+`'
	local runfile = '`+runfile+`'
	_G.arg = {`+args.map(arg => '"'+arg+'"')+`}
	-- ok this has become the launcer of everything
	-- Lua 5.3
	-- TODO move this into main.js

	package.path = table.concat({
		'./?.lua',
		'/?.lua',
		'/?/?.lua',
	}, ';')

	bit = require 'bit'		-- provide a luajit-equivalent bit library for the Lua 5.4 operators

	-- ext.timer's getTime() uses gettimeofday because of its high resolution
	-- but emscripten craps that all the way down to the 1 second resolution
	-- so ...
	require 'ext.timer'.getTime = function()
		return js.global.Date.now() / 1000
	end

	-- emscripten's own gl / glsl versioning are so horrid that how about we patch in the getters here instead of rewriting all my gl libraries to deal with them?
	-- but if I require them then it'll do the GL version test, which I want to override ... hmm ...
	-- TODO just build my own competing wasm libraries to emscripten's

	-- set to emscripten's libpng version
	require 'image.luajit.png'.libpngVersion = '1.6.18'

	-- force emscripten to yield sometimes
	local SDLApp = require 'sdl.app'
	SDLApp.postUpdate = function()
		coroutine.yield()
	end
	require 'glapp'.postUpdate = function()
		require 'sdl'.SDL_GL_SwapWindow()
		coroutine.yield()
	end

	-- let glapp-js know when the SDL window is created, so that we can send it resize events:
	local oldSDLAppInitWindow = SDLApp.initWindow
	function SDLApp:initWindow(...)
		oldSDLAppInitWindow(self, ...)
		luaJsScope.sdlWindow = tonumber(ffi.cast('intptr_t', self.window))
		-- TODO what if it's more than 32bit ...
		-- I need a function for converting lua_touserdata / lua pointers overall to WASM addresses for just this reason.
		luaJsScope:resetWindowListeners()
	end

	local fn = '/'..rundir..'/'..runfile
	arg[0] = fn
	local __SDLMainLuaThread = coroutine.create(function()
		assert(loadfile(fn))(table.unpack(arg))
	end)

	local interval
	local function tryToResume()
		--coroutine.assertresume(__SDLMainLuaThread)
		if coroutine.status(__SDLMainLuaThread) == 'dead' then return false, 'dead' end
		local res, err = coroutine.resume(__SDLMainLuaThread)
		if not res then
			print('__SDLMainLuaThread coroutine.resume failed.')
			print(err)
			print(debug.traceback(__SDLMainLuaThread))
			luaJsScope.glappMainInterval = nil
			window:clearInterval(interval)
		end
	end

	tryToResume()

	-- set up main loop
	-- TOOD use requestAnimationFrame instead
	interval = window:setInterval(function()
		-- also in SDL_PollEvent, tho I could just route it through GLApp:update ...
		tryToResume()
	end, 10)

	luaJsScope.glappMainInterval = interval

end, function(err)
	print(err)
	print(debug.traceback())
end)
`, luaJsScope);
};

if (runfile && rundir) {

	// push initial state ...
	const newParams = new URLSearchParams();
	newParams.set('file', runfile);
	newParams.set('dir', rundir);
	newParams.set('args', runargs);
	if (editmode) newParams.set('edit', editmode);
	const url = location.origin + location.pathname + '?' + newParams.toString();
	history.pushState({
		runfile : runfile,
		rundir : rundir,
		runargs : runargs,
	}, document.title, url);

	await doRun();
}
