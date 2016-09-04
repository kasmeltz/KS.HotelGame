local class = require 'libs/30log/30log'
local RacesManager = class('RacesManager')
local instance = RacesManager()

function RacesManager.new() 
  error('Cannot instantiate RacesManager') 
end

function RacesManager.extend() 
  error('Cannot extend from a RacesManager')
end

function RacesManager:init()	
end

function RacesManager:getInstance()
  return instance
end

function RacesManager:initialize()
	self:loadRaces()
end

function RacesManager:loadRaces()
	local text = 'return ' .. love.filesystem.read('data/races.dat')
	local f = assert(loadstring(text))
	self.races = f()
end

return RacesManager