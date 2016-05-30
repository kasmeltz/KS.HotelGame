#include "math3d.h"
#include "stdlib.h"
#include <math.h>

extern "C"
{
	// MATRIX 4x4
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

	DECLDIR void matrix4x4TransformCoordinate(float *v1, float *v2, float *m)
	{
		float v2_x = v2[0];
		float v2_y = v2[1];
		float v2_z = v2[2];

		float x = (v2_x * m[0]) + (v2_y * m[4]) + (v2_z * m[8]) + m[12];
		float y = (v2_x * m[1]) + (v2_y * m[5]) + (v2_z * m[9]) + m[13];
		float z = (v2_x * m[2]) + (v2_y * m[6]) + (v2_z * m[10]) + m[14];
		float w = 1 / ((v2_x * m[3]) + (v2_y * m[7]) + (v2_z * m[11]) + m[15]);

		v1[0] = x / w;
		v1[1] = y / w;
		v1[2] = z / w;
	}

	DECLDIR void matrix4x4Translation(float *m, float x, float y, float z)
	{
		m[0] = 1;
		m[5] = 1;
		m[10] = 1;
		m[15] = 1;

		m[12] = x;
		m[13] = y;
		m[14] = z;
	}

	DECLDIR void matrix4x4RotationYawPitchRoll(float *m, float yaw, float pitch, float roll)
	{
		float *q = (float*)malloc(16);
		quaternionRotationYawPitchRoll(q, yaw, pitch, roll);
		matrix4x4RotationQuaternion(q, m);
		free(q);
	}

	DECLDIR void matrix4x4RotationQuaternion(float *q, float *m)
	{
		float q_x = q[0];
		float q_y = q[1];
		float q_z = q[2];
		float q_w = q[3];

		float xx = q_x * q_x;
		float yy = q_y * q_y;
		float zz = q_z * q_z;
		float xy = q_x * q_y;
		float zw = q_z * q_w;
		float zx = q_z * q_x;
		float yw = q_y * q_w;
		float yz = q_y * q_z;
		float xw = q_x * q_w;

		m[0] = 1;
		m[5] = 1;
		m[10] = 1;
		m[15] = 1;
		
		m[0] = 1.0f - (2.0f * (yy + zz));
		m[1] = 2.0f * (xy + zw);
		m[2] = 2.0f * (zx - yw);
		m[4] = 2.0f * (xy - zw);
		m[5] = 1.0f - (2.0f * (zz + xx));
		m[6] = 2.0f * (yz + xw);
		m[8] = 2.0f * (zx + yw);
		m[9] = 2.0f * (yz - xw);
		m[10] = 1.0f - (2.0f * (yy + xx));
	}

	DECLDIR void matrix4x4LookAtLH(float *m, float *eye, float *target, float *up)
	{
		float *xaxis = (float*)malloc(12);
		float *yaxis = (float*)malloc(12);
		float *zaxis = (float*)malloc(12);

		vector3Subtract(zaxis, target, eye);
		vector3Normalize(zaxis, zaxis);
		vector3Cross(xaxis, up, zaxis);
		vector3Normalize(xaxis, xaxis);
		vector3Cross(yaxis, zaxis, xaxis);

		m[0] = 1;
		m[5] = 1;
		m[10] = 1;
		m[15] = 1;

		m[0] = xaxis[0];
		m[4] = xaxis[1];
		m[8] = xaxis[2];

		m[1] = yaxis[0];
		m[5] = yaxis[1];
		m[9] = yaxis[2];

		m[2] = zaxis[0];
		m[6] = zaxis[1];
		m[10] = zaxis[2];

		m[12] = -vector3Dot(xaxis, eye);
		m[13] = -vector3Dot(yaxis, eye);
		m[14] = -vector3Dot(zaxis, eye);

		free(xaxis);
		free(yaxis);
		free(zaxis);
	}

	DECLDIR void matrix4x4PerspectiveFovRH(float *m, float fov, float aspect, float znear, float zfar)
	{
		float yScale = (float)(1.0f / tanf(fov * 0.5f));
		float q = zfar / (znear - zfar);

		m[0] = yScale / aspect;
		m[5] = yScale;
		m[10] = q;
		m[11] = -1.0f;
		m[14] = q * znear;
	}

	DECLDIR void matrix4x4Project(float *v1, float *v2, float *m, float x, float y, float width, float height, float minZ, float maxZ)
	{		
		matrix4x4TransformCoordinate(v1, v2, m);
		float v1_x = v1[0];
		float v1_y = v1[1];
		float v1_z = v1[2];

		v1[0] = ((1.0f + v1_x) * 0.5f * width) + x;
		v1[1] = ((1.0f - v1_y) * 0.5f * height) + y;
		v1[2] = (v1_z * (maxZ - minZ)) + minZ;
	}

	// VECTOR3
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

	// QUATERNION
	DECLDIR void quaternionRotationYawPitchRoll(float *q, float yaw, float pitch, float roll)
	{
		float halfRoll = roll * 0.5f;
		float halfPitch = pitch * 0.5f;
		float halfYaw = yaw * 0.5f;

		float sinRoll = sinf(halfRoll);
		float cosRoll = cosf(halfRoll);
		float sinPitch = sinf(halfPitch);
		float cosPitch = cosf(halfPitch);
		float sinYaw = sinf(halfYaw);
		float cosYaw = cosf(halfYaw);

		q[0] = (cosYaw * sinPitch * cosRoll) + (sinYaw * cosPitch * sinRoll);
		q[1] = (sinYaw * cosPitch * cosRoll) - (cosYaw * sinPitch * sinRoll);
		q[2] = (cosYaw * cosPitch * sinRoll) - (sinYaw * sinPitch * cosRoll);
		q[3] = (cosYaw * cosPitch * cosRoll) + (sinYaw * sinPitch * sinRoll);
	}
}