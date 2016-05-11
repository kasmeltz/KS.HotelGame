local SimulationItem = require 'classes/simulation/SimulationItem'
local Character = SimulationItem:extend('Character')

function Character:init(gameWorld)
	Character.super:init(gameWorld)
end


return Character