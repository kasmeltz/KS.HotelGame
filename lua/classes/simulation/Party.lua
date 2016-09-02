local SimulationItem = require 'classes/simulation/SimulationItem'
local Party = SimulationItem:extend('Party')

-- heroes
-- current location

function Party:init(gameWorld)
	Party.super.init(self, gameWorld)
end

return Party