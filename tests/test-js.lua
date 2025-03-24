#!/usr/bin/env luajit
--[[
print sdl/js events while they happen
--]]
local table = require 'ext.table'
local string = require 'ext.string'
local op = require 'ext.op'
local sdl = require 'ffi.req' 'sdl'

-- https://wiki.libsdl.org/SDL2/SDL_Event
local eventInfo = {}
for names,field in pairs{
['SDL_AUDIODEVICEADDED SDL_AUDIODEVICEREMOVED'] = 'adevice',
['SDL_CONTROLLERAXISMOTION'] = 'caxis',
['SDL_CONTROLLERBUTTONDOWN SDL_CONTROLLERBUTTONUP'] = 'cbutton',
['SDL_CONTROLLERDEVICEADDED SDL_CONTROLLERDEVICEREMOVED SDL_CONTROLLERDEVICEREMAPPED'] = 'cdevice',
['SDL_DOLLARGESTURE SDL_DOLLARRECORD'] = 'dgesture',
['SDL_DROPFILE SDL_DROPTEXT SDL_DROPBEGIN SDL_DROPCOMPLETE'] = 'drop',
['SDL_FINGERMOTION SDL_FINGERDOWN SDL_FINGERUP'] = 'tfinger',
['SDL_KEYDOWN SDL_KEYUP'] = 'key',
['SDL_JOYAXISMOTION'] = 'jaxis',
['SDL_JOYBALLMOTION'] = 'jball',
['SDL_JOYHATMOTION'] = 'jhat',
['SDL_JOYBUTTONDOWN SDL_JOYBUTTONUP'] = 'jbutton',
['SDL_JOYDEVICEADDED SDL_JOYDEVICEREMOVED'] = 'jdevice',
['SDL_MOUSEMOTION'] = 'motion',
['SDL_MOUSEBUTTONDOWN SDL_MOUSEBUTTONUP'] = 'button',
['SDL_MOUSEWHEEL'] = 'wheel',
['SDL_MULTIGESTURE'] = 'mgesture',
['SDL_QUIT'] = 'quit',
['SDL_SYSWMEVENT'] = 'syswm',
['SDL_TEXTEDITING'] = 'edit',
['SDL_TEXTEDITING_EXT'] = 'editExt',
['SDL_TEXTINPUT'] = 'text',
['SDL_USEREVENT'] = 'user',
['SDL_WINDOWEVENT'] = 'window',
} do
	for name in names:gmatch'%S+' do
		local i = sdl[name]
		eventInfo[i] = {
			name = name,
			value = i,
			field = field,
		}
	end
end

for typename,fields in pairs{
	SDL_CommonEvent = {'type', 'timestamp'},
	SDL_DisplayEvent = {'type', 'timestamp', 'display', 'event', 'padding1', 'padding2', 'padding3', 'data1'},
	SDL_WindowEvent = {'type', 'timestamp', 'windowID', 'event', 'padding1', 'padding2', 'padding3', 'data1', 'data2'},
	SDL_KeyboardEvent = {'type', 'timestamp', 'windowID', 'state', 'repeat', 'padding2', 'padding3', 'keysym'},
	SDL_TextEditingEvent = {'type', 'timestamp', 'windowID', 'text', 'start', 'length'},
	SDL_TextEditingExtEvent = {'type', 'timestamp', 'windowID', 'text', 'start', 'length'},
	SDL_TextInputEvent = {'type', 'timestamp', 'windowID', 'text'},
	SDL_MouseMotionEvent = {'type', 'timestamp', 'windowID', 'which', 'state', 'x', 'y', 'xrel', 'yrel'},
	SDL_MouseButtonEvent = {'type', 'timestamp', 'windowID', 'which', 'button', 'state', 'clicks', 'padding1', 'x', 'y'},
	SDL_MouseWheelEvent = {'type', 'timestamp', 'windowID', 'which', 'x', 'y', 'direction', 'preciseX', 'preciseY', 'mouseX', 'mouseY'},
	SDL_JoyAxisEvent = {'type', 'timestamp', 'which', 'axis', 'padding1', 'padding2', 'padding3', 'value', 'padding4'},
	SDL_JoyBallEvent = {'type', 'timestamp', 'which', 'ball', 'padding1', 'padding2', 'padding3', 'xrel', 'yrel'},
	SDL_JoyHatEvent = {'type', 'timestamp', 'which', 'hat', 'value', 'padding1', 'padding2'},
	SDL_JoyButtonEvent = {'type', 'timestamp', 'which', 'button', 'state', 'padding1', 'padding2'},
	SDL_JoyDeviceEvent = {'type', 'timestamp', 'which'},
	SDL_JoyBatteryEvent = {'type', 'timestamp', 'which', 'level'},
	SDL_ControllerAxisEvent = {'type', 'timestamp', 'which', 'axis', 'padding1', 'padding2', 'padding3', 'value', 'padding4'},
	SDL_ControllerButtonEvent = {'type', 'timestamp', 'which', 'button', 'state', 'padding1', 'padding2'},
	SDL_ControllerDeviceEvent = {'type', 'timestamp', 'which'},
	SDL_ControllerTouchpadEvent = {'type', 'timestamp', 'which', 'touchpad', 'finger', 'x', 'y', 'pressure'},
	SDL_ControllerSensorEvent = {'type', 'timestamp', 'which', 'sensor', 'data', 'timestamp_us'},
	SDL_AudioDeviceEvent = {'type', 'timestamp', 'which', 'iscapture', 'padding1', 'padding2', 'padding3'},
	SDL_TouchFingerEvent = {'type', 'timestamp', 'touchId', 'fingerId', 'x', 'y', 'dx', 'dy', 'pressure', 'windowID'},
	SDL_MultiGestureEvent = {'type', 'timestamp', 'touchId', 'dTheta', 'dDist', 'x', 'y', 'numFingers', 'padding'},
	SDL_DollarGestureEvent = {'type', 'timestamp', 'touchId', 'gestureId', 'numFingers', 'error', 'x', 'y'},
	SDL_DropEvent = {'type', 'timestamp', 'file', 'windowID'},
	SDL_SensorEvent = {'type', 'timestamp', 'which', 'data', 'timestamp_us'},
	SDL_QuitEvent = {'type', 'timestamp'},
	SDL_OSEvent = {'type', 'timestamp'},
	SDL_UserEvent = {'type', 'timestamp', 'windowID', 'code', 'data1', 'data2'},
	SDL_SysWMEvent = {'type', 'timestamp', 'msg'},
} do
	ffi.metatype(typename, {
		__tostring = function(self)
			local s = table()
			for _,field in ipairs(fields) do
				local result, err = op.safeindex(self, field)
				if err then
					result = 'error: '..tostring(err)
				else
					result = tostring(result)
				end
				s:insert(tostring(field)..'='..result)
			end
			return s:concat', '
		end,
		__concat = string.concat,
	})
end

-- add js callbacks here to match those in ffi.sdl
local window = require 'js'.global
window:eval[[
['keyup', 'keydown', 'contextmenu', 'mousemove', 'mousedown', 'mouseup', 'touchstart', 'touchmove', 'touchend', 'touchcancel']
.forEach(k => window.addEventListener(k, e => console.log(e)));
]]

return require 'glapp':subclass{
	event = function(self, e)
		local info = eventInfo[e.type]
		if info then
			print(info.name, e[info.field])
		else
			print(e.type)
		end
	end,
}():run()
