local class = require 'libs/30log/30log'
local FFIMatrix4x4 = class('FFIMatrix')
local instance = FFIMatrix4x4()

local FFIVector3 = require 'classes/math/FFIVector3'

local ffi = require 'ffi'
ffi.cdef[[
	typedef struct 
	{ 
		float M11; float M12; float M13; float M14; 
		float M21; float M22; float M23; float M24;
		float M31; float M32; float M33; float M34;
		float M41; float M42; float M43; float M44;
	} matrix4x4;
	
	typedef struct
	{
		float X; float Y; float Z; float W;
	} quaternion;
	
	typedef struct
	{
		float X; float Y; float Z;
	} vector3;
	
	void matrix4x4Identity(matrix4x4 *mp);
	void matrix4x4Transpose(matrix4x4 *resultp, matrix4x4 *mp);
	void matrix4x4ScalarMultiply(matrix4x4 *resultp, matrix4x4 *mp, float right);
	void matrix4x4Multiply(matrix4x4 *resultp, matrix4x4 *m1p, matrix4x4 *m2p);
	void matrix4x4Add(matrix4x4 *resultp, matrix4x4 *m1p, matrix4x4 *m2p);
	void matrix4x4Subtract(matrix4x4 *resultp, matrix4x4 *m1p, matrix4x4 *m2p);
	void matrix4x4Inverse(matrix4x4 *resultp, matrix4x4 *mp);
	void matrix4x4TransformCoordinate(vector3 *resultp, vector3 *vp, matrix4x4 *mp);
	void matrix4x4Translation(matrix4x4 *resultp, vector3 *vp);
	void matrix4x4RotationYawPitchRoll(matrix4x4 *resultp, vector3 *vp);
	void matrix4x4RotationQuaternion(matrix4x4 *resultp, quaternion *qp);
	void matrix4x4LookAtLH(matrix4x4 *resultp, vector3 *eyep, vector3 *targetp, vector3 *upp);
	void matrix4x4PerspectiveFovRH(matrix4x4 *resultp, float fov, float aspect, float znear, float zfar);
	void matrix4x4Project(vector3 *resultp, vector3 *vp, matrix4x4 *mp, float x, float y, float width, float height, float minZ, float maxZ);
]]

local math3d = ffi.load 'math3d'

function FFIMatrix4x4.new() 
  error('Cannot instantiate FFIMatrix4x4')
end

function FFIMatrix4x4.extend() 
  error('Cannot extend from a FFIMatrix4x4')
end

function FFIMatrix4x4:init()	
end

function FFIMatrix4x4:getInstance()
  return instance
end

function FFIMatrix4x4.newMatrix()
	local m = ffi.new('matrix4x4')
	return m
end

function FFIMatrix4x4.copy(m)
	local result = FFIMatrix4x4.newMatrix()
	ffi.copy(result, m, 64)
	return result
end

function FFIMatrix4x4.identity()
	local m = ffi.new('matrix4x4')
	math3d.matrix4x4Identity(m)
	return m
end

function FFIMatrix4x4.transpose(m)
	local r = FFIMatrix4x4.newMatrix()
	math3d.matrix4x4Transpose(r, m)
	return r
end

function FFIMatrix4x4.transposeInline(r, m)
	math3d.matrix4x4Transpose(r, m)
end

function FFIMatrix4x4.scalarMultiply(m, v)
	local r = FFIMatrix4x4.newMatrix()
	math3d.matrix4x4ScalarMultiply(r, m, v)
	return r
end

function FFIMatrix4x4.scalarMultiplyInline(r, m, v)
	math3d.matrix4x4ScalarMultiply(r, m, v)
end

function FFIMatrix4x4.multiply(m1, m2)
	local r = FFIMatrix4x4.newMatrix()
	math3d.matrix4x4Multiply(r, m1, m2)
	return r
end

function FFIMatrix4x4.multiplyInline(r, m1, m2)
	math3d.matrix4x4Multiply(r, m1, m2)
end

function FFIMatrix4x4.add(m1, m2)
	local r = FFIMatrix4x4.newMatrix()
	math3d.matrix4x4Add(r, m1, m2)
	return r
end

function FFIMatrix4x4.addInline(r, m1, m2)
	math3d.matrix4x4Add(r, m1, m2)
end

function FFIMatrix4x4.subtract(m1, m2)
	local r = FFIMatrix4x4.newMatrix()
	math3d.matrix4x4Subtract(r, m1, m2)
	return r
end

function FFIMatrix4x4.subtractInline(r, m1, m2)
	math3d.matrix4x4Subtract(r, m1, m2)
end

function FFIMatrix4x4.inverse(m1)
	local r = FFIMatrix4x4.newMatrix()
	math3d.matrix4x4Inverse(r, m1)
	return r
end

function FFIMatrix4x4.inverseInline(r, m1)
	math3d.matrix4x4Inverse(r, m1)
end

function FFIMatrix4x4.transformCoordinate(v, m)
	local r = FFIVector3.newVector()
	math3d.matrix4x4TransformCoordinate(r, v, m)
	return r
end

function FFIMatrix4x4.transformCoordinateInline(r, v, m)
	math3d.matrix4x4TransformCoordinate(r, v, m)
end

function FFIMatrix4x4.translation(v)
	local r = FFIMatrix4x4.newMatrix()
	math3d.matrix4x4Translation(r, v)
	return r
end

function FFIMatrix4x4.translationInline(r, v)
	math3d.matrix4x4Translation(r, v)
end

function FFIMatrix4x4.rotationYawPitchRoll(v)
	local r = FFIMatrix4x4.newMatrix()
	math3d.matrix4x4RotationYawPitchRoll(r, v)
	return r
end

function FFIMatrix4x4.rotationYawPitchRollInline(r, v)
	math3d.matrix4x4RotationYawPitchRoll(r, v)
end

function FFIMatrix4x4.lookAtLH(veye, vtarget, vup)
	local r = FFIMatrix4x4.newMatrix()
	math3d.matrix4x4LookAtLH(r, veye, vtarget, vup)
	return r
end

function FFIMatrix4x4.lookAtLHInline(r, veye, vtarget, vup)
	math3d.matrix4x4LookAtLH(r, veye, vtarget, vup)
end

function FFIMatrix4x4.perspectiveFovRH(fov, aspect, znear, zfar)
	local r = FFIMatrix4x4.newMatrix()
	math3d.matrix4x4PerspectiveFovRH(r, fov, aspect, znear, zfar)
	return r
end

function FFIMatrix4x4.perspectiveFovRHInline(r, fov, aspect, znear, zfar)
	math3d.matrix4x4PerspectiveFovRH(r, fov, aspect, znear, zfar)
end	

function FFIMatrix4x4.project(r, v, m, x, y, width, height, minZ, maxZ)
	math3d.matrix4x4Project(r, v, m, x, y, width, height, minZ, maxZ)	
end	

function FFIMatrix4x4.display(m, sep)
	local sep = sep or ','
	print('[')
	print('[' .. m.M11 .. sep .. m.M12 .. sep .. m.M13.. sep .. m.M14 .. ']')
	print('[' .. m.M21 .. sep .. m.M22 .. sep .. m.M23.. sep .. m.M24 .. ']')
	print('[' .. m.M31 .. sep .. m.M32 .. sep .. m.M33.. sep .. m.M34 .. ']')
	print('[' .. m.M41 .. sep .. m.M42 .. sep .. m.M43.. sep .. m.M44 .. ']')
	print(']')
end

return FFIMatrix4x4