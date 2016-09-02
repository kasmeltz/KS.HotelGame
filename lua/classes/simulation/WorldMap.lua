local SimulationItem = require 'classes/simulation/SimulationItem'
local WorldMap = SimulationItem:extend('WorldMap')

function WorldMap:init(gameWorld)
	WorldMap.super.init(self, gameWorld)
end

return WorldMap