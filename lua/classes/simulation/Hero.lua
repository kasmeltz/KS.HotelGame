local SimulationItem = require 'classes/simulation/SimulationItem'
local Hero = SimulationItem:extend('Hero')

-- birth date
-- name
-- character class
-- race
-- skill levels
-- health
-- magic
-- experience
-- defense
-- battle damage
-- battle timers

function Hero:init(gameWorld)
	Hero.super.init(self, gameWorld)
end

return Hero