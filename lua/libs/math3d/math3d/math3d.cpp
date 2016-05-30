#include "math3d.h"
#include <math.h>

extern "C"
{
	DECLDIR void matrix4x4Identity(float *m1)
	{
		m1[0] = m1[5] = m1[10] = m1[15] = 1;
		m1[1] = m1[2] = m1[3] = m1[4] = m1[6] = m1[7] = m1[8] = m1[9] = m1[11] = m1[12] = m1[13] = m1[14] = 0;
	}

	DECLDIR void matrix4x4Transpose(float *m1, float *m2)
	{
		float m2_0 = m2[0];
		float m2_1 = m2[1];
		float m2_2 = m2[2];
		float m2_3 = m2[3];
		float m2_4 = m2[4];
		float m2_5 = m2[5];
		float m2_6 = m2[6];
		float m2_7 = m2[7];
		float m2_8 = m2[8];
		float m2_9 = m2[9];
		float m2_10 = m2[10];
		float m2_11 = m2[11];
		float m2_12 = m2[12];
		float m2_13 = m2[13];
		float m2_14 = m2[14];
		float m2_15 = m2[15];

		m1[0] = m2_0; m1[1] = m2_4; m1[2] = m2_8; m1[3] = m2_12;
		m1[4] = m2_1; m1[5] = m2_5; m1[6] = m2_9; m1[7] = m2_13;
		m1[8] = m2_2; m1[9] = m2_6; m1[10] = m2_10; m1[11] = m2_14;
		m1[12] = m2_3; m1[13] = m2_7; m1[14] = m2_11; m1[15] = m2_15;
	}

	DECLDIR void matrix4x4ScalarMultiply(float *m1, float *m2, float v)
	{
		m1[0] = m2[0] * v;
		m1[1] = m2[1] * v;
		m1[2] = m2[2] * v;
		m1[3] = m2[3] * v;
		m1[4] = m2[4] * v;
		m1[5] = m2[5] * v;
		m1[6] = m2[6] * v;
		m1[7] = m2[7] * v;
		m1[8] = m2[8] * v;
		m1[9] = m2[9] * v;
		m1[10] = m2[10] * v;
		m1[11] = m2[11] * v;
		m1[12] = m2[12] * v;
		m1[13] = m2[13] * v;
		m1[14] = m2[14] * v;
		m1[15] = m2[15] * v;
	}

	DECLDIR void matrix4x4Multiply(float *m3, float *m1, float *m2)
	{
		float m1_0 = m1[0];
		float m1_1 = m1[1];
		float m1_2 = m1[2];
		float m1_3 = m1[3];
		float m1_4 = m1[4];
		float m1_5 = m1[5];
		float m1_6 = m1[6];
		float m1_7 = m1[7];
		float m1_8 = m1[8];
		float m1_9 = m1[9];
		float m1_10 = m1[10];
		float m1_11 = m1[11];
		float m1_12 = m1[12];
		float m1_13 = m1[13];
		float m1_14 = m1[14];
		float m1_15 = m1[15];

		float m2_0 = m2[0];
		float m2_1 = m2[1];
		float m2_2 = m2[2];
		float m2_3 = m2[3];
		float m2_4 = m2[4];
		float m2_5 = m2[5];
		float m2_6 = m2[6];
		float m2_7 = m2[7];
		float m2_8 = m2[8];
		float m2_9 = m2[9];
		float m2_10 = m2[10];
		float m2_11 = m2[11];
		float m2_12 = m2[12];
		float m2_13 = m2[13];
		float m2_14 = m2[14];
		float m2_15 = m2[15];

		m3[0] = m1_0 * m2_0 + m1_1 * m2_4 + m1_2 * m2_8 + m1_3 * m2_12;
		m3[1] = m1_0 * m2_1 + m1_1 * m2_5 + m1_2 * m2_9 + m1_3 * m2_13;
		m3[2] = m1_0 * m2_2 + m1_1 * m2_6 + m1_2 * m2_10 + m1_3 * m2_14;
		m3[3] = m1_0 * m2_3 + m1_1 * m2_7 + m1_2 * m2_11 + m1_3 * m2_15;

		m3[4] = m1_4 * m2_0 + m1_5 * m2_4 + m1_6 * m2_8 + m1_7 * m2_12;
		m3[5] = m1_4 * m2_1 + m1_5 * m2_5 + m1_6 * m2_9 + m1_7 * m2_13;
		m3[6] = m1_4 * m2_2 + m1_5 * m2_6 + m1_6 * m2_10 + m1_7 * m2_14;
		m3[7] = m1_4 * m2_3 + m1_5 * m2_7 + m1_6 * m2_11 + m1_7 * m2_15;

		m3[8] = m1_8 * m2_0 + m1_9 * m2_4 + m1_10 * m2_8 + m1_11 * m2_12;
		m3[9] = m1_8 * m2_1 + m1_9 * m2_5 + m1_10 * m2_9 + m1_11 * m2_13;
		m3[10] = m1_8 * m2_2 + m1_9 * m2_6 + m1_10 * m2_10 + m1_11 * m2_14;
		m3[11] = m1_8 * m2_3 + m1_9 * m2_7 + m1_10 * m2_11 + m1_11 * m2_15;

		m3[12] = m1_12 * m2_0 + m1_13 * m2_4 + m1_14 * m2_8 + m1_15 * m2_12;
		m3[13] = m1_12 * m2_1 + m1_13 * m2_5 + m1_14 * m2_9 + m1_15 * m2_13;
		m3[14] = m1_12 * m2_2 + m1_13 * m2_6 + m1_14 * m2_10 + m1_15 * m2_14;
		m3[15] = m1_12 * m2_3 + m1_13 * m2_7 + m1_14 * m2_11 + m1_15 * m2_15;
	}

	DECLDIR void matrix4x4ScalarAdd(float *m1, float *m2, float v)
	{
		m1[0] = m2[0] + v;
		m1[1] = m2[1] + v;
		m1[2] = m2[2] + v;
		m1[3] = m2[3] + v;
		m1[4] = m2[4] + v;
		m1[5] = m2[5] + v;
		m1[6] = m2[6] + v;
		m1[7] = m2[7] + v;
		m1[8] = m2[8] + v;
		m1[9] = m2[9] + v;
		m1[10] = m2[10] + v;
		m1[11] = m2[11] + v;
		m1[12] = m2[12] + v;
		m1[13] = m2[13] + v;
		m1[14] = m2[14] + v;
		m1[15] = m2[15] + v;
	}

	DECLDIR void matrix4x4Add(float *m3, float *m1, float *m2)
	{
		m3[0] = m1[0] + m2[0];
		m3[1] = m1[1] + m2[1];
		m3[2] = m1[2] + m2[2];
		m3[3] = m1[3] + m2[3];
		m3[4] = m1[4] + m2[4];
		m3[5] = m1[5] + m2[5];
		m3[6] = m1[6] + m2[6];
		m3[7] = m1[7] + m2[7];
		m3[8] = m1[8] + m2[8];
		m3[9] = m1[9] + m2[9];
		m3[10] = m1[10] + m2[10];
		m3[11] = m1[11] + m2[11];
		m3[12] = m1[12] + m2[12];
		m3[13] = m1[13] + m2[13];
		m3[14] = m1[14] + m2[14];
		m3[15] = m1[15] + m2[15];
	}

	DECLDIR void matrix4x4ScalarSubtract(float *m1, float *m2, float v)
	{
		m1[0] = m2[0] - v;
		m1[1] = m2[1] - v;
		m1[2] = m2[2] - v;
		m1[3] = m2[3] - v;
		m1[4] = m2[4] - v;
		m1[5] = m2[5] - v;
		m1[6] = m2[6] - v;
		m1[7] = m2[7] - v;
		m1[8] = m2[8] - v;
		m1[9] = m2[9] - v;
		m1[10] = m2[10] - v;
		m1[11] = m2[11] - v;
		m1[12] = m2[12] - v;
		m1[13] = m2[13] - v;
		m1[14] = m2[14] - v;
		m1[15] = m2[15] - v;
	}

	DECLDIR void matrix4x4Subtract(float *m3, float *m1, float *m2)
	{
		m3[0] = m1[0] - m2[0];
		m3[1] = m1[1] - m2[1];
		m3[2] = m1[2] - m2[2];
		m3[3] = m1[3] - m2[3];
		m3[4] = m1[4] - m2[4];
		m3[5] = m1[5] - m2[5];
		m3[6] = m1[6] - m2[6];
		m3[7] = m1[7] - m2[7];
		m3[8] = m1[8] - m2[8];
		m3[9] = m1[9] - m2[9];
		m3[10] = m1[10] - m2[10];
		m3[11] = m1[11] - m2[11];
		m3[12] = m1[12] - m2[12];
		m3[13] = m1[13] - m2[13];
		m3[14] = m1[14] - m2[14];
		m3[15] = m1[15] - m2[15];
	}

	DECLDIR void matrix4x4Inverse(float *m1, float *m2)
	{
		float m2_0 = m2[0];
		float m2_1 = m2[1];
		float m2_2 = m2[2];
		float m2_3 = m2[3];
		float m2_4 = m2[4];
		float m2_5 = m2[5];
		float m2_6 = m2[6];
		float m2_7 = m2[7];
		float m2_8 = m2[8];
		float m2_9 = m2[9];
		float m2_10 = m2[10];
		float m2_11 = m2[11];
		float m2_12 = m2[12];
		float m2_13 = m2[13];
		float m2_14 = m2[14];
		float m2_15 = m2[15];

		float m1_0 = m2_5* m2_10* m2_15 - m2_5* m2_14* m2_11 - m2_6* m2_9* m2_15 + m2_6* m2_13* m2_11 + m2_7* m2_9* m2_14 - m2_7* m2_13* m2_10;
		float m1_1 = -m2_1* m2_10* m2_15 + m2_1* m2_14* m2_11 + m2_2* m2_9* m2_15 - m2_2* m2_13* m2_11 - m2_3* m2_9* m2_14 + m2_3* m2_13* m2_10;
		float m1_2 = m2_1* m2_6* m2_15 - m2_1* m2_14* m2_7 - m2_2* m2_5* m2_15 + m2_2* m2_13* m2_7 + m2_3* m2_5* m2_14 - m2_3* m2_13* m2_6;
		float m1_3 = -m2_1* m2_6* m2_11 + m2_1* m2_10* m2_7 + m2_2* m2_5* m2_11 - m2_2* m2_9* m2_7 - m2_3* m2_5* m2_10 + m2_3* m2_9* m2_6;

		float m1_4 = -m2_4* m2_10* m2_15 + m2_4* m2_14* m2_11 + m2_6* m2_8* m2_15 - m2_6* m2_12* m2_11 - m2_7* m2_8* m2_14 + m2_7* m2_12* m2_10;
		float m1_5 = m2_0* m2_10* m2_15 - m2_0* m2_14* m2_11 - m2_2* m2_8* m2_15 + m2_2* m2_12* m2_11 + m2_3* m2_8* m2_14 - m2_3* m2_12* m2_10;
		float m1_6 = -m2_0* m2_6* m2_15 + m2_0* m2_14* m2_7 + m2_2* m2_4* m2_15 - m2_2* m2_12* m2_7 - m2_3* m2_4* m2_14 + m2_3* m2_12* m2_6;
		float m1_7 = m2_0* m2_6* m2_11 - m2_0* m2_10* m2_7 - m2_2* m2_4* m2_11 + m2_2* m2_8* m2_7 + m2_3* m2_4* m2_10 - m2_3* m2_8* m2_6;

		float m1_8 = m2_4* m2_9* m2_15 - m2_4* m2_13* m2_11 - m2_5* m2_8* m2_15 + m2_5* m2_12* m2_11 + m2_7* m2_8* m2_13 - m2_7* m2_12* m2_9;
		float m1_9 = -m2_0* m2_9* m2_15 + m2_0* m2_13* m2_11 + m2_1* m2_8* m2_15 - m2_1* m2_12* m2_11 - m2_3* m2_8* m2_13 + m2_3* m2_12* m2_9;
		float m1_10 = m2_0* m2_5* m2_15 - m2_0* m2_13* m2_7 - m2_1* m2_4* m2_15 + m2_1* m2_12* m2_7 + m2_3* m2_4* m2_13 - m2_3* m2_12* m2_5;
		float m1_11 = -m2_0* m2_5* m2_11 + m2_0* m2_9* m2_7 + m2_1* m2_4* m2_11 - m2_1* m2_8* m2_7 - m2_3* m2_4* m2_9 + m2_3* m2_8* m2_5;

		float m1_12 = -m2_4* m2_9* m2_14 + m2_4* m2_13* m2_10 + m2_5* m2_8* m2_14 - m2_5* m2_12* m2_10 - m2_6* m2_8* m2_13 + m2_6* m2_12* m2_9;
		float m1_13 = m2_0* m2_9* m2_14 - m2_0* m2_13* m2_10 - m2_1* m2_8* m2_14 + m2_1* m2_12* m2_10 + m2_2* m2_8* m2_13 - m2_2* m2_12* m2_9;
		float m1_14 = -m2_0* m2_5* m2_14 + m2_0* m2_13* m2_6 + m2_1* m2_4* m2_14 - m2_1* m2_12* m2_6 - m2_2* m2_4* m2_13 + m2_2* m2_12* m2_5;
		float m1_15 = m2_0* m2_5* m2_10 - m2_0* m2_9* m2_6 - m2_1* m2_4* m2_10 + m2_1* m2_8* m2_6 + m2_2* m2_4* m2_9 - m2_2* m2_8* m2_5;

		float det = m2_0* m1_0 + m2_1* m1_4 + m2_2* m1_8 + m2_3* m1_12;

		m1[0] = m1_0 / det;
		m1[1] = m1_1 / det;
		m1[2] = m1_2 / det;
		m1[3] = m1_3 / det;
		m1[4] = m1_4 / det;
		m1[5] = m1_5 / det;
		m1[6] = m1_6 / det;
		m1[7] = m1_7 / det;
		m1[8] = m1_8 / det;
		m1[9] = m1_9 / det;
		m1[10] = m1_10 / det;
		m1[11] = m1_11 / det;
		m1[12] = m1_12 / det;
		m1[13] = m1_13 / det;
		m1[14] = m1_14 / det;
		m1[15] = m1_15 / det;
	}

	DECLDIR void vector3ScalarAdd(float *v1, float *v2, float v)
	{
		v1[0] = v2[0] + v;
		v1[1] = v2[1] + v;
		v1[2] = v2[2] + v;
	}

	DECLDIR void vector3Add(float *v3, float *v1, float *v2)
	{
		v3[0] = v1[0] + v2[0];
		v3[1] = v1[1] + v2[1];
		v3[2] = v1[2] + v2[2];
	}

	DECLDIR void vector3ScalarSubtract(float *v1, float *v2, float v)
	{
		v1[0] = v2[0] - v;
		v1[1] = v2[1] - v;
		v1[2] = v2[2] - v;
	}

	DECLDIR void vector3Subtract(float *v3, float *v1, float *v2)
	{
		v3[0] = v1[0] - v2[0];
		v3[1] = v1[1] - v2[1];
		v3[2] = v1[2] - v2[2];
	}

	DECLDIR void vector3ScalarMultiply(float *v1, float *v2, float v)
	{
		v1[0] = v2[0] * v;
		v1[1] = v2[1] * v;
		v1[2] = v2[2] * v;
	}

	DECLDIR void vector3ScalarDivide(float *v1, float *v2, float v)
	{
		v1[0] = v2[0] / v;
		v1[1] = v2[1] / v;
		v1[2] = v2[2] / v;
	}

	DECLDIR float vector3Dot(float *v1, float *v2)
	{
		//a1b1 + a2b2 + a3b3
		return v1[0] * v2[0] + v1[1] * v2[1] + v1[2] * v2[2];
	}

	DECLDIR void vector3Cross(float *v3, float *v1, float *v2)
	{
		//[a2 * b3 - a3 * b2, a3 * b1 - a1 * b3, a1 * b2 - a2 * b1]
		float v1_x = v1[0];
		float v1_y = v1[1];
		float v1_z = v1[2];

		float v2_x = v2[0];
		float v2_y = v2[1];
		float v2_z = v2[2];

		v3[0] = v1_y * v2_z - v1_z * v2_y;
		v3[1] = v1_z * v2_x - v1_x * v2_z;
		v3[2] = v1_x * v2_y - v1_y * v2_x;
	}
	
	DECLDIR float vector3LengthSquared(float *v1)
	{
		float x = v1[0];
		float y = v1[1];
		float z = v1[2];

		return x * x + y * y + z * z;
	}

	DECLDIR float vector3Length(float *v1)
	{
		return sqrtf(vector3LengthSquared(v1));
	}

	DECLDIR float vector3DistanceSquared(float *v1, float *v2)
	{
		float dx = v1[0] - v2[0];
		float dy = v1[1] - v2[1];
		float dz = v1[2] - v2[2];

		return dx * dx + dy * dy + dz * dz;
	}

	DECLDIR float vector3Distance(float *v1, float *v2)
	{
		return sqrtf(vector3DistanceSquared(v1, v2));
	}

	DECLDIR void vector3Normalize(float *v1, float *v2) 
	{
		float l = vector3Length(v2);
		v1[0] = v2[0] / l;
		v1[1] = v2[1] / l;
		v1[2] = v2[2] / l;
	}
}