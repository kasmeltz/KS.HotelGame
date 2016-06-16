local class = require 'libs/30log/30log'
local TDEnemy = class('TDEnemy')

local FFIVector2 = require 'classes/math/FFIVector2'

--
-- Creates a new Tower Defense enemy
--
function TDEnemy:init(gw, x, y, speed, mh, cp)
	self.gameWorld = gw
	self.position = FFIVector2.newVector()
	self.position.X = x
	self.position.Y = y	
	self.velocity = FFIVector2.newVector()
	self.speed = speed
	self.maxHealth = mh
	self.health = mh
	self.currentPath = cp
end

return TDEnemy