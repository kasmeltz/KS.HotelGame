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
	hero.jumpForce = 650
	self.hero = hero	
end

function PlatformerGameScene:init(gameWorld)
	PlatformerGameScene.super.init(self, gameWorld)	

	gameWorld.gravityCoefficient = 1300
	
	local platforms = 
	{
		self:createPlatform(200, 200, 400, 250), 
		self:createPlatform(475, 200, 700, 250),
		self:createPlatform(200, 300, 400, 450), 
		self:createPlatform(475, 300, 700, 450),
		self:createPlatform(200, 450, 400, 750), 
		self:createPlatform(475, 450, 700, 750),
		self:createPlatform(800, 750, 1000, 550)

	}
	self.platforms = platforms
	
	self:createHero()
	
	self.workVector = FFIVector2.newVector()
	self.downVector = FFIVector2.newVector()
	
	self.spriteSheet = love.graphics.newImage('data/images/fighter.png')
	local width = self.spriteSheet:getWidth()
	local height = self.spriteSheet:getHeight()
	self.tile = love.graphics.newQuad(0, 0, 65, 74, width, height)
end

function PlatformerGameScene:draw()	
	local sw = self.screenWidth
	local sh = self.screenHeight
	
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
	love.graphics.draw(self.spriteSheet, self.tile, hero.position.X - 37, hero.position.Y - 68)
end

function PlatformerGameScene:checkEntityIsOnPlatform(entity, platform)
	local workVector = self.workVector
	local downVector = self.downVector
	local minY = 10000
	local distanceDown = entity.radius + 0.5
	
	downVector.X = entity.position.X 
	downVector.Y = entity.position.Y + distanceDown
	FFIVector2.intersectInline(workVector, entity.oldPosition, downVector, platform[1], platform[2])
	if (workVector.X ~= -1 and workVector.Y ~= -1) then
		if workVector.Y < minY then
			minY = workVector.Y
		end
	end
	downVector.X = entity.position.X - entity.radius
	downVector.Y = entity.position.Y + distanceDown
	FFIVector2.intersectInline(workVector, entity.oldPosition, downVector, platform[1], platform[2])
	if (workVector.X ~= -1 and workVector.Y ~= -1) then
		if workVector.Y < minY then
			minY = workVector.Y
		end
	end
	downVector.X = entity.position.X + entity.radius
	downVector.Y = entity.position.Y + distanceDown
	FFIVector2.intersectInline(workVector, entity.oldPosition, downVector, platform[1], platform[2])
	if (workVector.X ~= -1 and workVector.Y ~= -1) then
		if workVector.Y < minY then
			minY = workVector.Y
		end	
	end
	
	if minY < 10000 then
		return minY
	else
		return nil
	end
end
					
function PlatformerGameScene:update(dt)
	local hero = self.hero

	hero.velocity.X = 0
	
	if love.keyboard.isDown('left') then
		hero.velocity.X = -150
	end

	if love.keyboard.isDown('right') then
		hero.velocity.X = 150
	end
	
	local steps = 25
	local stepDt = dt / steps
	
	for i = 1, steps do 
		hero:update(stepDt)
		
		if hero.state == PFEntity.FALLING_STATE then		
			local platforms = self.platforms	
			for _, platform in ipairs(platforms) do
				local yIntersect = self:checkEntityIsOnPlatform(hero, platform)
				if yIntersect then
					hero:changeState(PFEntity.ON_PLATFORM_STATE)
					hero.position.Y = yIntersect - hero.radius
				end
			end
		end
		
		if hero.state == PFEntity.ON_PLATFORM_STATE then		
			local isStillOn = false
			local platforms = self.platforms	
			for _, platform in ipairs(platforms) do
				local yIntersect = self:checkEntityIsOnPlatform(hero, platform)
				if yIntersect then
					isStillOn = true
					hero.position.Y = yIntersect - hero.radius
				end
			end
			
			if not isStillOn then
				hero:changeState(PFEntity.FALLING_STATE)
			end
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