#ifndef _DLL_TUTORIAL_H_
#define _DLL_TUTORIAL_H_

#define DECLDIR __declspec(dllexport)

extern "C"
{
	DECLDIR void matrix4x4Identity(float *m1);
	DECLDIR void matrix4x4Transpose(float *m1, float *m2);
	DECLDIR void matrix4x4ScalarMultiply(float *m1, float *m2, float v);
	DECLDIR void matrix4x4Multiply(float *m1, float *m2, float *m3);
	DECLDIR void matrix4x4ScalarAdd(float *m1, float *m2, float v);
	DECLDIR void matrix4x4Add(float *m3, float *m1, float *m2);	
	DECLDIR void matrix4x4ScalarSubtract(float *m1, float *m2, float v);
	DECLDIR void matrix4x4Subtract(float *m3, float *m1, float *m2);	
	DECLDIR void matrix4x4Inverse(float *m1, float *m2);

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