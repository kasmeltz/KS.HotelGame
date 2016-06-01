local class = require 'libs/30log/30log'
local FFIVector3 = class('FFIVector3')
local instance = FFIVector3()

local ffi = require 'ffi'
ffi.cdef[[	
	typedef struct
	{
		float X; float Y; float Z;
	} vector3;
	
	void vector3ScalarAdd(vector3 *resultp, vector3 *v1p, float v);
	void vector3Add(vector3 *resultp, vector3 *v1p, vector3 *v2p);
	void vector3ScalarSubtract(vector3 *resultp, vector3 *v1p, float v);
	void vector3Subtract(vector3 *resultp, vector3 *v1p, vector3 *v2p);
	void vector3ScalarMultiply(vector3 *resultp, vector3 *v1p, float v);
	void vector3ScalarDivide(vector3 *resultp, vector3 *v1p, float v);
	float vector3Dot(vector3 *v1p, vector3 *v2p);
	void vector3Cross(vector3 *resultp, vector3 *v1p, vector3 *v2p);
	float vector3LengthSquared(vector3 *v1p);
	float vector3Length(vector3 *v1p);
	float vector3DistanceSquared(vector3 *v1p, vector3 *v2p);
	float vector3Distance(vector3 *v1p, vector3 *v2p);
	void vector3Normalize(vector3 *resultp, vector3 *v1p);
]]

local math3d = ffi.load 'math3d'

function FFIVector3.new() 
  error('Cannot instantiate FFIMatrix')
end

function FFIVector3.extend() 
  error('Cannot extend from a FFIMatrix')
end

function FFIVector3:init()	
end

function FFIVector3:getInstance()
  return instance
end

function FFIVector3.newVector()
	return ffi.new('vector3')
end

function FFIVector3.copy(v)
	local result = FFIVector3.newVector()
	ffi.copy(result, v, 12)
	return result
end

function FFIVector3.scalarAdd(v1, v)
	local r = FFIVector3.newVector()
	math3d.vector3ScalarAdd(r, v1, v)
	return r
end

function FFIVector3.scalarAddInline(r, v1, v)
	math3d.vector3ScalarAdd(r, v1, v)
end

function FFIVector3.add(v1, v2)
	local r = FFIVector3.newVector()
	math3d.vector3Add(r, v1, v2)
	return r
end

function FFIVector3.addInline(r, v1, v2)
	math3d.vector3Add(r, v1, v2)
end

function FFIVector3.scalarSubtract(v1, v)
	local r = FFIVector3.newVector()
	math3d.vector3ScalarSubtract(r, v1, v)
	return r
end

function FFIVector3.scalarSubtractInline(r, v1, v)
	math3d.vector3ScalarSubtract(r, v1, v)
end

function FFIVector3.subtract(v1, v2)
	local r = FFIVector3.newVector()
	math3d.vector3Subtract(r, v1, v2)
	return r
end

function FFIVector3.subtractInline(r, v1, v2)
	math3d.vector3Subtract(r, v1, v2)
end

function FFIVector3.scalarMultiply(v1, v)
	local r = FFIVector3.newVector()
	math3d.vector3ScalarMultiply(r, v1, v)
	return r
end

function FFIVector3.scalarMultiplyInline(r, v1, v)
	math3d.vector3ScalarMultiply(r, v1, v)
end

function FFIVector3.scalarDivide(v1, v)
	local r = FFIVector3.newVector()
	math3d.vector3ScalarDivide(r, v1, v)
	return r
end

function FFIVector3.scalarDivideInline(r, v1, v)
	math3d.vector3ScalarDivide(r, v1, v)
end

function FFIVector3.dot(v1, v2)
	return math3d.vector3Dot(v1, v2)
end

function FFIVector3.cross(v1, v2)
	local r = FFIVector3.newVector()
	math3d.vector3Cross(r, v1, v2)
	return r
end

function FFIVector3.crossInline(r, v1, v2)
	math3d.vector3Cross(r, v1, v2)
end

function FFIVector3.lengthSquared(v1)
	return math3d.vector3LengthSquared(v1)
end

function FFIVector3.length(v1)
	return math3d.vector3Length(v1)
end

function FFIVector3.distanceSquared(v1, v2)
	return math3d.vector3DistanceSquared(v1, v2)
end

function FFIVector3.distance(v1, v2)
	return math3d.vector3Distance(v1, v2)
end

function FFIVector3.normalize(v1)
	local r = FFIVector3.newVector()
	math3d.vector3Normalize(r, v1)
	return r
end

function FFIVector3.normalizeInline(r, v1)
	math3d.vector3Normalize(r, v1)
end

function FFIVector3.display(v, sep)
	local sep = sep or ','
	print('[' .. v.X .. sep .. v.Y .. sep .. v.Z .. ']')
end

return FFIVector3