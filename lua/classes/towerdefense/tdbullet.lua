local class = require 'libs/30log/30log'
local TDBullet = class('TDBullet')

local FFIVector2 = require 'classes/math/FFIVector2'

--
-- Creates a new Tower Defense bullet
--
function TDBullet:init(gw, x, y, vx, vy, speed, damage)
	self.gameWorld = gw
	self.position = FFIVector2.newVector()
	self.position.X = x
	self.position.Y = y	
	self.velocity = FFIVector2.newVector()
	self.velocity.X = vx
	self.velocity.Y = vy	
	self.speed = speed
	self.damage = damage
end

return TDBullet