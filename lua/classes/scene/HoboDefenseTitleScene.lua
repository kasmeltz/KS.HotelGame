local FontManager = require 'classes/scene/FontManager'
FontManager = FontManager:getInstance()
local SceneManager = require 'classes/scene/SceneManager'
SceneManager = SceneManager:getInstance()

local Scene = require 'classes/scene/Scene'
local HoboDefenseTitleScene = Scene:extend('HoboDefenseTitleScene')

local Profiler = require 'classes/Profiler'
Profiler = Profiler:getInstance()

function HoboDefenseTitleScene:init(gameWorld)
	HoboDefenseTitleScene.super.init(self, gameWorld)
	
	local cv = love.graphics.newCanvas(300,100)
	love.graphics.setCanvas(cv)
	love.graphics.clear(0,0,0,0)
	local dirtyFox = FontManager:getFont('DirtyFox')
	love.graphics.setFont(dirtyFox)
	love.graphics.setColor(255, 255, 0)
	love.graphics.printf('Hobo', 0, 0, 300, 'center')
	love.graphics.printf('Tales', 0, 35, 300, 'center')
	self.hoboCanvas = cv
	love.graphics.setCanvas()	
	self.titleScale = 20
	self.decay = 0.9988
	self.timer = 0
	self.beforeStory = 9
	
	local sw = self.screenWidth
	local sh = self.screenHeight
	self.letterCanvas = love.graphics.newCanvas(sw, sh)
	
	self.lettersShader = love.graphics.newShader(
[[
	vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
	{	
		vec4 surfaceColor = vec4(0,0,0,255);
		
		number x1 = 0;
		number y1 = 900;
		number x2 = 430;
		number y2 = 275;
		number x3 = 770;
		number y3 = 275;
		number x4 = 1200;
		number y4 = 900;
		
		number px = screen_coords.x;
		number py = screen_coords.y;
		
		number py2 = log(py);
		number y12 = log(y1);
		number y22 = log(y2);
		
		number ty = (py2 - y12) / (y22 - y12);
		
		number lx1 = x1 * (1 - ty) + x2 * ty;
		number lx2 = x4 * (1 - ty) + x3 * ty;
		
		number tx = (px - lx2) / (lx1 - lx2);		
		
		surfaceColor = Texel(texture, vec2(1 - tx, 1 - ty));

		if (ty > 0.4) {
			number fy = (ty * 2) - 0.8;
			surfaceColor *= (1 - fy);
		}
		
		return surfaceColor;
	}
]])

	local vertices = 
	{
		{ 0, sh, 0, 0, 255, 255, 255, 255 },
		{ 430, 275, 0, 1, 255, 255, 255, 255 },
		{ sw, sh, 1, 1, 255, 255, 255, 255 },
		{ sw, sh, 1, 1, 255, 255, 255, 255 },
		{ sw - 430, 275, 1, 0, 255, 255, 255, 255 },
		{ 430, 275, 0, 1, 255, 255, 255, 255 },
	}
	local drawingMesh = love.graphics.newMesh(vertices, 'triangles', 'static')
	self.drawingMesh = drawingMesh	

	self.textY = sh
	self.endTextY = -3000
	
	local starCount = 250
	local stars = {}
	for i = 1, starCount do
		local star = 
		{		
			love.math.random(0, sw), love.math.random(0, sh * 2), 
			love.math.random(1,2), 
			love.math.random(200, 255), love.math.random(200, 255), love.math.random(200, 255)
		}
		stars[#stars + 1] = star
	end
	
	self.stars = stars
end

local story = {
	'Episode 3.14159265359',
	'An Unholy Alliance',
	'',
	'There is great turmoil',
	'in the Colombian city',
	'of Bogotá. The new',	
	'leader, President',
	'Peñalosa, has decided',
	'to rid the city of the',	
	'homeless.',
	'',
	'After months of',
	'struggle Peñalosa has',
	'ordered a final fatal',
	'strike against the',
	'last bastion of the',
	'hobo civilization.',
	'',
	'High on peyote,',
	'guided by his belief',
	'in an ancient hobo',
	'prophecy, Ganjadore',
	'speeds across the city',
	'in his shopping cart',
	'searching for the',
	'chosen one that can',
	'bring honor to his',
	'people...',
	'',
	'',
	'',
	'And hopefully some',
	'wicked crack too...',
}

function HoboDefenseTitleScene:drawStory()
	local sw = self.screenWidth
	local sh = self.screenHeight
	
	local font = FontManager:getFont('ArialBold92')
	love.graphics.setFont(font)
	
	love.graphics.setCanvas(self.letterCanvas)
	love.graphics.clear(0,0,0,0)
	love.graphics.setColor(255,255,0,255)
	
	local sy = self.textY
	for _, line in ipairs(story) do
		love.graphics.printf(line, 0, sy, sw, 'center')
		sy = sy + 92
	end
	
	love.graphics.setCanvas()
	
	local shader = self.lettersShader
	love.graphics.setShader(shader)			
	love.graphics.setColor(255,255,255,255)
	local drawingMesh = self.drawingMesh	
	drawingMesh:setTexture(self.letterCanvas)
	love.graphics.draw(drawingMesh)
	love.graphics.setShader()	
end

function HoboDefenseTitleScene:draw()
	local sw = self.screenWidth
	local sh = self.screenHeight
		
	local stars = self.stars
	for _, star in ipairs(stars) do
		love.graphics.setColor(star[4], star[5], star[6])
		love.graphics.circle('fill', star[1], star[2], star[3])
	end
	
	if self.timer > self.beforeStory then
		self:drawStory()
	end

	local hoboFade = 255
	if self.titleScale < 1 then
		hoboFade = hoboFade * self.titleScale
	end	
	if self.titleScale > 0.025 then
		love.graphics.setColor(hoboFade, hoboFade, hoboFade)
		love.graphics.draw(self.hoboCanvas, sw / 2, sh / 2, 0, self.titleScale, self.titleScale, 150, 50)
	end
end

function HoboDefenseTitleScene:update(dt)
	local dec = self.titleScale * self.decay * dt
	self.titleScale = self.titleScale - dec
	self.decay = self.decay - (dt * 0.2)
	self.decay = math.max(self.decay, 0.25)
	
	self.timer = self.timer + dt
	
	if self.timer > self.beforeStory then
		self.textY = self.textY - dt * 50
	end
	
	if self.textY < self.endTextY then
		SceneManager:show('towerdefense')
	end
end

return HoboDefenseTitleScene