local SimulationItem = require 'classes/simulation/SimulationItem'
local History = SimulationItem:extend('History')

-- history entries
-- completed quests
-- unfinished quests

function History:init(gameWorld)
	History.super.init(self, gameWorld)
end

return History