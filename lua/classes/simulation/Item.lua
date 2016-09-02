local SimulationItem = require 'classes/simulation/SimulationItem'
local Item = SimulationItem:extend('Item')

-- name
-- type
-- rarity
-- equip area
-- requirements
-- stats
-- special bonuses

function Item:init(gameWorld)
	Item.super.init(self, gameWorld)
end

return Item