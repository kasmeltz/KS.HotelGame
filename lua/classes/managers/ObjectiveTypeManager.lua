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
	
	local nounType = nil
	local text = nil
	
	for line in love.filesystem.lines('data/objectiveNouns.dat') do
		if line:sub(1,2) == '==' then
			if text then
				if not self.nouns[nounType] then
					self.nouns[nounType] = {}
				end					
				table.insert(self.nouns[nounType], text)
				
				nounType = nil
				text = nil					
			end			
			nounType = line:sub(3)
		else
			text = line
		end		
	end
end

return ObjectiveTypeManager