local SimulationItem = require 'classes/simulation/SimulationItem'
local Race = SimulationItem:extend('Race')

-- name
-- skills
-- stats

function Race:init(gameWorld)
	Race.super.init(self, gameWorld)
end

return Race