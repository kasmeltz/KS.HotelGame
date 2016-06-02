#ifndef _DLL_MATH3D_H_
#define _DLL_MATH3D_H_

#include "stdint.h"

#define DECLDIR __declspec(dllexport)

extern "C"
{
	// TYPES
	typedef struct
	{
		float X; float Y; float Z; float W;
	} quaternion;

	typedef struct
	{
		float X; float Y; float Z;
	} vector3;

	typedef struct 
	{ 
		float M11; float M12; float M13; float M14; 
		float M21; float M22; float M23; float M24;
		float M31; float M32; float M33; float M34;
		float M41; float M42; float M43; float M44;
	} matrix4x4;

	typedef struct
	{
		uint32_t A; uint32_t B; uint32_t C;
	} face;

	typedef struct
	{
		uint32_t vertCount;
		uint32_t faceCount;
		vector3 position;
		vector3 rotation;
		vector3 *vertices;
		vector3 *normals;
		vector3 *middles;
		face *faces;
	} mesh;

	typedef struct 
	{ 
		uint8_t r, g, b, a; 
	} rgba_pixel;

	// MATRIX4
	DECLDIR void matrix4x4Identity(matrix4x4 *m);
	DECLDIR void matrix4x4Transpose(matrix4x4 *result, matrix4x4 *m);
	DECLDIR void matrix4x4ScalarMultiply(matrix4x4 *result, matrix4x4 *m, float right);
	DECLDIR void matrix4x4Multiply(matrix4x4 *result, matrix4x4 *m1, matrix4x4 *m2);
	DECLDIR void matrix4x4Add(matrix4x4 *result, matrix4x4 *m1, matrix4x4 *m2);
	DECLDIR void matrix4x4Subtract(matrix4x4 *result, matrix4x4 *m1, matrix4x4 *m2);
	DECLDIR void matrix4x4Inverse(matrix4x4 *result, matrix4x4 *m);
	DECLDIR void matrix4x4TransformCoordinate(vector3 *result, vector3 *v, matrix4x4 *m);
	DECLDIR void matrix4x4Translation(matrix4x4 *result, vector3 *v);
	DECLDIR void matrix4x4RotationYawPitchRoll(matrix4x4 *result, vector3 *v);
	DECLDIR void matrix4x4RotationQuaternion(matrix4x4 *result, quaternion *q);
	DECLDIR void matrix4x4LookAtLH(matrix4x4 *result, vector3 *eye, vector3 *target, vector3 *up);
	DECLDIR void matrix4x4PerspectiveFovRH(matrix4x4 *result, float fov, float aspect, float znear, float zfar);
	DECLDIR void matrix4x4Project(vector3 *result, vector3 *v, matrix4x4 *m, float x, float y, float width, float height, float minZ, float maxZ);
	DECLDIR void matrix4x4TransformNormal(vector3 *result, vector3 *normal, matrix4x4 *transform);

	// QUATERNION	
	DECLDIR void quaternionRotationYawPitchRoll(quaternion *q, vector3 *v);

	// VECTOR3
	DECLDIR void vector3ScalarAdd(vector3 *result, vector3 *v1, float v);
	DECLDIR void vector3Add(vector3 *result, vector3 *v1, vector3 *v2);
	DECLDIR void vector3ScalarSubtract(vector3 *result, vector3 *v1, float v);
	DECLDIR void vector3Subtract(vector3 *result, vector3 *v1, vector3 *v2);
	DECLDIR void vector3ScalarMultiply(vector3 *result, vector3 *v1, float v);
	DECLDIR void vector3ScalarDivide(vector3 *result, vector3 *v1, float v);
	DECLDIR float vector3Dot(vector3 *v1, vector3 *v2);
	DECLDIR void vector3Cross(vector3 *result, vector3 *v1, vector3 *v2);
	DECLDIR float vector3LengthSquared(vector3 *v1);
	DECLDIR float vector3Length(vector3 *v1);
	DECLDIR float vector3DistanceSquared(vector3 *v1, vector3 *v2);
	DECLDIR float vector3Distance(vector3 *v1, vector3 *v2);
	DECLDIR void vector3Normalize(vector3 *result, vector3 *v1);

	// RENDERER
	DECLDIR void render(rgba_pixel *buffer, uint32_t width, uint32_t height);
}

#endif