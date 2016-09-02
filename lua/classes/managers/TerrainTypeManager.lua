local class = require 'libs/30log/30log'
local TerrainTypeManager = class('TerrainTypeManager', {} )
local instance = TerrainTypeManager()

function TerrainTypeManager.new() 
  error('Cannot instantiate TerrainTypeManager') 
end

function TerrainTypeManager.extend() 
  error('Cannot extend from a TerrainTypeManager')
end

function TerrainTypeManager:init()	
end

function TerrainTypeManager:getInstance()
  return instance
end

function TerrainTypeManager:initialize()
	self:loadTerrainTypes()
	self:loadPrefixes()
	self:loadSuffixes()
	self:loadProperNouns()
end

function TerrainTypeManager:loadTerrainTypes()
	self.terrainTypes = {}
	for line in love.filesystem.lines('data/terrainTypes.dat') do
		table.insert(self.terrainTypes, line)
	end		
end

function TerrainTypeManager:loadPrefixes()
	self.prefixes = {}
	for line in love.filesystem.lines('data/locationPrefixes.dat') do
		table.insert(self.prefixes, line)
	end		
end

function TerrainTypeManager:loadSuffixes()
	self.suffixes = {}
	for line in love.filesystem.lines('data/locationSuffixes.dat') do
		table.insert(self.suffixes, line)
	end		
end

function TerrainTypeManager:loadProperNouns()
	self.properNouns = {}
	for line in love.filesystem.lines('data/locationNouns.dat') do
		table.insert(self.properNouns, line)
	end	
end

function TerrainTypeManager:getTerrainTypes()
	return self.terrainTypes
end

function TerrainTypeManager:getPrefixes()
	return self.prefixes
end

function TerrainTypeManager:getSuffixes()
	return self.suffixes
end

function TerrainTypeManager:getProperNouns()
	return self.properNouns
end

return TerrainTypeManager