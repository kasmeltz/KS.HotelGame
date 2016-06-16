local class = require 'libs/30log/30log'
local TDPath = class('TDPath')

local FFIVector2 = require 'classes/math/FFIVector2'

--
-- Creates a new Tower Defense path
--
function TDPath:init(gw, x, y)
	self.gameWorld = gw
	self.position = FFIVector2.newVector()
	self.position.X = x
	self.position.Y = y
end

return TDPath