local SimulationItem = require 'classes/simulation/SimulationItem'
local TerrainType = SimulationItem:extend('TerrainType')

-- name
-- prefix style
-- suffix style
-- proper name style

function TerrainType:init(gameWorld)
	TerrainType.super.init(self, gameWorld)
end

return TerrainType