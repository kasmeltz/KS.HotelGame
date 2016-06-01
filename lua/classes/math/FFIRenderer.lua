local class = require 'libs/30log/30log'
local FFIRenderer = class('FFIRenderer')
local instance = FFIRenderer()

local ffi = require 'ffi'
ffi.cdef[[	
	typedef struct { uint8_t r, g, b, a; } rgba_pixel;	
	void render(rgba_pixel *buffer, uint32_t width, uint32_t height);
]]

local math3d = ffi.load 'math3d'

function FFIRenderer.new() 
  error('Cannot instantiate FFIMatrix')
end

function FFIRenderer.extend() 
  error('Cannot extend from a FFIMatrix')
end

function FFIRenderer:init()	
end

function FFIRenderer:getInstance()
  return instance
end

function FFIRenderer.render(buffer, width, height)
	math3d.render(buffer, width, height)
end

return FFIRenderer