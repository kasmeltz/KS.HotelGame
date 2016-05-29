local Scene = require 'classes/scene/Scene'
local ColorMatchScene = Scene:extend('ColorMatchScene')

function ColorMatchScene:init(gameWorld)
	self.colorImage = love.graphics.newImage('data/images/pantone.png')
	self.matchImage = love.graphics.newImage('data/images/Orinoquiadesign.png')
	self.matchImageData = self.matchImage:getData()
	
	local colorImageData = self.colorImage:getData()

	local rectStartX = nil
	local colorBoxes = {}
	local colorLines = {}
	
	local isTransparent = true
	
	for y = 0, colorImageData:getHeight() - 1 do
		local pixelCount = 0
		for x = 0, colorImageData:getWidth() - 1 do	
			local r, g, b, a = colorImageData:getPixel(x, y)
			if a > 200 then pixelCount = pixelCount + 1 end
		end
				
		-- row with colors
		if pixelCount > 100 then
			if isTransparent then 
				colorLines[#colorLines + 1] = y + 2
				isTransparent = false
			end
		-- row without colors
		else		
			if not isTransparent then
				colorLines[#colorLines + 1] = y - 2
				isTransparent = true
			end				
		end
	end

	local startX = nil
	
	for i = 1, #colorLines, 2 do
		local startY = colorLines[i]
		local endY = colorLines[i + 1]
		
		local isTransparent = true
		for x = 0, colorImageData:getWidth() - 1 do	
			local r, g, b, a = colorImageData:getPixel(x, startY)
			-- color found			
			if a > 200 then 
				if isTransparent then
					startX = x + 2
					isTransparent = false
				end
			-- no color found
			else
				if not isTransparent then
					local box = { startX, startY, x - 2, endY }
					colorBoxes[#colorBoxes + 1] = box
					isTransparent = true
				end
			end
		end
	end
	
	for _, box in ipairs(colorBoxes) do
		local ra, ga, ba = 0, 0, 0
		local pc = 0
		for y = box[2], box[4] do
			for x = box[1], box[3] do
				local r, g, b = colorImageData:getPixel(x, y)
				ra = ra + r
				ga = ga + g
				ba = ba + b
				pc = pc + 1
			end
		end
		
		ra = ra / pc
		ga = ga / pc
		ba = ba / pc
		
		box[5] = math.floor(ra)
		box[6] = math.floor(ga)
		box[7] = math.floor(ba)
	end
				
	self.colorBoxes = colorBoxes
	self.drawMode = 'colors'
	self.selectedColorBox = nil	
	self.mouseBoxSX = nil
	self.mouseBoxSY = nil
	self.mouseBoxCX = nil
	self.mouseBoxCY = nil	
end

function ColorMatchScene:draw(dt)
	if self.drawMode == 'colors' then
		for idx, box in ipairs(self.colorBoxes) do
			if self.selectedColorBox then
				if idx == self.selectedColorBox then
					love.graphics.setColor(box[5], box[6], box[7], 255)
					love.graphics.rectangle('fill', box[1], box[2], box[3] - box[1], box[4] - box[2])
					
					love.graphics.setColor(255,255,255,255)
					love.graphics.print('Selected area: ' .. self.ra .. ', ' .. self.ga .. ', ' .. self.ba, 0, 0)
					love.graphics.print('Matched color: ' .. box[5] .. ', ' .. box[6] .. ', ' ..  box[7], 0, 60)
					
					love.graphics.setColor(self.ra,self.ga,self.ba)					
					love.graphics.rectangle('fill', 0, 15, 50, 25)
				end
			else
				love.graphics.setColor(box[5], box[6], box[7], 255)
				love.graphics.rectangle('fill', box[1], box[2], box[3] - box[1], box[4] - box[2])
			end
		end			
	end
	
	if self.drawMode == 'image' then
		love.graphics.setColor(255,255,255,255)
		love.graphics.draw(self.matchImage)	
		
		if self.mouseBoxSX and self.mouseBoxCX then
			love.graphics.setColor(255,0,0,255)
			love.graphics.rectangle('line', self.mouseBoxSX, self.mouseBoxSY, self.mouseBoxCX - self.mouseBoxSX, self.mouseBoxCY - self.mouseBoxSY)
		end
	end
end

function ColorMatchScene:update(dt)
end
function ColorMatchScene:keyreleased(key)
	if key == 'f1' then
		self.drawMode = 'colors'
	end
	
	if key == 'f2' then
		self.drawMode = 'image'
	end
	
end

function ColorMatchScene:mousepressed(x, y, button, istouch)
	if self.drawMode == 'image' then
		self.mouseBoxSX = x
		self.mouseBoxSY = y
		self.mouseBoxCX = x
		self.mouseBoxCY = y
	end	
end

function ColorMatchScene:mousemoved(x, y, button, istouch)
	if self.drawMode == 'image' then
		if self.mouseBoxSX then
			self.mouseBoxCX = x
			self.mouseBoxCY = y
		end
	end
	
end

function ColorMatchScene:mousereleased(x, y, button, istouch)
	if self.drawMode == 'image' then
		if self.mouseBoxSX and self.mouseBoxCX then
			local matchImageData = self.matchImageData			
			
			local ra, ga, ba = 0, 0, 0
			local pc = 0
			for y = self.mouseBoxSY , self.mouseBoxCY do
				for x = self.mouseBoxSX, self.mouseBoxCX do
					local r, g, b = matchImageData:getPixel(x, y)
					ra = ra + r
					ga = ga + g
					ba = ba + b
					pc = pc + 1
				end
			end
			
			ra = math.floor(ra / pc)
			ga = math.floor(ga / pc)
			ba = math.floor(ba / pc)
			
			self.ra = ra
			self.ga = ga
			self.ba = ba
			
			local closest = 99999999
			for idx, box in ipairs(self.colorBoxes) do
				local ld = -999
				local r, g, b = box[5], box[6], box[7]				
				local rd = math.abs(ra - r)
				if rd > ld then
					ld = rd
				end
				local gd = math.abs(ga - g)
				if gd > ld then
					ld = gd
				end
				local bd = math.abs(ba - b)
				if bd > ld then
					ld = bd
				end
				
				if ld < closest then
					closest = ld
					self.selectedColorBox = idx
				end
			end		
									
			self.mouseBoxSX = nil
			self.mouseBoxSY = nil
			self.mouseBoxCX = nil
			self.mouseBoxCY = nil
		end
	end
end


return ColorMatchScene
