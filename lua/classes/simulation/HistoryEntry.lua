local SimulationItem = require 'classes/simulation/SimulationItem'
local HistoryEntry = SimulationItem:extend('HistoryEntry')

-- date
-- description

function HistoryEntry:init(gameWorld)
	HistoryEntry.super.init(self, gameWorld)
end

return HistoryEntry