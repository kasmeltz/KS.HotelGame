local class = require 'libs/30log/30log'
local TCCard = class('TCCard')

--
-- Creates a new Trading Card card
--
function TCCard:init(gw, attack, defense, cost)
	self.attack = attack
	self.defense = defense
	self.cost = cost	
end

return TCCard