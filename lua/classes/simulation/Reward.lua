local SimulationItem = require 'classes/simulation/SimulationItem'
local Reward = SimulationItem:extend('Reward')

-- name
-- amount
-- item

function Reward:init(gameWorld)
	Reward.super.init(self, gameWorld)
end

return Reward