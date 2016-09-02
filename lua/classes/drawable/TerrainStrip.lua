local FontManager = require 'classes/scene/FontManager'
FontManager = FontManager:getInstance()

local Drawable = require 'classes/drawable/Drawable'
local TerrainStrip = Drawable:extend('TerrainStrip')

function TerrainStrip:init(terrainStripType, x, y)
	TerrainStrip.super.init(self)
end

function TerrainStrip:draw(x, y) 
end

return TerrainStrip