local Scene = require 'classes/scene/Scene'
local SchmupScene = Scene:extend('SchmupScene')

--[[ 
enemy structure
1 - x position
2 - y position
3 - x direction
4 - y direction
5 - velocity
6 - collision table
7 - image

collision areas structure
index n - level of detail (each subsequent level is contained in )
each level has multiple circles equal to # / 3
i + 0 - base x position
i + 1 - base y position
i + 2 - radius
]]

function SchmupScene:init(gameWorld)
	SchmupScene.super.init(self, gameWorld) 

	self.planeX = 600
	self.planeY = 800
	love.mouse.setVisible(false)
	
	local bullets = {}
	self.bullets = bullets
	
	local enemies = {}
	self.enemies = enemies
	
	self.score = 0
	
	local images = {}
	images[1] = love.graphics.newImage('data/images/enemy1.png')
	self.images = images
	
	self:createRandomEnemy()
end

function SchmupScene:dist2(x1, y1, x2, y2)
	local dx = x1 - x2
	local dy = y1 - y2
	return dx * dx + dy * dy
end

function SchmupScene:distToSegmentSquared(px, py, x1, y1, x2, y2)
	local l2 = self:dist2(x1, y1, x2, y2)
	
	if l2 == 0 then 
		return self:dist2(px, py, x1, y1)
	end
	
	local t = ((px - x1) * (x2 - x1) + (py - y1) * (y2 - y1)) / l2
    
	if t < 0 then
		return self:dist2(px, py, x1, y1)
	end
	if t > 1 then 
		return self:dist2(px, py, x2, y2)
	end
	
	local nx = x1 + t * (x2 - x1)
	local ny = y1 + t * (y2 - y1)
	
	return self:dist2(px, py, nx, ny)
end

function SchmupScene:drawCollisionCircles(enemy)
	local epx = enemy[1]
	local epy = enemy[2]
	
	love.graphics.setColor(255, 0, 255, 255)
	
	local collisionCircles = enemy[6]
	for _, collisionLevel in ipairs(collisionCircles) do
		for i = 1, #collisionLevel, 3 do
			local bx = collisionLevel[i]
			local by = collisionLevel[i + 1]
			local r = collisionLevel[i + 2]
			local sx = bx + epx
			local sy = by + epy
			love.graphics.circle('line', sx, sy, r)
		end
	end
end

