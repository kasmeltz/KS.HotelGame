local Scene = require 'classes/scene/Scene'
local PlatformerGameScene = Scene:extend('PlatformerGameScene')
local FFIVector2 = require 'classes/math/FFIVector2'

local SceneManager = require 'classes/scene/SceneManager'
SceneManager = SceneManager:getInstance()
local Profiler = require 'classes/Profiler'
Profiler = Profiler:getInstance()

local PFEntity = require 'classes/Platformer/pfentity'

function PlatformerGameScene:createPlatform(x1, y1, x2, y2)
	local p = {}
	
	local p1 = FFIVector2.newVector()
	local p2 = FFIVector2.newVector()
	p1.X = x1
	p1.Y = y1
	p2.X = x2
	p2.Y = y2
	
	p[1] = p1
	p[2] = p2
	
	return p
end

function PlatformerGameScene:createHero()
	local hero = PFEntity:new(self.gameWorld, 300, 100, 10)
	hero.state = PFEntity.FALLING_STATE
	self.hero = hero	
end

function PlatformerGameScene:init(gameWorld)
	PlatformerGameScene.super.init(self, gameWorld)	

	gameWorld.gravityCoefficient = 8
	
	local platforms = 
	{
		self:createPlatform(200, 300, 400, 300), 
		self:createPlatform(475, 300, 700, 300),
		self:createPlatform(200, 400, 400, 500), 
		self:createPlatform(475, 400, 700, 500),
		self:createPlatform(200, 550, 400, 800), 
		self:createPlatform(475, 550, 700, 800)
	}
	self.platforms = platforms
	
	self:createHero()
	
	self.workVector = FFIVector2.newVector()
	self.downVector = FFIVector2.newVector()
end

function PlatformerGameScene:draw()	
	local platforms = self.platforms
	
	for _, platform in ipairs(platforms) do
		local sx = platform[1].X
		local sy = platform[1].Y
		local ex = platform[2].X
		local ey = platform[2].Y
		
		love.graphics.line(sx, sy, ex, ey)
	end	
	
	local hero = self.hero
	love.graphics.setColor(200, 200, 100)
	love.graphics.circle('fill', hero.position.X, hero.position.Y, hero.radius)
end
					
function PlatformerGameScene:update(dt)
	local hero = self.hero
	local workVector = self.workVector
	local downVector = self.downVector

	hero.velocity.X = 0
	
	if love.keyboard.isDown('left') then
		hero.velocity.X = -150
	end

	if love.keyboard.isDown('right') then
		hero.velocity.X = 150
	end
	
	hero:update(dt)
	
	if hero.state == PFEntity.FALLING_STATE then
		downVector.X = hero.position.X
		downVector.Y = hero.position.Y + hero.radius + 1

		local platforms = self.platforms	
		for _, platform in ipairs(platforms) do
			FFIVector2.intersectInline(workVector, hero.oldPosition, downVector, platform[1], platform[2])
			if (workVector.X ~= -1 and workVector.Y ~= -1) then
				hero:changeState(PFEntity.ON_PLATFORM_STATE)
				hero.position.Y = workVector.Y - hero.radius
			end			
		end
	end
	
	if hero.state == PFEntity.ON_PLATFORM_STATE then
		downVector.X = hero.position.X
		downVector.Y = hero.position.Y + hero.radius + 1
		
		local isStillOn = false
		local platforms = self.platforms	
		for _, platform in ipairs(platforms) do
			FFIVector2.intersectInline(workVector, hero.position, downVector, platform[1], platform[2])
			if (workVector.X ~= -1 and workVector.Y ~= -1) then
				isStillOn = true
				hero.position.Y = workVector.Y - hero.radius
			end			
		end
		
		if not isStillOn then
			hero:changeState(PFEntity.FALLING_STATE)
		end
	end	
end

function PlatformerGameScene:keypressed(key) 
	if key == 'lctrl' then
		self.hero:changeState(PFEntity.JUMPING_STATE)	
	end
	
	if key == 'f1' then
		self:createHero()
	end
end

return PlatformerGameScene