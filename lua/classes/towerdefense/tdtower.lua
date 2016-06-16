local class = require 'libs/30log/30log'
local TDTower = class('TDTower')

local FFIVector2 = require 'classes/math/FFIVector2'

--
-- Creates a new Tower Defense tower
--
function TDTower:init(gw, x, y, radius, firingRate, bulletSpeed, damage)
	self.gameWorld = gw
	self.position = FFIVector2.newVector()
	self.position.X = x
	self.position.Y = y	
	self.radius = radius
	self.firingRate = firingRate
	self.firingTimer = 0
	self.bulletSpeed = bulletSpeed
	self.damage = damage
end

return TDTower