local Scene = require 'classes/scene/Scene'
local SchmupScene = Scene:extend('SchmupScene')

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
	
	for _, enemy in ipairs(self.enemies) do
		love.graphics.setColor(255,0,0,255)
		love.graphics.circle('fill', enemy[1], enemy[2], 25)
	end	
	
	love.graphics.setColor(255,255,255,255)
	love.graphics.print('Score: ', 0, 20)
	love.graphics.print(self.score, 100, 20)
end

function SchmupScene:hitEnemy(bullet, enemy)
	self.score = self.score + 5
	bullet.hit = true	
end

function SchmupScene:createRandomEnemy()
	local enemies = self.enemies
	local sw = self.screenWidth
	local x = math.random(0, sw)
	local dx = math.random(0, 2) - 1
	local dy = math.random(0, 1)
	local v = math.random(100,500)
	local enemy = { x, -50, dx, dy, v }
	enemies[#enemies+1] = enemy		
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
	
	if math.random(0, 100) > 99 then
		self:createRandomEnemy()
	end
	
	for idx, enemy in ipairs(self.enemies) do
		local ox = enemy[1]
		local oy = enemy[2]
		local dv = dt * enemy[5]
		nx = ox + (enemy[3] * dv)
		ny = oy + (enemy[4] * dv)
		
		enemy[1] = nx
		enemy[2] = ny
	end
	
	for idx, bullet in ipairs(self.bullets) do
		local ox = bullet[1]
		local oy = bullet[2]
		local dv = dt * bullet[5]
		nx = ox + (bullet[3] * dv)
		ny = oy + (bullet[4] * dv)
		
		for _, enemy in ipairs(self.enemies) do
			local d = self:distToSegmentSquared(enemy[1], enemy[2], ox, oy, nx, ny)		
			if d < 25 * 25 then
				self:hitEnemy(bullet, enemy)
				break
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
	
	return { sx, sy, dx, dy, v }
end

function SchmupScene:mousereleased(x, y, button, istouch)
	local bullet = self:createBullet(self.planeX + 5, self.planeY, x, y, 750)
	self.bullets[#self.bullets + 1] = bullet

	local bullet = self:createBullet(self.planeX + 45, self.planeY, x, y, 750)
	self.bullets[#self.bullets + 1] = bullet	
end

return SchmupScene
