local SimulationItem = require 'classes/simulation/SimulationItem'
local MonsterType = SimulationItem:extend('MonsterType')

-- name
-- skills
-- stats
-- rewards / drops

function MonsterType:init(gameWorld)
	MonsterType.super.init(self, gameWorld)
end

return MonsterType