local SimulationItem = require 'classes/simulation/SimulationItem'
local Character = SimulationItem:extend('Character')

function Character:init(gameWorld)
	Character.super.init(self, gameWorld)
	
	self.emotion = 'neutral'
end

return Character