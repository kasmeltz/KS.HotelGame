local Scene = require 'classes/scene/Scene'
local HoboGameScene = Scene:extend('HoboGameScene')

local SceneManager = require 'classes/scene/SceneManager'
SceneManager = SceneManager:getInstance()
local Profiler = require 'classes/Profiler'
Profiler = Profiler:getInstance()
local FFIVector2 = require 'classes/math/FFIVector2'
FFIVector2 = FFIVector2:getInstance()

local TDEnemy = require 'classes/towerdefense/TDEnemy'
local TDTower = require 'classes/towerdefense/TDTower'
local TDBullet = require 'classes/towerdefense/TDBullet'
local TDPath = require 'classes/towerdefense/TDPath'

function HoboGameScene:init()
	HoboGameScene.super.init(self, gameWorld)
	
	self.enemyTimer = 0
	
	self.paths = {}
	self.paths[#self.paths + 1] = TDPath:new(self.gameWorld, 600, -100)
	self.paths[#self.paths + 1] = TDPath:new(self.gameWorld, 600, 450)
	self.paths[#self.paths + 1] = TDPath:new(self.gameWorld, 900, 450)
	self.paths[#self.paths + 1] = TDPath:new(self.gameWorld, 900, 600)
	self.paths[#self.paths + 1] = TDPath:new(self.gameWorld, 0, 600)
	
	self.towers = {}
	self.towers[#self.towers + 1] = TDTower:new(self.gameWorld, 650, 400, 100, 0.3, 200, 15)
	self.towers[#self.towers + 1] = TDTower:new(self.gameWorld, 550, 450, 100, 0.3, 200, 15)
	self.towers[#self.towers + 1] = TDTower:new(self.gameWorld, 650, 500, 100, 0.3, 200, 15)
			
	self.bullets = {}
	
	self.enemies = {}
	
	self.bulletsToRemove = {}
	self.enemiesToRemove = {}
	
	self.pathNormal = FFIVector2.newVector()
	self.vector1 = FFIVector2.newVector()
	self.vector2 = FFIVector2.newVector()
end

function HoboGameScene:draw()
	local paths = self.paths
	local enemies = self.enemies	
	local towers = self.towers
	local bullets = self.bullets
	
	local pathNormal = self.pathNormal
	
	love.graphics.setColor(200,200,200)
		
	local from = paths[1].position
	local to = nil
	for i = 2, #paths do
		local path = paths[i]
		to = path.position		
		FFIVector2.subtractInline(pathNormal, to, from)
		FFIVector2.normalizeInline(pathNormal, pathNormal)
		local x = pathNormal.X
		pathNormal.X = pathNormal.Y
		pathNormal.Y = x
		FFIVector2.scalarMultiplyInline(pathNormal, pathNormal, 15)			
		love.graphics.line(from.X - pathNormal.X, from.Y - pathNormal.Y, to.X - pathNormal.X, to.Y - pathNormal.Y)
		love.graphics.line(from.X + pathNormal.X, from.Y + pathNormal.Y, to.X + pathNormal.X, to.Y + pathNormal.Y)
		from = path.position
	end
		
	local barWidth = 30
	local barWidth2 = barWidth / 2
	local innerBarWidth = barWidth - 2
	local innerBarWidth2 = barWidth2 - 1

	for i = 1, #enemies do
		local enemy = enemies[i]
		
		love.graphics.setColor(255, 0, 255)
		love.graphics.circle('fill', enemy.position.X, enemy.position.Y, 10)
		
		local ratio = enemy.health / enemy.maxHealth
		love.graphics.setColor(0,255,0)
		love.graphics.rectangle('line', enemy.position.X - barWidth2, enemy.position.Y - 17, barWidth, 5)
		love.graphics.setColor(0,128,0)
		love.graphics.rectangle('fill', enemy.position.X - innerBarWidth2, enemy.position.Y - 17, ratio * innerBarWidth, 5)
	end
		
	for i = 1, #towers do
		love.graphics.setColor(255, 255, 0)
		local tower = towers[i]
		love.graphics.circle('fill', tower.position.X, tower.position.Y, 10)
		
		--[[
		if tower.targeted then
			love.graphics.setColor(255, 255, 255)
			love.graphics.circle('line', tower.targeted.position.X, tower.targeted.position.Y, 15)
		end
		]]
	end
	
	love.graphics.setColor(0,255,255)
	for i = 1, #bullets do
		local bullet = bullets[i]
		love.graphics.circle('fill', bullet.position.X, bullet.position.Y, 2)
	end
end

function HoboGameScene:putOnPath(enemy, index)
	local paths = self.paths
	local pathNormal = self.pathNormal
	local currentPathNode = paths[index]
	enemy.position = FFIVector2.copyInline(enemy.position, currentPathNode.position)
	enemy.currentPath = index
	local nextPathNode = paths[index + 1]
	
	if nextPathNode then	
		local from = currentPathNode.position
		local to = nextPathNode.position
		FFIVector2.subtractInline(pathNormal, to, from)
		FFIVector2.normalizeInline(pathNormal, pathNormal)
		
		enemy.velocity = FFIVector2.copyInline(enemy.velocity, pathNormal)
	else
		enemy.velocity.X = 0
		enemy.velocity.Y = 0
	end
end

function HoboGameScene:hitEnemy(enemy, bullet)
	enemy.health = enemy.health - bullet.damage
	if enemy.health <= 0 then 
		return true
	end
end
					
function HoboGameScene:update(dt)
	local enemies = self.enemies
	local paths = self.paths
	local towers = self.towers
	local bullets = self.bullets
	local bulletsToRemove = self.bulletsToRemove
	local enemiesToRemove = self.enemiesToRemove
	
	local vector1 = self.vector1
	local vector2 = self.vector2

	local sw = self.screenWidth
	local sh = self.screenHeight
	
	for i = 1, #bulletsToRemove do
		bulletsToRemove[i] = nil
	end
	
	for i = 1, #enemiesToRemove do
		enemiesToRemove[i] = nil
	end
	
	self.enemyTimer = self.enemyTimer + dt
	if self.enemyTimer > 1 then
		self.enemyTimer = self.enemyTimer - 1		
		local enemy = TDEnemy:new(self.gameWorld, 0, -100, 100, 100, -1)
		enemies[#enemies + 1] = enemy
	end

	for i = 1, #enemies do
		local enemy = enemies[i]
		local currentPathIndex = enemy.currentPath
		
		if currentPathIndex == -1 then
			currentPathIndex = 1
			self:putOnPath(enemy, 1)
		end

		local currentPathNode = paths[currentPathIndex]
		local nextPathNode = paths[currentPathIndex + 1]
		
		local lengthBefore = 0
		if nextPathNode then	
			lengthBefore = FFIVector2.distanceSquared(enemy.position, nextPathNode.position)
		end
		
		FFIVector2.scalarMultiplyInline(vector1, enemy.velocity, enemy.speed)
		FFIVector2.scalarMultiplyInline(vector1, vector1, dt)
		FFIVector2.addInline(enemy.position, enemy.position, vector1)

		local lengthAfter = 0
		if nextPathNode then	
			lengthAfter = FFIVector2.distanceSquared(enemy.position, nextPathNode.position)
		end
					
		if lengthAfter > lengthBefore then
			self:putOnPath(enemy, currentPathIndex + 1)
		end
	end
	
	for i = 1, #towers do
		local tower = towers[i]
		tower.firingTimer = tower.firingTimer + dt
		if tower.firingTimer > tower.firingRate then
			local minDistance = 9999
			local closest = nil
			
			local radius = tower.radius
			
			for j = 1, #enemies do
				local enemy = enemies[j]
				local d = FFIVector2.distance(enemy.position, tower.position)
				if d < minDistance then 
					minDistance = d
					closest = enemy
				end
			end	
			
			if closest and minDistance <= radius then
				tower.firingTimer = 0
				local bulletSpeed = tower.bulletSpeed
				
				tower.targeted = closest
				
				local from = tower.position
				local to = closest.position
				FFIVector2.subtractInline(vector1, to, from)
				FFIVector2.scalarMultiplyInline(vector2, closest.velocity, closest.speed)
							
				local a = FFIVector2.dot(vector2, vector2) - (bulletSpeed * bulletSpeed)
				local b = 2 * FFIVector2.dot(vector1, vector2)
				local c = FFIVector2.dot(vector1, vector1)
				
				local p = -b / (2 * a);
				local q = math.sqrt((b * b) - 4 * a * c) / (2 * a);
				
				local t1 = p - q;
				local t2 = p + q;
				local t;

				if t1 > t2 and t2 > 0 then
					t = t2;
				else
					t = t1;
				end
				
				FFIVector2.scalarMultiplyInline(vector2, vector2, t)
				FFIVector2.addInline(vector1, vector2, to)
				FFIVector2.subtractInline(vector1, vector1, from)
				FFIVector2.normalizeInline(vector1, vector1)
		
				local bullet = TDBullet:new(self.gameWorld, from.X, from.Y, vector1.X, vector1.Y, bulletSpeed, tower.damage)
				bullets[#bullets + 1] = bullet					
			end
		end
	end
		
	local bulletSize = 5
	local hitSize = 15
	for i = 1, #bullets do
		local bullet = bullets[i]
		FFIVector2.scalarMultiplyInline(vector1, bullet.velocity, bullet.speed)
		FFIVector2.scalarMultiplyInline(vector1, vector1, dt)
		FFIVector2.addInline(bullet.position, bullet.position, vector1)
		
		if 	bullet.position.X < -bulletSize or 
			bullet.position.X > sw + bulletSize or 
			bullet.position.Y < -bulletSize or 
			bullet.position.Y > sh + bulletSize then
			
			bulletsToRemove[#bulletsToRemove + 1] = i
		else
			for j = 1, #enemies do
				local enemy = enemies[j]	
				local d = FFIVector2.distance(enemy.position, bullet.position)
				if d < hitSize then
					bulletsToRemove[#bulletsToRemove + 1] = i
					if self:hitEnemy(enemy, bullet) then
						enemiesToRemove[#enemiesToRemove + 1] = j
					end
					break
				end
			end		
		end
	end	
	
	for i = #bulletsToRemove, 1, -1 do
		local idx = bulletsToRemove[i]
		table.remove(bullets, idx)
	end
	
	for i = #enemiesToRemove, 1, -1 do
		local idx = enemiesToRemove[i]
		table.remove(enemies, idx)
	end
end

return HoboGameScene