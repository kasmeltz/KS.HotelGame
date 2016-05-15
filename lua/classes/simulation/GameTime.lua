local class = require 'libs/30log/30log'
local GameTime = class('GameTime')

function GameTime:init()	
	self.speeds = { 0, 0.01, 0.1, 0.5, 1, 2, 5, 10, 1000, 10000 }
	self.speedTexts = { 'paused', 'slowest', 'slower', 'slow', 'normal', 'fast', 'faster', 'fastest', 'ultra', 'redonkulous' }
	self.currentSpeed = 1
end

function GameTime:setTime(year, month, day, hour, minute, second)
	self.timeSeconds = os.time{year = year, month = month, day = day, hour = hour, min = minute, sec = second}
end

function GameTime:getDateString(frmt)
	return os.date(frmt, self.timeSeconds)
end

function GameTime:date()
	return os.date('*t', self.timeSeconds)
end

function GameTime:setSpeed(speed)
	if speed < 1 or speed > #self.speeds then
		error('Game time => Attempt to set an out of range speed: "' .. tostring(speed) .. '"')
	end
	self.currentSpeed = speed
end

function GameTime:update(dt)
	local speed = self.speeds[self.currentSpeed]
	self.timeSeconds = self.timeSeconds + (dt * speed)
end

return GameTime