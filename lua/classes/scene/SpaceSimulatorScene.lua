local Scene = require 'classes/scene/Scene'
local SpaceSimulatorScene = Scene:extend('SpaceSimulatorScene')
local Matrix = require 'classes/math/Matrix'
local FFIMatrix = require 'classes/math/FFIMatrix'

function SpaceSimulatorScene:init(gameWorld)
	SpaceSimulatorScene.super.init(self, gameWorld)

	print('=========================')
	print(' OLD AND BUSTED')
	local a = Matrix:new{{8,3}, {2,4}, {3,6}}
	local b = Matrix:new{{1,2,3},{4,6,8}}
	
	a:display()
	b:display()
	
	local r = a * b
	r:display()
	
	local r = a * 10
	r:display()
	
	local r = a + 10
	r:display()
	
	local c = Matrix:new{{1,2}, {3,4}, {5,6}}
	local r = a + c
	r:display()
	
	print('=========================')
	print(' SHINY NEW HOTNESS')
	
	local ffiA = FFIMatrix.newMatrix(3, 2)
	local ffiB = FFIMatrix.newMatrix(2, 3)
	
	FFIMatrix.setValue(ffiA, 0, 0, 8)
	FFIMatrix.setValue(ffiA, 0, 1, 3)
	FFIMatrix.setValue(ffiA, 1, 0, 2)
	FFIMatrix.setValue(ffiA, 1, 1, 4)
	FFIMatrix.setValue(ffiA, 2, 0, 3)
	FFIMatrix.setValue(ffiA, 2, 1, 6)	
	FFIMatrix.display(ffiA)
	
	FFIMatrix.setValue(ffiB, 0, 0, 1)
	FFIMatrix.setValue(ffiB, 0, 1, 2)
	FFIMatrix.setValue(ffiB, 0, 2, 3)
	FFIMatrix.setValue(ffiB, 1, 0, 4)
	FFIMatrix.setValue(ffiB, 1, 1, 6)
	FFIMatrix.setValue(ffiB, 1, 2, 8)	
	FFIMatrix.display(ffiB)

	local r = FFIMatrix.scalarMultiply(ffiA, 10)
	FFIMatrix.display(r)
	
	local r = FFIMatrix.multiply(ffiA, ffiB)
	FFIMatrix.display(r)
	
	local r = FFIMatrix.scalarAdd(ffiA, 10)
	FFIMatrix.display(r)
	
	local ffiC = FFIMatrix.newMatrix(3,2)
	FFIMatrix.setValue(ffiC, 0, 0, 1)
	FFIMatrix.setValue(ffiC, 0, 1, 2)
	FFIMatrix.setValue(ffiC, 1, 0, 3)
	FFIMatrix.setValue(ffiC, 1, 1, 4)
	FFIMatrix.setValue(ffiC, 2, 0, 5)
	FFIMatrix.setValue(ffiC, 2, 1, 6)	
	FFIMatrix.display(ffiC)
	
	local r = FFIMatrix.add(ffiA, ffiC)
	FFIMatrix.display(r)
	
	FFIMatrix.scalarMultiplyInline(ffiA, 10)
	FFIMatrix.display(ffiA)
			
	FFIMatrix.scalarAddInline(ffiA, 10)
	FFIMatrix.display(ffiA)
	
	FFIMatrix.addInline(ffiA, ffiC)
	FFIMatrix.display(ffiA)
	
	local r = FFIMatrix.scalarSubtract(ffiA, 10)
	FFIMatrix.display(r)
	
	local r = FFIMatrix.subtract(ffiA, ffiC)
	FFIMatrix.display(r)
	
	FFIMatrix.scalarSubtractInline(ffiA, 10)
	FFIMatrix.display(ffiA)
	
	FFIMatrix.subtractInline(ffiA, ffiC)
	FFIMatrix.display(ffiA)
end

function SpaceSimulatorScene:draw(dt)

end

function SpaceSimulatorScene:update(dt)
	local sw = self.screenWidth
	local sh = self.screenHeight
		
		--[[
	for i = 1, 1000 do
		local b = Matrix:new{{1,2,3},{4,6,8}}
		local a = Matrix:new{{8,3}, {2,4}, {3,6}}
		local r = a * b
	end
	]]
	
	--[[	
	for i = 1, 1000 do
		local a = FFIMatrix.newMatrix(3, 2)
		local b = FFIMatrix.newMatrix(2, 3)
		local r = FFIMatrix.multiply(a, b)
	end
	]]
	
		--[[
	local st = love.timer.getTime()
	for i = 1, 100 do
		local a = Matrix:new{{8,3}, {2,4}, {3,6}}
		local r = a * 15
	end
	local et = love.timer.getTime()
	
	--print('Matrix scalar multiply: '.. et - st)
	
	local st = love.timer.getTime()
	for i = 1, 100 do
		local a = FFIMatrix.newMatrix(3, 2)
		local r = FFIMatrix.scalarMultiply(a, 15)
	end
	local et = love.timer.getTime()
	
	--print('FFI Matrix scalar multiply: '.. et - st)
	]]
	
	--[[
	local st = love.timer.getTime()
	for i = 1, 100 do
		local b = Matrix:new{{1,2,3},{4,6,8}}
		local a = Matrix:new{{8,3}, {2,4}, {3,6}}
		local r = a * b
	end
	local et = love.timer.getTime()
	
	print('Matrix multiply: '.. et - st)	
	]]
	
	local st = love.timer.getTime()
	for i = 1, 1000 do
		local a = FFIMatrix.newMatrix(4, 4)
		local b = FFIMatrix.newMatrix(4, 4)
		
		FFIMatrix.setValue(a, 0, 0, 8)
		FFIMatrix.setValue(a, 0, 1, 3)
		FFIMatrix.setValue(a, 1, 0, 2)
		FFIMatrix.setValue(a, 1, 1, 4)
		FFIMatrix.setValue(a, 2, 0, 3)
		FFIMatrix.setValue(a, 2, 1, 6)	
		
		FFIMatrix.setValue(b, 0, 0, 1)
		FFIMatrix.setValue(b, 0, 1, 2)
		FFIMatrix.setValue(b, 0, 2, 3)
		FFIMatrix.setValue(b, 1, 0, 4)
		FFIMatrix.setValue(b, 1, 1, 6)
		FFIMatrix.setValue(b, 1, 2, 8)	
		
		local r = FFIMatrix.multiply(a, b)
	end
	local et = love.timer.getTime()	
	print('FFI Matrix multiply: '.. et - st)
end

return SpaceSimulatorScene