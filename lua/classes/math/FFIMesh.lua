local class = require 'libs/30log/30log'
local FFIMesh = class('FFIMesh')
local instance = FFIMesh()

local FFIVector3 = require 'classes/math/FFIVector3'

local ffi = require 'ffi'
ffi.cdef[[	
	typedef struct { uint32_t vertCount; float* position; float *rotation; float** vertices; } mesh;
]]

local math3d = ffi.load 'math3d'

function FFIMesh.new() 
  error('Cannot instantiate FFIMatrix')
end

function FFIMesh.extend() 
  error('Cannot extend from a FFIMatrix')
end

function FFIMesh:init()	
end

function FFIMesh:getInstance()
  return instance
end

function FFIMesh.newMesh(vertCount)
	local ffiMesh = ffi.new('mesh')
	ffiMesh.position = FFIVector3.newVector()
	ffiMesh.rotation = FFIVector3.newVector()
	ffiMesh.vertCount = vertCount
	ffiMesh.vertices = ffi.new('float*[?]', vertCount)
	return ffiMesh
end

return FFIMesh