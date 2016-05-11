local class = require 'libs/30log/30log'
local GameWorld = class('GameWorld')

function GameWorld:update(dt)
	self.gameTime:update(dt)
end

return GameWorld