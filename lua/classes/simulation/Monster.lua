local SimulationItem = require 'classes/simulation/SimulationItem'
local Monster = SimulationItem:extend('Monster')

-- name
-- monster type
-- experience level
-- skill levels
-- stats
-- rewards / drops
-- prefixes / suffixes
-- battle timers

function Monster:init(gameWorld)
	Monster.super.init(self, gameWorld)
end

return Monster