local SimulationItem = require 'classes/simulation/SimulationItem'
local Location = SimulationItem:extend('Location')

-- name
-- nameType
-- terrainType
-- quadrant
-- row
-- column
-- cartesian location
-- monster difficulty
-- is discovered (the player has visited it at least once or there is at least one quest for this location)

function Location:init(gameWorld)
	Location.super.init(self, gameWorld)
	self.isDiscovered = false
end

function Location:fullName()
	if self.nameType == 1 then
		return self.name .. ' ' .. self.terrainType
	elseif self.nameType == 2 then
		return self.terrainType .. ' ' .. self.name
	elseif self.nameType == 3 then
		return self.name .. ' ' .. self.terrainType
	end		
end

function Location:setQuadrantRowColumn(quadrant, row, column)
	self.quadrant = quadrant
	self.row = row	
	self.column = column
	
	local angle = (quadrant - 1) * 45 + ((column - 1) * 11.25)	
	radians = angle * math.pi / 180
	local radius = row / 2
		
	-- center point of map
	local cx = 0
	local cy = 0	
	
	self.cartesianX = cx + radius * math.cos(radians)
	self.cartesianY = cy + radius * math.sin(radians)
	
	local maximumVariance = 0.4
	local halfVariance = 0.2
	local variance = (math.random() * maximumVariance - halfVariance) * radius
	self.cartesianX = self.cartesianX + variance
	local variance = (math.random() * maximumVariance - halfVariance) * radius
	self.cartesianY = self.cartesianY + variance
end

function Location:distance(otherLocation)
	local dx = self.cartesianX - other.cartesianX
	local dy = self.cartesianY - other.cartesianY
	return math.sqrt(dx * dx + dy * dy)
end

return Location