local SimulationItem = require 'classes/simulation/SimulationItem'
local Location = SimulationItem:extend('Location')

-- name
-- nameType
-- terrainType
-- area
-- monster difficulty

function Location:init(gameWorld)
	Location.super.init(self, gameWorld)
end

function Location:fullName()
	if self.nameType == 1 then
		return self.name .. ' ' .. self.terrainType
	elseif self.nameType == 2 then
		return self.terrainType .. ' ' .. self.name
	elseif self.nameType == 3 then
		return self.name .. ' ' .. self.terrainType
	end		
end

return Location