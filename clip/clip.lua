return {
	text = function(copy)
		local js = require 'js'
		if copy then
			-- "Failed to execute 'writeText' on 'Clipboard': Document is not focused."
			-- oh and I just fix it with "await" smfh i hate javascript so much
			-- I can't put an await here without puttin an await in EVERY SINGLE INTERNAL LUA C-CODE CALL and an async on EVERY SINGLE INTERNAL LUA C-CODE FUNCTION
			js.global.navigator.clipboard:writeText(copy)
		else
			return js.global.navigator.clipboard:readText()
		end
	end,
	image = function()
		-- TODO copy/paste pics
	end,
}
