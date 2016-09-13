local class = require 'libs/30log/30log'
local TerrainStripTypeManager = class('TerrainStripTypeManager', { strips = {} } )
local instance = TerrainStripTypeManager()

function TerrainStripTypeManager.new() 
  error('Cannot instantiate TerrainStripTypeManager') 
end

function TerrainStripTypeManager.extend() 
  error('Cannot extend from a TerrainStripTypeManager')
end

function TerrainStripTypeManager:init()	
end

function TerrainStripTypeManager:getInstance()
  return instance
end

function TerrainStripTypeManager:initialize()
	self:loadTerrainStripTypes()
end

function TerrainStripTypeManager:loadTerrainStripTypes()
	self.terrainStrips = {}
	
	local files = love.filesystem.getDirectoryItems('data/images/terrainstrips')
	for k, file in pairs(files) do
		local a, b, c, d = string.find(file, '(.+)_(%d+)')
		local img = love.graphics.newImage('data/images/terrainstrips/' .. file)
		self:addTerrainStripType(img, c:lower())
	end
end

function TerrainStripTypeManager:addTerrainStripType(strip, terrainName)
	if not self.terrainStrips[terrainName] then 
		self.terrainStrips[terrainName] = {}
	end
	
	local strips = self.terrainStrips[terrainName]
	strips[#strips + 1] = strip
end

function TerrainStripTypeManager:getTerrainStripTypes(terrainName)
	return self.terrainStrips[terrainName]
end

return TerrainStripTypeManager