local SimulationItem = require 'classes/simulation/SimulationItem'
local DayNightCycle = SimulationItem:extend('DayNightCycle')

function DayNightCycle:init(gameWorld)
	DayNightCycle.super.init(self, gameWorld)
	
	local snapShots = {}
	self.snapShots = snapShots
	
	local light = 
	{
		direction = { 0, 0, 0 },
		ambient = { 0.0, 0.0, 0.0 },
		directional = { 0.0, 0.0, 0.0 },
		position = { 0, 0, 0 },
		positional = { 0, 0, 0 },		
	}
	self.light = light
	self.lastSecond = 0
end

function DayNightCycle:clear()
	self.snapShots = {}
	self.lastSecond = 0
end

function DayNightCycle:addSnapShot(light, hour, minute, second)
	if hour < 0 or hour > 23 then 
		error('Day night cycles only accept snap shots between hours 0 - 23')
	end
	if minute < 0 and minute > 59 then 
		error('Day night cycles only accept snap shots between minutes 0 - 59')
	end
	if second < 0 and second > 59 then 
		error('Day night cycles only accept snap shots between second 0 - 59')
	end
	
	local seconds = hour * 3600 + minute * 60 + second	
	light.seconds = seconds
	table.insert(self.snapShots, light)
	table.sort(self.snapShots, function(a, b) return a.seconds < b.seconds end)
	
	print('================')
	print('Sorted lights')
	for _, light in ipairs(self.snapShots) do
	
		print(light.seconds)
	end
	print('================')
end

function DayNightCycle:update(dt)
	if #self.snapShots == 0 then
		return
	end
	
	local gt = self.gameWorld.gameTime
	local date = gt:date()
	local seconds =  date.hour * 3600 + date.min * 60 + date.sec
	
	local lastIdx = 1
	for idx, light in ipairs(self.snapShots) do
		if seconds >= light.seconds then
			lastIdx = idx
		else
			break
		end
	end

	local interpolateFrom = self.snapShots[lastIdx]	
	local interpolateTo
	
	if lastIdx + 1 > #self.snapShots then
		interpolateTo = self.snapShots[1]
	else
		interpolateTo = self.snapShots[lastIdx + 1]
	end	
	
	local distanceFrom = math.abs(seconds - interpolateFrom.seconds)
	local distanceTo = math.abs(seconds - interpolateTo.seconds)
	
	local light = self.light
	
	for k, t in pairs(interpolateFrom) do
		if type(t) =='table' then
			for idx in ipairs(t) do
				local y0 = interpolateFrom[k][idx]
				local y1 = interpolateTo[k][idx]
				local x0 = interpolateTo.seconds
				local x1 = interpolateFrom.seconds			
				local dx = math.max(x0 - x1, 0.00001)				
				local x = seconds
				local v = y0 * (1 - (x - x0) / dx) + y1 * (x-x0) / dx	
				light[k][idx] = v								
			end
		end
	end		
end

return DayNightCycle