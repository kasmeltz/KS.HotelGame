local SceneManager = require 'classes/scene/SceneManager'
SceneManager = SceneManager:getInstance()
local Profiler = require 'classes/Profiler'
Profiler = Profiler:getInstance()

local Scene = require 'classes/scene/Scene'
local HoboGameScene = Scene:extend('HoboGameScene')

local path = 
{
	{ 600, -100, 0, 1 },
	{ 600, 450, 1, 1 },
	{ 900, 450, 1, 1 },
	{ 900, 600, 1, 1 },
	{ 0, 600, 1, 1 },
}
	
local enemies = 
{	
}

local towers = 
{
	{ 650, 400, 100, 0, 0.25, 250 }
}

local bullets = 
{
}

function HoboGameScene:createBullet(x, y, dx, dy, s)
	return { x, y, dx, dy, s }
end

function HoboGameScene:createEnemy()
	return { 0, 0, 100, -1, 0, 0 }
end

function HoboGameScene:init()
	HoboGameScene.super.init(self, gameWorld)
	
	self.enemyTimer = 0
end

function HoboGameScene:draw()
	love.graphics.setColor(200,200,200)
	
	local fx, fy = path[1][1], path[1][2]
	local tx, ty = nil, nil
	for i = 2, #path do
		tx, ty = path[i][1], path[i][2]

		local dx = tx - fx
		local dy = ty - fy
		
		local length = math.sqrt(dx * dx + dy * dy)
		local ny = (dx / length) * 15
		local nx = (dy / length) * 15
				
		love.graphics.line(fx - nx, fy - ny, tx - nx, ty - ny)
		love.graphics.line(fx + nx, fy + ny, tx + nx, ty + ny)
		fx, fy = path[i][1], path[i][2]
	end
	
	love.graphics.setColor(255, 0, 255)
	for i = 1, #enemies do
		local enemy = enemies[i]
		love.graphics.circle('fill', enemy[1], enemy[2], 10)
	end
		
	for i = 1, #towers do
		love.graphics.setColor(255, 255, 0)
		local tower = towers[i]
		love.graphics.circle('fill', tower[1], tower[2], 10)
		
		--[[
		if tower.targeted then
			love.graphics.setColor(255, 255, 255)
			love.graphics.circle('line', tower.targeted[1], tower.targeted[2], 15)
		end
		]]
	end
	
	love.graphics.setColor(0,255,255)
	for i = 1, #bullets do
		local bullet = bullets[i]
		love.graphics.circle('fill', bullet[1], bullet[2], 2)
	end
	
	love.graphics.print(#bullets, 0, 50)
end

function HoboGameScene:putOnPath(enemy, index)
	local currentPathNode = path[index]
	enemy[1] = currentPathNode[1]
	enemy[2] = currentPathNode[2]
	enemy[4] = index
	local nextPathNode = path[index + 1]
	
	if nextPathNode then		
		local fx, fy = currentPathNode[1], currentPathNode[2]
		local tx, ty = nextPathNode[1], nextPathNode[2]
		local dx = tx - fx
		local dy = ty - fy
		local length = math.sqrt(dx * dx + dy * dy)
		local nx = (dx / length)
		local ny = (dy / length)		
		
		enemy[5] = nx
		enemy[6] = ny
	else
		enemy[5] = nil
		enemy[6] = nil
	end
end

function HoboGameScene:length(x1, y1, x2, y2)
	local dx = x1 - x2
	local dy = y1 - y2
	return math.sqrt(dx * dx + dy * dy)
end

local bulletsToRemove = {}

function HoboGameScene:update(dt)
	local sw = self.screenWidth
	local sh = self.screenHeight
	
	for i = 1, #bulletsToRemove do
		bulletsToRemove[i] = nil
	end
	
	self.enemyTimer = self.enemyTimer + dt
	if self.enemyTimer > 1 then
		self.enemyTimer = self.enemyTimer - 1		

		local enemy = self:createEnemy()
		enemies[#enemies + 1] = enemy
	end

	for i = 1, #enemies do
		local enemy = enemies[i]
		local currentPathIndex = enemy[4]
		
		if currentPathIndex == -1 then
			currentPathIndex = 1
			self:putOnPath(enemy, 1)
		end

		local currentPathNode = path[currentPathIndex]
		local nextPathNode = path[currentPathIndex + 1]
		
		local lengthBefore = 0
		if nextPathNode then	
			local fx, fy = enemy[1], enemy[2]
			local tx, ty = nextPathNode[1], nextPathNode[2]	
			lengthBefore = self:length(fx, fy, tx, ty)
		end
		
		if enemy[5] then
			enemy[1] = enemy[1] + enemy[5] * dt * enemy[3]
			enemy[2] = enemy[2] + enemy[6] * dt * enemy[3]
		end	
	
		local lengthAfter = 0
		if nextPathNode then	
			local fx, fy = enemy[1], enemy[2]
			local tx, ty = nextPathNode[1], nextPathNode[2]	
			lengthAfter = self:length(fx, fy, tx, ty)
		end
		
		if lengthAfter > lengthBefore then
			self:putOnPath(enemy, currentPathIndex + 1)
		end
	end
	
	for i = 1, #towers do
		local tower = towers[i]
		tower[4] = tower[4] + dt
		if tower[4] > tower[5] then
			local minDistance = 9999
			local closest = nil
			
			local radius = tower[3]
			
			for j = 1, #enemies do
				local enemy = enemies[j]
				
				local d = self:length(enemy[1], enemy[2], tower[1], tower[2])
				if d < minDistance then 
					minDistance = d
					closest = enemy
				end
			end	
			
			if closest and minDistance <= radius then
				tower[4] = 0
				local bulletSpeed = tower[6]
				
				tower.targeted = closest
				
				local fx, fy = tower[1], tower[2]
				local tx, ty = closest[1], closest[2]
				local dx = tx - fx
				local dy = ty - fy
				local tvx = closest[5] * closest[3]
				local tvy = closest[6] * closest[3]
							
				local a = (tvx * tvx + tvy * tvy) - (bulletSpeed * bulletSpeed)
				local b = 2 * (dx * tvx + dy * tvy)
				local c = dx * dx + dy * dy
				
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

				local ax = tx + tvx * t
				local ay = ty + tvy * t
				
				local px = ax - fx;
				local py = ay - fy;				
				local d = self:length(fx, fy, ax, ay)
				local nx = px / d
				local ny = py / d
				
				local bullet = self:createBullet(fx, fy, nx, ny, bulletSpeed)
				bullets[#bullets + 1] = bullet	
			end
		end
	end
		
	local bulletSize = 5
	local enemySize = 10
	for i = 1, #bullets do
		local bullet = bullets[i]
		bullet[1] = bullet[1] + bullet[3] * dt * bullet[5]
		bullet[2] = bullet[2] + bullet[4] * dt * bullet[5]
		
		if 	bullet[1] < -bulletSize or 
			bullet[1] > sw + bulletSize or 
			bullet[2] < -bulletSize or 
			bullet[2] > sh + bulletSize then
			
			bulletsToRemove[#bulletsToRemove + 1] = i
		else
			local fx, fy = bullet[1], bullet[2]
			
			for j = 1, #enemies do
				local enemy = enemies[j]			
				local tx, ty = enemy[1], enemy[2]
				local d = self:length(fx, fy, tx, ty)
				if d < bulletSize + enemySize then
					bulletsToRemove[#bulletsToRemove + 1] = i
					break
				end
			end						
		end
	end	
	
	for i = #bulletsToRemove, 1, -1 do
		local idx = bulletsToRemove[i]
		table.remove(bullets, idx)
	end
end

return HoboGameScene