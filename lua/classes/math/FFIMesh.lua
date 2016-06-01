local class = require 'libs/30log/30log'
local FFIMesh = class('FFIMesh')
local instance = FFIMesh()

local FFIVector3 = require 'classes/math/FFIVector3'

local ffi = require 'ffi'
ffi.cdef[[	
	typedef struct
	{
		float X; float Y; float Z;
	} vector3;
	
	typedef struct
	{
		uint32_t A; uint32_t B; uint32_t C;
	} face;

	typedef struct
	{
		uint32_t vertCount;
		uint32_t faceCount;
		vector3 *vertices;
		face *faces;			
	} vertexData;
	
	typedef struct
	{		
		vector3 position;
		vector3 rotation;
		vertexData vertData;
	} mesh;
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

function FFIMesh.newMesh(vertCount, faceCount)
	local ffiMesh = {}	
	--local ffiMesh = ffi.new('mesh')
	ffiMesh.position = FFIVector3.newVector()
	ffiMesh.rotation = FFIVector3.newVector()
	ffiMesh.vertData = {}	
	--ffiMesh.vertData = ffi.new('vertexData')
	ffiMesh.vertData.vertCount = vertCount
	ffiMesh.vertData.vertices = ffi.new('vector3[?]', vertCount)	
	for i = 0, vertCount - 1 do
		ffiMesh.vertData.vertices[i] = FFIVector3.newVector()
	end
	ffiMesh.vertData.faces = ffi.new('face[?]', faceCount)
	ffiMesh.vertData.faceCount = faceCount
	for i = 0, faceCount - 1 do
		ffiMesh.vertData.faces[i] = ffi.new('face')		
	end

	--[[
	print('ffiMesh', ffiMesh)
	print('position', ffiMesh.position)
	print('rotation', ffiMesh.rotation)
	print('vertData', ffiMesh.vertData)
	print('vertCount', ffiMesh.vertData.vertCount)	
	print('vertices', ffiMesh.vertData.vertices)	
	for i = 0, vertCount - 1 do
		print('vertices[' .. i .. ']', ffiMesh.vertData.vertices[i])
	end
	print('faceCount', ffiMesh.vertData.faceCount)	
	print('faces   ', ffiMesh.vertData.faces)
	for i = 0, faceCount - 1 do
		print('faces[' .. i .. ']', ffiMesh.vertData.faces[i])
	end
	]]
	
	return ffiMesh
end

return FFIMesh