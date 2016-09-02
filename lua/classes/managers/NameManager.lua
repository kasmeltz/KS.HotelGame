local class = require 'libs/30log/30log'
local NameManager = class('ObjectiveManager', { })
local instance = NameManager()

function NameManager.new() 
  error('Cannot instantiate NameManager') 
end

function NameManager.extend() 
  error('Cannot extend from a NameManager')
end

function NameManager:init()	
end

function NameManager:getInstance()
  return instance
end

function NameManager:initialize()
	self:loadMaleFirstNames()
	self:loadFemaleFirstNames()
	self:loadLastNames()
end

function NameManager:loadMaleFirstNames()
	self.firstNamesM = {}
	for line in love.filesystem.lines('data/firstNamesM.dat') do
		table.insert(self.firstNamesM, line)
	end		
end

function NameManager:loadFemaleFirstNames()
	self.firstNamesF = {}
	for line in love.filesystem.lines('data/firstNamesF.dat') do
		table.insert(self.firstNamesF, line)
	end		
end

function NameManager:loadLastNames()
	self.lastNames = {}
	for line in love.filesystem.lines('data/lastNames.dat') do
		table.insert(self.lastNames, line)
	end		
end

return NameManager