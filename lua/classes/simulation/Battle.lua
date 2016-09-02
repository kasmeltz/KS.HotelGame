local SimulationItem = require 'classes/simulation/SimulationItem'
local Battle = SimulationItem:extend('Battle')

-- monsetrs
-- whose turn it is
-- battle state

function Battle:init(gameWorld)
	Battle.super.init(self, gameWorld)
end

return Battle