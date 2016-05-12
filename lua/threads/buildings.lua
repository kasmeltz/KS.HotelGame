require 'love.timer'

local ffi = require 'ffi'
ffi.cdef[[
typedef struct { uint8_t red, green, blue, alpha; } rgba_pixel;
]]

print('----------------------------------------------------------------------')
print('|              Building thread started and awaiting commands         |')
print('----------------------------------------------------------------------')

local toChannel = love.thread.getChannel('toBuildings')
local fromChannel = love.thread.getChannel('fromBuildings')

if channel then
	print('----------------------------------------------------------------------')
	print('|           Building channels retrieved by building thread           |')
	print('----------------------------------------------------------------------')
end

local sw = 0
local sh = 0
local backBuffer
function createBackBuffer(w, h)
	print('----------------------------------------------------------------------')
	print('|              Building thread creating new back buffer              |')
	print('----------------------------------------------------------------------')
	print(w, h)

	sw = w
	sh = h
	
	local backBuffer = ffi.new("rgba_pixel[?]", sw * sh)
	
	print('----------------------------------------------------------------------')
	print('|                           Back buffer created                      |')
	print('----------------------------------------------------------------------')
	print(backBuffer)
end

--[[
function process3DData(dataToProcess)	
	local idx = 1
	for y = 1, sh do
		for x = 1, sw do
			for c = 1, 3 do
				pixels[idx] = 0
				idx = idx + 1
			end
		end
	end		
end
]]

while 1 == 1 do
	local dataToProcess = toChannel:demand()	
	if dataToProcess then
		if type(dataToProcess) == 'table' then
			if #dataToProcess == 2 then
				createBackBuffer(dataToProcess[1], dataToProcess[2])
			--else
				--process3DData(dataToProcess)
			end
		--else
--			print(dataToProcess)
		end
	end
	love.timer.sleep(0.001)
end	