function SchmupScene:draw(dt)
	local x, y = self.planeX, self.planeY
	
	love.graphics.setColor(255,255,255,255)
	love.graphics.rectangle('fill', x, y, 50, 50)
	
	local mx, my = love.mouse.getPosition()
	
	love.graphics.setColor(255,255,0,255)
	love.graphics.line(mx + 5, my, mx + 15, my)
	love.graphics.line(mx - 15, my, mx - 5, my)
	love.graphics.line(mx, my - 5, mx, my - 15)
	love.graphics.line(mx, my + 5, mx, my + 15)

	love.graphics.setColor(255,0,255,255)	
	for _, bullet in ipairs(self.bullets) do
		love.graphics.rectangle('fill', bullet[1], bullet[2], 5, 5)
	end
	
	love.graphics.setColor(255,255,255,255)
	for _, enemy in ipairs(self.enemies) do
		local image = enemy[7]
		love.graphics.draw(image, enemy[1], enemy[2])
		self:drawCollisionCircles(enemy)
	end	
	
	love.graphics.setColor(255,255,255,255)
	love.graphics.print('Score: ', 0, 20)
	love.graphics.print(self.score, 100, 20)
	love.graphics.print('Enemies: ', 0, 40)
	love.graphics.print(#self.enemies, 100, 40)
	love.graphics.print('Bullets: ', 0, 60)
	love.graphics.print(#self.bullets, 100, 60)
	
end

function SchmupScene:hitEnemy(bullet, enemy)
	self.score = self.score + 5
	bullet.hit = true	
end

function SchmupScene:createRandomEnemy()
	local enemies = self.enemies
	--local sw = self.screenWidth
	--local x = math.random(0, sw)
	local y = 150
	--local dx = math.random(0.01, 1.99) - 1
	--local dy = math.random(0.01, 0.99)
	--local v = math.random(100,500)
	
	local x = 600
	local dx = 0
	local dy = 0
	local v = 1
		
	local collisionCircles = {}
	
	local ccl1 = {}
	ccl1 = { 28, 40, 40 }
	ccl2 = { 28, 25, 26, 28, 66, 14 }
	collisionCircles[1] = ccl1
	collisionCircles[2] = ccl2

	local enemy = { x, y, dx, dy, v, collisionCircles, self.images[1] }
	enemies[#enemies+1] = enemy
end	

function SchmupScene:checkCollision(o1, o2)
	--[[
	local l1 = 1
	local l2 = 1
	local cc1 = o1[6]
	local cc2 = o2[6]
	
	local keepChecking = true
	while keepChecking do
		local cl1 = cc1[l1]
		local cl2 = cc2[l2]
		local wasCollision = true
		for i = 1, #cl1, 3 do
			local bx = cl1[i]
			local by = cl1[i + 1]
			local r = cl1[i + 2]
			local sx = bx + epx
			local sy = by + epy
			love.graphics.circle('line', sx, sy, r)
		end
		
		keepChecking = false
	end
	
	local d = self:distToSegmentSquared(enemy[1], enemy[2], ox, oy, nx, ny)		
	if d < 25 * 25 then
		self:hitEnemy(bullet, enemy)
		--break
	end
	]]
end

function SchmupScene:update(dt)
	local sw = self.screenWidth
	local sh = self.screenHeight
	local planeX = self.planeX
	local planeY = self.planeY

	if love.keyboard.isDown('a') then
		planeX = planeX - (dt * 1000)
	end
	if love.keyboard.isDown('d') then
		planeX = planeX + (dt * 1000)
	end
	if love.keyboard.isDown('w') then
		planeY = planeY - (dt * 1000)
	end
	if love.keyboard.isDown('s') then
		planeY = planeY + (dt * 1000)
	end	
	
	if planeX < 0 then planeX = 0 end
	if planeX > sw - 50 then planeX = sw - 50 end
	if planeY < 0 then planeY = 0 end
	if planeY > sh - 50 then planeY = sh - 50 end
	
	self.planeX = planeX
	self.planeY = planeY
	
	--if math.random(0, 100) > 90 then
		--self:createRandomEnemy()
	--end
	
	for idx, enemy in ipairs(self.enemies) do
		local ox = enemy[1]
		local oy = enemy[2]
		local dv = dt * enemy[5]
		nx = ox + (enemy[3] * dv)
		ny = oy + (enemy[4] * dv)
			
		if ny > sh + 100 then
			enemy.dead = true
		end
		
		if enemy.dead then
			table.remove(self.enemies, idx)
		else
			enemy[1] = nx
			enemy[2] = ny
		end	
	end
	
	for idx, bullet in ipairs(self.bullets) do
		local ox = bullet[1]
		local oy = bullet[2]
		local dv = dt * bullet[5]
		nx = ox + (bullet[3] * dv)
		ny = oy + (bullet[4] * dv)
		
		if ny < -50 then
			bullet.hit = true
		else
			for _, enemy in ipairs(self.enemies) do
				local hit = self:checkCollision(bullet, enemy)
				if hit then 					
					self:hitEnemy(bullet, enemy)
					break
				end
			end
		end
			
		if bullet.hit then
			table.remove(self.bullets, idx)
		else
			bullet[1] = nx
			bullet[2] = ny
		end	
	end
end

function SchmupScene:createBullet(sx, sy, ex, ey, v)
	local dx = ex - sx
	local dy = ey - sy
	local d = math.sqrt(dx * dx + dy * dy)
	dx = dx / d
	dy = dy / d
	
	local collisionCircles = {}	
	local ccl1 = {}
	ccl1 = { 3, 3, 3 }
	collisionCircles[1] = ccl1
	
	return { sx, sy, dx, dy, v, collisionCircles, isBullet = true }
end

function SchmupScene:mousereleased(x, y, button, istouch)
	local bullet = self:createBullet(self.planeX + 5, self.planeY, x, y, 750)
	self.bullets[#self.bullets + 1] = bullet

	local bullet = self:createBullet(self.planeX + 45, self.planeY, x, y, 750)
	self.bullets[#self.bullets + 1] = bullet	
end

return SchmupScene