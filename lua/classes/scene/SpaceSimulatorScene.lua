local Scene = require 'classes/scene/Scene'
local SpaceSimulatorScene = Scene:extend('SpaceSimulatorScene')

local Matrix = require 'classes/math/Matrix'

function SpaceSimulatorScene:init(gameWorld)
	SpaceSimulatorScene.super.init(self, gameWorld)

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
end

function SpaceSimulatorScene:draw(dt)

end

function SpaceSimulatorScene:update(dt)
	local sw = self.screenWidth
	local sh = self.screenHeight
end

return SpaceSimulatorScene