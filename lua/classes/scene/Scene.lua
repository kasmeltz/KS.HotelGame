local Drawable = require 'classes/drawable/Drawable'
local Scene = Drawable:extend('Scene')

function Scene:init(gw)
	Scene.super.init(self, gw) 
	self.gameWorld = gw
end

function Scene:initialize() end
function Scene:update(dt) end
function Scene:destroy() end
function Scene:keyreleased() end

function Scene:show() 
	if self.onShow then
		self:onShow()
	end

end
function Scene:hide()
	if self.onHide then
		self:onHide()
	end
end

return Scene