local class = require 'libs/30log/30log'
local SimulationItem = class('SimulationItem')

function SimulationItem:init(gw)
	self.gameWorld = gw
end

return SimulationItem