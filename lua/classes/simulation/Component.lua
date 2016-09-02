local SimulationItem = require 'classes/simulation/SimulationItem'
local Component = SimulationItem:extend('Component')

-- name
-- type
-- rarity

function Component:init(gameWorld)
	Component.super.init(self, gameWorld)
end

return Component