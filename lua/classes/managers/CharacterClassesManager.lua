local class = require 'libs/30log/30log'
local CharacterClassesManager = class('CharacterClassesManager')
local instance = CharacterClassesManager()

function CharacterClassesManager.new() 
  error('Cannot instantiate CharacterClassesManager') 
end

function CharacterClassesManager.extend() 
  error('Cannot extend from a CharacterClassesManager')
end

function CharacterClassesManager:init()	
end

function CharacterClassesManager:getInstance()
  return instance
end

function CharacterClassesManager:initialize()
	self:loadCharacterClasses()
end

function CharacterClassesManager:loadCharacterClasses()
	local text = 'return ' .. love.filesystem.read('data/characterClasses.dat')
	local f = assert(loadstring(text))
	self.characterClasses = f()
end

return CharacterClassesManager