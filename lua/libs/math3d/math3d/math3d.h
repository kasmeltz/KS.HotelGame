#ifndef _DLL_TUTORIAL_H_
#define _DLL_TUTORIAL_H_

#define DECLDIR __declspec(dllexport)

extern "C"
{
	// MATRIX4
	DECLDIR void matrix4x4Identity(float *m1);
	DECLDIR void matrix4x4Transpose(float *m1, float *m2);
	DECLDIR void matrix4x4ScalarMultiply(float *m1, float *m2, float v);
	DECLDIR void matrix4x4Multiply(float *m1, float *m2, float *m3);
	DECLDIR void matrix4x4ScalarAdd(float *m1, float *m2, float v);
	DECLDIR void matrix4x4Add(float *m3, float *m1, float *m2);	
	DECLDIR void matrix4x4ScalarSubtract(float *m1, float *m2, float v);
	DECLDIR void matrix4x4Subtract(float *m3, float *m1, float *m2);	
	DECLDIR void matrix4x4Inverse(float *m1, float *m2);
	DECLDIR void matrix4x4TransformCoordinate(float *v1, float *v2, float *m);
	DECLDIR void matrix4x4Translation(float *m, float x, float y, float z);
	DECLDIR void matrix4x4RotationYawPitchRoll(float *m, float yaw, float pitch, float roll);
	DECLDIR void matrix4x4RotationQuaternion(float *q, float *m);
	DECLDIR void matrix4x4LookAtLH(float *m, float *eye, float *target, float *up);
	DECLDIR void matrix4x4PerspectiveFovRH(float *m, float fov, float aspect, float znear, float zfar);
	DECLDIR void matrix4x4Project(float *v1, float *v2, float *m, float x, float y, float width, float height, float minZ, float maxZ);

	// QUATERNION
	DECLDIR void quaternionRotationYawPitchRoll(float *q, float yaw, float pitch, float roll);

	// VECTOR3
	DECLDIR void vector3ScalarAdd(float *v1, float *v2, float v);
	DECLDIR void vector3Add(float *v3, float *v1, float *v2);
	DECLDIR void vector3ScalarSubtract(float *v1, float *v2, float v);
	DECLDIR void vector3Subtract(float *v3, float *v1, float *v2);
	DECLDIR void vector3ScalarMultiply(float *v1, float *v2, float v);
	DECLDIR void vector3ScalarDivide(float *v1, float *v2, float v);
	DECLDIR float vector3Dot(float *v1, float *v2);
	DECLDIR void vector3Cross(float *v3, float *v1, float *v2);
	DECLDIR float vector3LengthSquared(float *v1);
	DECLDIR float vector3Length(float *v1);
	DECLDIR float vector3DistanceSquared(float *v1, float *v2);
	DECLDIR float vector3Distance(float *v1, float *v2);
	DECLDIR void vector3Normalize(float *v1, float *v2);
}

#endif