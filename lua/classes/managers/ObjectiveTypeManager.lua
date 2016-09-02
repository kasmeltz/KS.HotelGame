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
	self:loadObjectiveNouns()
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
				for i = 1, #wordTypes do
					print(wordTypes[i])
				end
				for i = 1, #descriptions do
					print(descriptions[i])
				end
			end
			objectiveType = {}
			descriptions = {}
			wordTypes = {}
			lineCount = 0
		elseif line:sub(1,2) == '**' then
			line = line:gsub('**', '')
			wordTypes[#wordTypes + 1] = line
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

function ObjectiveTypeManager:loadObjectiveNouns()
	self.nouns = {}	
	for line in love.filesystem.lines('data/objectiveNouns.dat') do
		if line:sub(1,2) == '==' then
			if noun then
				table.insert(self.nouns, noun)				
							
				print(noun.type)
				print(noun.text)
			end
			
			noun = {}
			noun.type = line:sub(3,3)
		else
			noun.text = line
		end		
	end
end

return ObjectiveTypeManager