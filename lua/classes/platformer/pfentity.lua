local class = require 'libs/30log/30log'
local PFEntity = class('PFEntity')

local FFIVector2 = require 'classes/math/FFIVector2'

PFEntity.FALLING_STATE = 1
PFEntity.JUMPING_STATE = 2
PFEntity.ON_PLATFORM_STATE = 3

--
-- Creates a new Platformer entity
--
function PFEntity:init(gw, x, y, radius)
	self.gameWorld = gw
	self.position = FFIVector2.newVector()
	self.position.X = x
	self.position.Y = y	
	self.velocity = FFIVector2.newVector()
	self.velocity.X = 0
	self.velocity.Y = 0
	self.radius = radius
	
	self.oldPosition = FFIVector2.newVector()
end

--
-- PFEntity:changeState(sta
--
function PFEntity:changeState(state)
	local currentState = self.state
	
	if state == PFEntity.ON_PLATFORM_STATE then
		if currentState == PFEntity.FALLING_STATE then
			self.state = PFEntity.ON_PLATFORM_STATE
			self.velocity.Y = 0
			self.velocity.X = 0
		end
	end
	
	if state == PFEntity.FALLING_STATE then
		self.state = PFEntity.FALLING_STATE
	end
	
	if state == PFEntity.JUMPING_STATE then
		if currentState == PFEntity.ON_PLATFORM_STATE then
			self.velocity.Y = -self.jumpForce
			self.state = PFEntity.JUMPING_STATE
		end
	end
end

--
-- Updates the entity
--
function PFEntity:update(dt)
	local gravity = self.gameWorld.gravityCoefficient	
	local pos = self.position
	local vel = self.velocity
	local oldPos = self.oldPosition
	
	-- FALLING
	if self.state == PFEntity.FALLING_STATE then
		vel.Y = vel.Y + gravity * dt
	end
	
	if self.state == PFEntity.JUMPING_STATE then
		vel.Y = vel.Y + gravity * dt
		if vel.Y > 0 then
			self:changeState(PFEntity.FALLING_STATE)
		end
	end
	
	oldPos.X = pos.X
	oldPos.Y = pos.Y
		
	pos.X = pos.X + vel.X * dt
	pos.Y = pos.Y + vel.Y * dt
end

return PFEntity