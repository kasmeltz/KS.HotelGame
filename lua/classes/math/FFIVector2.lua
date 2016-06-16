local class = require 'libs/30log/30log'
local FFIVector2 = class('FFIVector2')
local instance = FFIVector2()

local ffi = require 'ffi'
ffi.cdef[[	
	typedef struct
	{
		float X; float Y;
	} vector2;
	
	void vector2ScalarAdd(vector2 *result, vector2 *v1, float v);
	void vector2Add(vector2 *result, vector2 *v1, vector2 *v2);
	void vector2ScalarSubtract(vector2 *result, vector2 *v1, float v);
	void vector2Subtract(vector2 *result, vector2 *v1, vector2 *v2);
	void vector2ScalarMultiply(vector2 *result, vector2 *v1, float v);
	void vector2ScalarDivide(vector2 *result, vector2 *v1, float v);
	float vector2Dot(vector2 *v1, vector2 *v2);
	void vector2Cross(vector2 *result, vector2 *v1, vector2 *v2);
	float vector2LengthSquared(vector2 *v1);
	float vector2Length(vector2 *v1);
	float vector2DistanceSquared(vector2 *v1, vector2 *v2);
	float vector2Distance(vector2 *v1, vector2 *v2);
	void vector2Normalize(vector2 *result, vector2 *v1);
]]

local math3d = ffi.load 'math3d'

function FFIVector2.new() 
  error('Cannot instantiate FFIVector2')
end

function FFIVector2.extend() 
  error('Cannot extend from a FFIVector2')
end

function FFIVector2:init()	
end

function FFIVector2:getInstance()
  return instance
end

function FFIVector2.newVector()
	return ffi.new('vector2')
end

function FFIVector2.copy(v)
	local result = FFIVector2.newVector()
	ffi.copy(result, v, 8)
	return result
end

function FFIVector2.copyInline(result, v)
	ffi.copy(result, v, 8)
	return result
end

function FFIVector2.scalarAdd(v1, v)
	local r = FFIVector2.newVector()
	math3d.vector2ScalarAdd(r, v1, v)
	return r
end

function FFIVector2.scalarAddInline(r, v1, v)
	math3d.vector2ScalarAdd(r, v1, v)
end

function FFIVector2.add(v1, v2)
	local r = FFIVector2.newVector()
	math3d.vector2Add(r, v1, v2)
	return r
end

function FFIVector2.addInline(r, v1, v2)
	math3d.vector2Add(r, v1, v2)
end

function FFIVector2.scalarSubtract(v1, v)
	local r = FFIVector2.newVector()
	math3d.vector2ScalarSubtract(r, v1, v)
	return r
end

function FFIVector2.scalarSubtractInline(r, v1, v)
	math3d.vector2ScalarSubtract(r, v1, v)
end

function FFIVector2.subtract(v1, v2)
	local r = FFIVector2.newVector()
	math3d.vector2Subtract(r, v1, v2)
	return r
end

function FFIVector2.subtractInline(r, v1, v2)
	math3d.vector2Subtract(r, v1, v2)
end

function FFIVector2.scalarMultiply(v1, v)
	local r = FFIVector2.newVector()
	math3d.vector2ScalarMultiply(r, v1, v)
	return r
end

function FFIVector2.scalarMultiplyInline(r, v1, v)
	math3d.vector2ScalarMultiply(r, v1, v)
end

function FFIVector2.scalarDivide(v1, v)
	local r = FFIVector2.newVector()
	math3d.vector2ScalarDivide(r, v1, v)
	return r
end

function FFIVector2.scalarDivideInline(r, v1, v)
	math3d.vector2ScalarDivide(r, v1, v)
end

function FFIVector2.dot(v1, v2)
	return math3d.vector2Dot(v1, v2)
end

function FFIVector2.lengthSquared(v1)
	return math3d.vector2LengthSquared(v1)
end

function FFIVector2.length(v1)
	return math3d.vector2Length(v1)
end

function FFIVector2.distanceSquared(v1, v2)
	return math3d.vector2DistanceSquared(v1, v2)
end

function FFIVector2.distance(v1, v2)
	return math3d.vector2Distance(v1, v2)
end

function FFIVector2.normalize(v1)
	local r = FFIVector2.newVector()
	math3d.vector2Normalize(r, v1)
	return r
end

function FFIVector2.normalizeInline(r, v1)
	math3d.vector2Normalize(r, v1)
end

function FFIVector2.display(v, sep)
	local sep = sep or ','
	print('[' .. v.X .. sep .. v.Y .. sep .. v.Z .. ']')
end

return FFIVector2