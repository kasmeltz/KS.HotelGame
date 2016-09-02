local SimulationItem = require 'classes/simulation/SimulationItem'
local InputPattern = SimulationItem:extend('InputPattern')

--  inputs
--  times
--  ???

function InputPattern:init(gameWorld)
	InputPattern.super.init(self, gameWorld)
end

return InputPattern