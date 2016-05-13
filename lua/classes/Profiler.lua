local class = require 'libs/30log/30log'
local Profiler = class('Profiler', { items = {} })
local instance = Profiler()

function Profiler.new() 
  error('Cannot instantiate Profiler') 
end

function Profiler.extend() 
  error('Cannot extend from a Profiler')
end

function Profiler:init()	
end

function Profiler:getInstance()
  return instance
end

function Profiler:start(name)
	if not self.items[name] then
		self.items[name] = { startTime = 0, counts = 0, average = 0}
	end
	
	self.items[name].startTime = love.timer.getTime()
end

function Profiler:stop(name)
	local endTime = love.timer.getTime()		
	local item = self.items[name]	
	local elapsed = endTime - item.startTime
	
	--[[
	CMAn1 = (xn1 + n * CMAn) / n1
	]]
	local avg = (elapsed + (item.counts * item.average)) / (item.counts + 1)
	item.counts = item.counts + 1
	item.average = avg
end

function Profiler:getAverage(name)
	if not self.items[name] then return 0 end
	
	return self.items[name].average
end

return Profiler