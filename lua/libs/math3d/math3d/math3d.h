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
}

#endif