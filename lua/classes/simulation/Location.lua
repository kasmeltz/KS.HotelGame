local SimulationItem = require 'classes/simulation/SimulationItem'
local Location = SimulationItem:extend('Location')

-- name
-- terrain type 
-- location
-- monster difficulty

function Location:init(gameWorld)
	Location.super.init(self, gameWorld)
end

return Location