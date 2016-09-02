local FontManager = require 'classes/scene/FontManager'
FontManager = FontManager:getInstance()

local Drawable = require 'classes/drawable/Drawable'
local TerrainStripType = Drawable:extend('TerrainStripType')

function TerrainStripType:init()
	TerrainStripType.super.init(self)
end

function TerrainStripType:draw() 
end

return TerrainStripType