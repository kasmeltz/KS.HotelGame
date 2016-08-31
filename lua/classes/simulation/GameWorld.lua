local GameTime = require 'classes/simulation/GameTime'

local class = require 'libs/30log/30log'
local GameWorld = class('GameWorld')

function GameWorld:init()
	local gameTime = GameTime:new()
	gameTime:setTime(2000, 2, 1, 7, 55, 0)
	gameTime:setSpeed(5)
	self.gameTime = gameTime
end

function GameWorld:update(dt)
	self.gameTime:update(dt)
end

return GameWorld