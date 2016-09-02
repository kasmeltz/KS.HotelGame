local class = require 'libs/30log/30log'
local ObjectiveTypeManager = class('ObjectiveManager', { })
local instance = ObjectiveTypeManager()

function ObjectiveTypeManager.new() 
  error('Cannot instantiate ObjectiveTypeManager') 
end

function ObjectiveTypeManager.extend() 
  error('Cannot extend from a ObjectiveTypeManager')
end

function ObjectiveTypeManager:init()	
end

function ObjectiveTypeManager:getInstance()
  return instance
end

function ObjectiveTypeManager:initialize()
	self:loadObjectiveTypes()
	self:loadObjectiveRelationships()
	self:loadObjectiveItems()
	self:loadObjectiveLocations()
end

function ObjectiveTypeManager:loadObjectiveTypes()
	self.objectiveTypes = {}
	
	local objectiveType = nil
	local descriptions = nil
	local wordTypes = nil
	local lineCount = 0
	for line in love.filesystem.lines('data/objectiveTypes.dat') do
		if line:sub(1,2) == '==' then
			if objectiveType then
				objectiveType.descriptions = descriptions
				objectiveType.wordTypes = wordTypes
				table.insert(self.objectiveTypes, objectiveType) 
				
				print(objectiveType.title)
				print(objectiveType.wordTypes)
				for i = 1, #descriptions do
					print(descriptions[i])
				end
			end
			objectiveType = {}
			descriptions = {}
			lineCount = 0
		elseif line:sub(1,2) == '**' then
			line = line:gsub('**', '')
			wordTypes = line
		else
			if lineCount == 0 then
				objectiveType.title = line			
				lineCount = 1		
			else 
				descriptions[#descriptions + 1] = line
			end	
		end			
	end		
end

function ObjectiveTypeManager:loadObjectiveRelationships()
	self.relationships = {}
	for line in love.filesystem.lines('data/objectiveRelationships.dat') do
		table.insert(self.relationships, line)
	end		
end

function ObjectiveTypeManager:loadObjectiveItems()
	self.items = {}
	for line in love.filesystem.lines('data/objectiveItems.dat') do
		table.insert(self.items, line)
	end		
end

function ObjectiveTypeManager:loadObjectiveLocations()
	self.locations = {}
	for line in love.filesystem.lines('data/objectiveLocations.dat') do
		table.insert(self.locations, line)
	end		
end

return ObjectiveTypeManager