local SimulationItem = require 'classes/simulation/SimulationItem'
local Skill = SimulationItem:extend('Skill')

-- name
-- cost
-- result

function Skill:init(gameWorld)
	Skill.super.init(self, gameWorld)
end

return Skill