local class = require 'libs/30log/30log'
local FFIMatrix4x4 = class('FFIMatrix')
local instance = FFIMatrix4x4()

local FFIVector3 = require 'classes/math/FFIVector3'

local ffi = require 'ffi'
ffi.cdef[[
	void matrix4x4Identity(float *m1);
	void matrix4x4Transpose(float *m1, float *m2);
	void matrix4x4ScalarMultiply(float *m1, float *m2, float v);
	void matrix4x4Multiply(float *m1, float *m2, float *m3);
	void matrix4x4ScalarAdd(float *m1, float *m2, float v);
	void matrix4x4Add(float *m3, float *m1, float *m2);
	void matrix4x4ScalarSubtract(float *m1, float *m2, float v);
	void matrix4x4Subtract(float *m3, float *m1, float *m2);
	void matrix4x4Inverse(float *m1, float *m2);
	void matrix4x4TransformCoordinate(float *v1, float *v2, float *m);
	void matrix4x4Translation(float *m, float x, float y, float z);
	void matrix4x4RotationYawPitchRoll(float *m, float yaw, float pitch, float roll);
	void matrix4x4RotationQuaternion(float *q, float *m);
	void matrix4x4LookAtLH(float *m, float *eye, float *target, float *up);
	void matrix4x4PerspectiveFovRH(float *m, float fov, float aspect, float znear, float zfar);	
	void matrix4x4Project(float *v1, float *v2, float *m, float x, float y, float width, float height, float minZ, float maxZ);
	void quaternionRotationYawPitchRoll(float *q, float yaw, float pitch, float roll);	
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
	local m = ffi.new('float[16]')
	return m
end

function FFIMatrix4x4.copy(m)
	local result = FFIMatrix4x4.newMatrix()
	ffi.copy(result, m, 64)
	return result
end

function FFIMatrix4x4.setValues(
	m, 
	r1c1, r1c2, r1c3, r1c4,
	r2c1, r2c2, r2c3, r2c4,
	r3c1, r3c2, r3c3, r3c4,
	r4c1, r4c2, r4c3, r4c4)
	
	m[0] = r1c1
	m[1] = r1c2
	m[2] = r1c3
	m[3] = r1c4
	m[4] = r2c1
	m[5] = r2c2
	m[6] = r2c3
	m[7] = r2c4
	m[8] = r3c1
	m[9] = r3c2
	m[10] = r3c3
	m[11] = r3c4
	m[12] = r4c1
	m[13] = r4c2
	m[14] = r4c3
	m[15] = r4c4	
end

function FFIMatrix4x4.identity()
	local r = FFIMatrix4x4.newMatrix()
	r[0] = 1
	r[5] = 1
	r[10] = 1
	r[15] = 1
	return r
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

function FFIMatrix4x4.scalarAdd(m, v)
	local r = FFIMatrix4x4.newMatrix()
	math3d.matrix4x4ScalarAdd(r, m, v)
	return r
end

function FFIMatrix4x4.scalarAddInline(r, m, v)
	math3d.matrix4x4ScalarAdd(r, m, v)
end

function FFIMatrix4x4.add(m1, m2)
	local r = FFIMatrix4x4.newMatrix()
	math3d.matrix4x4Add(r, m1, m2)
	return r
end

function FFIMatrix4x4.addInline(r, m1, m2)
	math3d.matrix4x4Add(r, m1, m2)
end

function FFIMatrix4x4.scalarSubtract(m, v)
	local r = FFIMatrix4x4.newMatrix()
	math3d.matrix4x4ScalarSubtract(r, m, v)
	return r
end

function FFIMatrix4x4.scalarSubtractInline(r, m, v)
	math3d.matrix4x4ScalarSubtract(r, m, v)
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

function FFIMatrix4x4.translation(x, y, z)
	local r = FFIMatrix4x4.newMatrix()
	math3d.matrix4x4Translation(r, x, y, z)
	return r
end

function FFIMatrix4x4.translationInline(r, x, y, z)
	math3d.matrix4x4Translation(r, x, y, z)
end

function FFIMatrix4x4.rotationYawPitchRoll(yaw, pitch, roll)
	local r = FFIMatrix4x4.newMatrix()
	math3d.matrix4x4RotationYawPitchRoll(r, yaw, pitch, roll)
	return r
end

function FFIMatrix4x4.rotationYawPitchRollInline(r, yaw, pitch, roll)
	math3d.matrix4x4RotationYawPitchRoll(r, yaw, pitch, roll)
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
	print('[' .. m[0] .. sep .. m[1] .. sep .. m[2].. sep .. m[3] .. ']')
	print('[' .. m[4] .. sep .. m[5] .. sep .. m[6].. sep .. m[7] .. ']')
	print('[' .. m[8] .. sep .. m[9] .. sep .. m[10].. sep .. m[11] .. ']')
	print('[' .. m[12] .. sep .. m[13] .. sep .. m[14].. sep .. m[15] .. ']')
	print(']')
end

return FFIMatrix4x4