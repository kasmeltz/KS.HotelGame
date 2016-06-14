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
		uint32_t r; uint32_t g; uint32_t b;
	} face;

	typedef struct
	{
		uint32_t vertCount;
		vector3 position;
		vector3 rotation;
		vector3 *vertices;
		vector3 *normals;
		vector3 *middles;
		face *faces;
	} mesh;
	
	typedef struct
	{
		mesh *meshes;
	} mesh_list;	
]]

local math3d = ffi.load 'math3d'

function FFIMesh.new() 
  error('Cannot instantiate FFIMatrix')
end

function FFIMesh.extend() 
  error('Cannot extend from a FFIMatrix')
end

function FFIMesh:init()	
	self.meshList = ffi.new('mesh_list');
end

function FFIMesh:getInstance()
  return instance
end

function FFIMesh.newMesh(vertCount, faceCount)
	local ffiMesh = {}	
	ffiMesh.position = FFIVector3.newVector()
	ffiMesh.rotation = FFIVector3.newVector()
	ffiMesh.vertCount = vertCount
	ffiMesh.vertices = ffi.new('vector3[?]', vertCount)	
	for i = 0, vertCount - 1 do
		ffiMesh.vertices[i] = FFIVector3.newVector()
	end
	
	ffiMesh.middles = ffi.new('vector3[?]', faceCount)	
	ffiMesh.normals = ffi.new('vector3[?]', faceCount)	
	ffiMesh.faces = ffi.new('face[?]', faceCount)	
	ffiMesh.faceCount = faceCount		
	ffiMesh.triangles = {}
	for i = 0, faceCount - 1 do
		ffiMesh.faces[i] = ffi.new('face')
		ffiMesh.normals[i] = FFIVector3.newVector()
		ffiMesh.middles[i] = FFIVector3.newVector()		
		ffiMesh.triangles[i] = { FFIVector3.newVector(), FFIVector3.newVector(), FFIVector3.newVector(), true }		
	end	
	
	return ffiMesh
end

function FFIMesh.calculateMiddlesAndNormals(mesh)
	for i = 0, mesh.faceCount - 1 do
		local face = mesh.faces[i]
		local middle = mesh.middles[i]
		local v1 = mesh.vertices[face.A]
		local v2 = mesh.vertices[face.B]
		local v3 = mesh.vertices[face.C]
					
		FFIVector3.addInline(middle, v1, v2)
		FFIVector3.addInline(middle, middle, v3)
		FFIVector3.scalarDivideInline(middle, middle, 3)
	end

	local v2v1 = FFIVector3.newVector()
	local v3v1 = FFIVector3.newVector()
		
	for i = 0, mesh.faceCount - 1 do
		local face = mesh.faces[i]		
		local normal = mesh.normals[i]
		local v1 = mesh.vertices[face.A]
		local v2 = mesh.vertices[face.B]
		local v3 = mesh.vertices[face.C]		
		FFIVector3.subtractInline(v2v1, v2, v1)
		FFIVector3.subtractInline(v3v1, v3, v1)			
		FFIVector3.crossInline(normal, v2v1, v3v1)
		FFIVector3.normalizeInline(normal, normal)		
	end
end

return FFIMesh