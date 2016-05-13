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

function Profiler:measure(name, fn)
	local startTime = love.timer.getTime()
	fn()
	local endTime = love.timer.getTime()
	
	 if not self.items[name] then
		self.items[name] = { counts = 0, average = 0}
	end
	
	local elapsed = endTime - startTime
	local item = self.items[name]	
	
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