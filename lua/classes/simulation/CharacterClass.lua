local SimulationItem = require 'classes/simulation/SimulationItem'
local ChracterClass = SimulationItem:extend('ChracterClass')

-- name
-- skills
-- stats

function ChracterClass:init(gameWorld)
	ChracterClass.super.init(self, gameWorld)
end

return ChracterClass