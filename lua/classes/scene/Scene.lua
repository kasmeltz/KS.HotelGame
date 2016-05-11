local Drawable = require 'classes/drawable/Drawable'
local Scene = Drawable:extend('Scene')

function Scene:init(gw) 
	self.gameWorld = gw
end

function Scene:initialize() end
function Scene:show() end
function Scene:update(dt) end
function Scene:hide() end
function Scene:destroy() end
function Scene:keyreleased() end

return Scene