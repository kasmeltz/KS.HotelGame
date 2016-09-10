local SimulationItem = require 'classes/simulation/SimulationItem'
local Party = SimulationItem:extend('Party')

-- heroes
-- gold
-- current location

function Party:init(gameWorld)
	Party.super.init(self, gameWorld)
	
	self.heroes = {}
end

return Party