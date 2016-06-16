#include "math3d.h"
#include "stdlib.h"
#include "stdio.h"
#include <math.h>

extern "C"
{
	// MATRIX 4x4
	DECLDIR void matrix4x4Zero(matrix4x4 *m)
	{
		m->M11 = m->M12 = m->M13 = m->M14 = 0;
		m->M21 = m->M22 = m->M23 = m->M24 = 0;
		m->M31 = m->M32 = m->M33 = m->M34 = 0;
		m->M41 = m->M42 = m->M43 = m->M44 = 0;
	}

	DECLDIR void matrix4x4Identity(matrix4x4 *m)
	{
		m->M11 = m->M22 = m->M33 = m->M44 = 1;
		m->M12 = m->M13 = m->M14 = m->M21 = m->M23 = m->M24 = m->M31 = m->M32 = m->M34 = m->M41 = m->M42 = m->M43 = 0;			
	}

	DECLDIR void matrix4x4Transpose(matrix4x4 *result, matrix4x4 *m)
	{
		result->M11 = m->M11; 
		result->M12 = m->M21; 
		result->M13 = m->M31; 
		result->M14 = m->M41;
		result->M21 = m->M12; 
		result->M22 = m->M22; 
		result->M23 = m->M32; 
		result->M24 = m->M42;
		result->M31 = m->M13; 
		result->M32 = m->M23; 
		result->M33 = m->M33; 
		result->M34 = m->M43;
		result->M41 = m->M14; 
		result->M42 = m->M24; 
		result->M43 = m->M34; 
		result->M44 = m->M44;
	}

	DECLDIR void matrix4x4ScalarMultiply(matrix4x4 *result, matrix4x4 *left, float right)
	{
		result->M11 = left->M11 * right;
		result->M12 = left->M12 * right;
		result->M13 = left->M13 * right;
		result->M14 = left->M14 * right;
		result->M21 = left->M21 * right;
		result->M22 = left->M22 * right;
		result->M23 = left->M23 * right;
		result->M24 = left->M24 * right;
		result->M31 = left->M31 * right;
		result->M32 = left->M32 * right;
		result->M33 = left->M33 * right;
		result->M34 = left->M34 * right;
		result->M41 = left->M41 * right;
		result->M42 = left->M42 * right;
		result->M43 = left->M43 * right;
		result->M44 = left->M44 * right;
	}

	DECLDIR void matrix4x4Multiply(matrix4x4 *result, matrix4x4 *left, matrix4x4 *right)
	{
		result->M11 = (left->M11 * right->M11) + (left->M12 * right->M21) + (left->M13 * right->M31) + (left->M14 * right->M41);
		result->M12 = (left->M11 * right->M12) + (left->M12 * right->M22) + (left->M13 * right->M32) + (left->M14 * right->M42);
		result->M13 = (left->M11 * right->M13) + (left->M12 * right->M23) + (left->M13 * right->M33) + (left->M14 * right->M43);
		result->M14 = (left->M11 * right->M14) + (left->M12 * right->M24) + (left->M13 * right->M34) + (left->M14 * right->M44);
		result->M21 = (left->M21 * right->M11) + (left->M22 * right->M21) + (left->M23 * right->M31) + (left->M24 * right->M41);
		result->M22 = (left->M21 * right->M12) + (left->M22 * right->M22) + (left->M23 * right->M32) + (left->M24 * right->M42);
		result->M23 = (left->M21 * right->M13) + (left->M22 * right->M23) + (left->M23 * right->M33) + (left->M24 * right->M43);
		result->M24 = (left->M21 * right->M14) + (left->M22 * right->M24) + (left->M23 * right->M34) + (left->M24 * right->M44);
		result->M31 = (left->M31 * right->M11) + (left->M32 * right->M21) + (left->M33 * right->M31) + (left->M34 * right->M41);
		result->M32 = (left->M31 * right->M12) + (left->M32 * right->M22) + (left->M33 * right->M32) + (left->M34 * right->M42);
		result->M33 = (left->M31 * right->M13) + (left->M32 * right->M23) + (left->M33 * right->M33) + (left->M34 * right->M43);
		result->M34 = (left->M31 * right->M14) + (left->M32 * right->M24) + (left->M33 * right->M34) + (left->M34 * right->M44);
		result->M41 = (left->M41 * right->M11) + (left->M42 * right->M21) + (left->M43 * right->M31) + (left->M44 * right->M41);
		result->M42 = (left->M41 * right->M12) + (left->M42 * right->M22) + (left->M43 * right->M32) + (left->M44 * right->M42);
		result->M43 = (left->M41 * right->M13) + (left->M42 * right->M23) + (left->M43 * right->M33) + (left->M44 * right->M43);
		result->M44 = (left->M41 * right->M14) + (left->M42 * right->M24) + (left->M43 * right->M34) + (left->M44 * right->M44);
	}	

	DECLDIR void matrix4x4Add(matrix4x4 *result, matrix4x4 *left, matrix4x4 *right)
	{
		result->M11 = left->M11 + right->M11;
		result->M12 = left->M12 + right->M12;
		result->M13 = left->M13 + right->M13;
		result->M14 = left->M14 + right->M14;
		result->M21 = left->M21 + right->M21;
		result->M22 = left->M22 + right->M22;
		result->M23 = left->M23 + right->M23;
		result->M24 = left->M24 + right->M24;
		result->M31 = left->M31 + right->M31;
		result->M32 = left->M32 + right->M32;
		result->M33 = left->M33 + right->M33;
		result->M34 = left->M34 + right->M34;
		result->M41 = left->M41 + right->M41;
		result->M42 = left->M42 + right->M42;
		result->M43 = left->M43 + right->M43;
		result->M44 = left->M44 + right->M44;
	}

	DECLDIR void matrix4x4Subtract(matrix4x4 *result, matrix4x4 *left, matrix4x4 *right)
	{
		result->M11 = left->M11 - right->M11;
		result->M12 = left->M12 - right->M12;
		result->M13 = left->M13 - right->M13;
		result->M14 = left->M14 - right->M14;
		result->M21 = left->M21 - right->M21;
		result->M22 = left->M22 - right->M22;
		result->M23 = left->M23 - right->M23;
		result->M24 = left->M24 - right->M24;
		result->M31 = left->M31 - right->M31;
		result->M32 = left->M32 - right->M32;
		result->M33 = left->M33 - right->M33;
		result->M34 = left->M34 - right->M34;
		result->M41 = left->M41 - right->M41;
		result->M42 = left->M42 - right->M42;
		result->M43 = left->M43 - right->M43;
		result->M44 = left->M44 - right->M44;
	}

	DECLDIR void matrix4x4Inverse(matrix4x4 *result, matrix4x4 *value)
	{
		float b0 = (value->M31 * value->M42) - (value->M32 * value->M41);
		float b1 = (value->M31 * value->M43) - (value->M33 * value->M41);
		float b2 = (value->M34 * value->M41) - (value->M31 * value->M44);
		float b3 = (value->M32 * value->M43) - (value->M33 * value->M42);
		float b4 = (value->M34 * value->M42) - (value->M32 * value->M44);
		float b5 = (value->M33 * value->M44) - (value->M34 * value->M43);

		float d11 = value->M22 * b5 + value->M23 * b4 + value->M24 * b3;
		float d12 = value->M21 * b5 + value->M23 * b2 + value->M24 * b1;
		float d13 = value->M21 * -b4 + value->M22 * b2 + value->M24 * b0;
		float d14 = value->M21 * b3 + value->M22 * -b1 + value->M23 * b0;

		float det = value->M11 * d11 - value->M12 * d12 + value->M13 * d13 - value->M14 * d14;
		
		if (fabs(det) == 0.0f)
		{
			matrix4x4Zero(result);
			return;
		}

		det = 1.0f / det;

		float a0 = (value->M11 * value->M22) - (value->M12 * value->M21);
		float a1 = (value->M11 * value->M23) - (value->M13 * value->M21);
		float a2 = (value->M14 * value->M21) - (value->M11 * value->M24);
		float a3 = (value->M12 * value->M23) - (value->M13 * value->M22);
		float a4 = (value->M14 * value->M22) - (value->M12 * value->M24);
		float a5 = (value->M13 * value->M24) - (value->M14 * value->M23);

		float d21 = value->M12 * b5 + value->M13 * b4 + value->M14 * b3;
		float d22 = value->M11 * b5 + value->M13 * b2 + value->M14 * b1;
		float d23 = value->M11 * -b4 + value->M12 * b2 + value->M14 * b0;
		float d24 = value->M11 * b3 + value->M12 * -b1 + value->M13 * b0;

		float d31 = value->M42 * a5 + value->M43 * a4 + value->M44 * a3;
		float d32 = value->M41 * a5 + value->M43 * a2 + value->M44 * a1;
		float d33 = value->M41 * -a4 + value->M42 * a2 + value->M44 * a0;
		float d34 = value->M41 * a3 + value->M42 * -a1 + value->M43 * a0;

		float d41 = value->M32 * a5 + value->M33 * a4 + value->M34 * a3;
		float d42 = value->M31 * a5 + value->M33 * a2 + value->M34 * a1;
		float d43 = value->M31 * -a4 + value->M32 * a2 + value->M34 * a0;
		float d44 = value->M31 * a3 + value->M32 * -a1 + value->M33 * a0;

		result->M11 = +d11 * det; result->M12 = -d21 * det; result->M13 = +d31 * det; result->M14 = -d41 * det;
		result->M21 = -d12 * det; result->M22 = +d22 * det; result->M23 = -d32 * det; result->M24 = +d42 * det;
		result->M31 = +d13 * det; result->M32 = -d23 * det; result->M33 = +d33 * det; result->M34 = -d43 * det;
		result->M41 = -d14 * det; result->M42 = +d24 * det; result->M43 = -d34 * det; result->M44 = +d44 * det;		
	}

	DECLDIR void matrix4x4TransformCoordinate(vector3 *result, vector3 *coordinate, matrix4x4 *transform)
	{
		float x = (coordinate->X * transform->M11) + (coordinate->Y * transform->M21) + (coordinate->Z * transform->M31) + transform->M41;
		float y = (coordinate->X * transform->M12) + (coordinate->Y * transform->M22) + (coordinate->Z * transform->M32) + transform->M42;
		float z = (coordinate->X * transform->M13) + (coordinate->Y * transform->M23) + (coordinate->Z * transform->M33) + transform->M43;
		float w = 1.0f / ((coordinate->X * transform->M14) + (coordinate->Y * transform->M24) + (coordinate->Z * transform->M34) + transform->M44);

		result->X = x * w;
		result->Y = y * w;
		result->Z = z * w;
	}

	DECLDIR void matrix4x4Translation(matrix4x4 *result, vector3 *vector)
	{
		matrix4x4Identity(result);
		result->M41 = vector->X;
		result->M42 = vector->Y;
		result->M43 = vector->Z;
	}

	DECLDIR void matrix4x4RotationYawPitchRoll(matrix4x4 *result, vector3 *vector)
	{
		quaternion q;
		quaternionRotationYawPitchRoll(&q, vector);
		matrix4x4RotationQuaternion(result, &q);
	}

	DECLDIR void matrix4x4RotationQuaternion(matrix4x4 *result, quaternion *rotation)
	{
		float xx = rotation->X * rotation->X;
		float yy = rotation->Y * rotation->Y;
		float zz = rotation->Z * rotation->Z;
		float xy = rotation->X * rotation->Y;
		float zw = rotation->Z * rotation->W;
		float zx = rotation->Z * rotation->X;
		float yw = rotation->Y * rotation->W;
		float yz = rotation->Y * rotation->Z;
		float xw = rotation->X * rotation->W;

		matrix4x4Identity(result);
		result->M11 = 1.0f - (2.0f * (yy + zz));
		result->M12 = 2.0f * (xy + zw);
		result->M13 = 2.0f * (zx - yw);
		result->M21 = 2.0f * (xy - zw);
		result->M22 = 1.0f - (2.0f * (zz + xx));
		result->M23 = 2.0f * (yz + xw);
		result->M31 = 2.0f * (zx + yw);
		result->M32 = 2.0f * (yz - xw);
		result->M33 = 1.0f - (2.0f * (yy + xx));
	}

	DECLDIR void matrix4x4LookAtLH(matrix4x4 *result, vector3 *eye, vector3 *target, vector3 *up)
	{	
		vector3 xaxis, yaxis, zaxis;		
		vector3Subtract(&zaxis, target, eye);		
		vector3Normalize(&zaxis, &zaxis);
		vector3Cross(&xaxis, up, &zaxis);
		vector3Normalize(&xaxis, &xaxis);
		vector3Cross(&yaxis, &zaxis, &xaxis);
		matrix4x4Identity(result);

		result->M11 = xaxis.X; result->M21 = xaxis.Y; result->M31 = xaxis.Z;
		result->M12 = yaxis.X; result->M22 = yaxis.Y; result->M32 = yaxis.Z;
		result->M13 = zaxis.X; result->M23 = zaxis.Y; result->M33 = zaxis.Z;

		result->M41 = -vector3Dot(&xaxis, eye);
		result->M42 = -vector3Dot(&yaxis, eye);
		result->M43 = -vector3Dot(&zaxis, eye);		
	}

	DECLDIR void matrix4x4PerspectiveFovRH(matrix4x4 *result, float fov, float aspect, float znear, float zfar)
	{
		float yScale = (float)(1.0f / tanf(fov * 0.5f));
		float q = zfar / (znear - zfar);

		result->M11 = yScale / aspect;
		result->M22 = yScale;
		result->M33 = q;
		result->M34 = -1.0f;
		result->M43 = q * znear;
	}

	DECLDIR void matrix4x4Project(vector3 *result, vector3 *vin, matrix4x4 *m, float x, float y, float width, float height, float minZ, float maxZ)
	{	
		vector3 v;
		matrix4x4TransformCoordinate(&v, vin, m);

		result->X = ((1.0f + v.X) * 0.5f * width) + x;
		result->Y = ((1.0f - v.Y) * 0.5f * height) + y;
		result->Z = (v.Z * (maxZ - minZ)) + minZ;
	}

	DECLDIR void matrix4x4TransformNormal(vector3 *result, vector3 *normal, matrix4x4 *transform)
	{
		result->X = (normal->X * transform->M11) + (normal->Y * transform->M21) + (normal->Z * transform->M31);
		result->Y = (normal->X * transform->M12) + (normal->Y * transform->M22) + (normal->Z * transform->M32);
		result->Z = (normal->X * transform->M13) + (normal->Y * transform->M23) + (normal->Z * transform->M33);
	}

	// VECTOR2
	DECLDIR void vector2ScalarAdd(vector2 *result, vector2 *v1, float v)
	{
		result->X = v1->X + v;
		result->Y = v1->Y + v;
	}

	DECLDIR void vector2Add(vector2 *result, vector2 *v1, vector2 *v2)
	{
		result->X = v1->X + v2->X;
		result->Y = v1->Y + v2->Y;
	}

	DECLDIR void vector2ScalarSubtract(vector2 *result, vector2 *v1, float v)
	{
		result->X = v1->X - v;
		result->Y = v1->Y - v;
	}

	DECLDIR void vector2Subtract(vector2 *result, vector2 *v1, vector2 *v2)
	{
		result->X = v1->X - v2->X;
		result->Y = v1->Y - v2->Y;
	}

	DECLDIR void vector2ScalarMultiply(vector2 *result, vector2 *v1, float v)
	{
		result->X = v1->X * v;
		result->Y = v1->Y * v;
	}

	DECLDIR void vector2ScalarDivide(vector2 *result, vector2 *v1, float v)
	{
		result->X = v1->X / v;
		result->Y = v1->Y / v;
	}

	DECLDIR float vector2Dot(vector2 *v1, vector2 *v2)
	{
		return v1->X * v2->X + v1->Y * v2->Y;
	}

	DECLDIR float vector2LengthSquared(vector2 *v1)
	{
		return v1->X * v1->X + v1->Y * v1->Y;
	}

	DECLDIR float vector2Length(vector2 *v1)
	{
		return sqrtf(vector2LengthSquared(v1));
	}

	DECLDIR float vector2DistanceSquared(vector2 *v1, vector2 *v2)
	{
		float dx = v1->X - v2->X;
		float dy = v1->Y - v2->Y;

		return dx * dx + dy * dy;
	}

	DECLDIR float vector2Distance(vector2 *v1, vector2 *v2)
	{
		return sqrtf(vector2DistanceSquared(v1, v2));
	}

	DECLDIR void vector2Normalize(vector2 *result, vector2 *v1)
	{
		float l = vector2Length(v1);
		result->X = v1->X / l;
		result->Y = v1->Y / l;
	}

	// VECTOR3
	DECLDIR void vector3ScalarAdd(vector3 *result, vector3 *v1, float v)
	{
		result->X = v1->X + v;
		result->Y = v1->Y + v;
		result->Z = v1->Z + v;		
	}

	DECLDIR void vector3Add(vector3 *result, vector3 *v1, vector3 *v2)
	{
		result->X = v1->X + v2->X;
		result->Y = v1->Y + v2->Y;
		result->Z = v1->Z + v2->Z;
	}

	DECLDIR void vector3ScalarSubtract(vector3 *result, vector3 *v1, float v)
	{
		result->X = v1->X - v;
		result->Y = v1->Y - v;
		result->Z = v1->Z - v;
	}

	DECLDIR void vector3Subtract(vector3 *result, vector3 *v1, vector3 *v2)
	{
		result->X = v1->X - v2->X;
		result->Y = v1->Y - v2->Y;
		result->Z = v1->Z - v2->Z;
	}

	DECLDIR void vector3ScalarMultiply(vector3 *result, vector3 *v1, float v)
	{
		result->X = v1->X * v;
		result->Y = v1->Y * v;
		result->Z = v1->Z * v;
	}

	DECLDIR void vector3ScalarDivide(vector3 *result, vector3 *v1, float v)
	{
		result->X = v1->X / v;
		result->Y = v1->Y / v;
		result->Z = v1->Z / v;
	}

	DECLDIR float vector3Dot(vector3 *v1, vector3 *v2)
	{
		return v1->X * v2->X + v1->Y * v2->Y + v1->Z * v2->Z;
	}

	DECLDIR void vector3Cross(vector3 *result, vector3 *v1, vector3 *v2)
	{
		result->X = v1->Y * v2->Z - v1->Z * v2->Y;
		result->Y = v1->Z * v2->X - v1->X * v2->Z;
		result->Z = v1->X * v2->Y - v1->Y * v2->X;
	}
	
	DECLDIR float vector3LengthSquared(vector3 *v1)
	{
		return v1->X * v1->X + v1->Y * v1->Y + v1->Z * v1->Z;
	}

	DECLDIR float vector3Length(vector3 *v1)
	{
		return sqrtf(vector3LengthSquared(v1));
	}

	DECLDIR float vector3DistanceSquared(vector3 *v1, vector3 *v2)
	{
		float dx = v1->X - v2->X;
		float dy = v1->Y - v2->Y;
		float dz = v1->Z - v2->Z;

		return dx * dx + dy * dy + dz * dz;
	}

	DECLDIR float vector3Distance(vector3 *v1, vector3 *v2)
	{
		return sqrtf(vector3DistanceSquared(v1, v2));
	}

	DECLDIR void vector3Normalize(vector3 *result, vector3 *v1)
	{
		float l = vector3Length(v1);
		result->X = v1->X / l;
		result->Y = v1->Y / l;
		result->Z = v1->Z / l;
	}

	// QUATERNION
	DECLDIR void quaternionRotationYawPitchRoll(quaternion *q, vector3 *v)
	{
		float halfYaw = v->X * 0.5f;
		float halfPitch = v->Y * 0.5f;
		float halfRoll = v->Z * 0.5f;			

		float sinRoll = sinf(halfRoll);
		float cosRoll = cosf(halfRoll);
		float sinPitch = sinf(halfPitch);
		float cosPitch = cosf(halfPitch);
		float sinYaw = sinf(halfYaw);
		float cosYaw = cosf(halfYaw);

		q->X = (cosYaw * sinPitch * cosRoll) + (sinYaw * cosPitch * sinRoll);
		q->Y = (sinYaw * cosPitch * cosRoll) - (cosYaw * sinPitch * sinRoll);
		q->Z = (cosYaw * cosPitch * sinRoll) - (sinYaw * sinPitch * cosRoll);
		q->W = (cosYaw * cosPitch * cosRoll) + (sinYaw * sinPitch * sinRoll);
	}

	DECLDIR void render(rgba_pixel *buffer, uint32_t width, uint32_t height)
	{
		matrix4x4 viewMatrix;
		matrix4x4 projectionMatrix;
		matrix4x4 rotationMatrix;
		matrix4x4 tranlsationMatrix;
		matrix4x4 worldMatrix;
		matrix4x4 worldViewMatrix;
		matrix4x4 worldViewProjectionMatrix;
		vector3 worldVert;
		vector3 forwardVector;

		vector3 cameraPosition;
		vector3 cameraTarget;
		vector3 up;

		cameraPosition.X = 0;
		cameraPosition.Y = 0;
		cameraPosition.Z = 10;

		cameraTarget.X = 0;
		cameraTarget.Y = 0;
		cameraTarget.Z = 0;

		up.X = 0;
		up.Y = 1;
		up.Z = 0;

		matrix4x4LookAtLH(&viewMatrix, &cameraPosition, &cameraTarget, &up);
		matrix4x4PerspectiveFovRH(&projectionMatrix, 0.78f, 1200 / 900, 0.001f, 1);

		mesh cube;
		cube.vertCount = 8;
		cube.faceCount = 8;

		cube.rotation.X = 0;
		cube.rotation.Y = 0;
		cube.rotation.Z = 0;

		cube.position.X = 0;
		cube.position.Y = 0;
		cube.position.Z = 0;

		vector3 vertices[8];
		vertices[0].X = -1;
		vertices[0].Y = 1;
		vertices[0].Z = 1;
		vertices[1].X = 1;
		vertices[1].Y = 1;
		vertices[1].Z = 1;
		vertices[2].X = -1;
		vertices[2].Y = -1;
		vertices[2].Z = 1;
		vertices[3].X = 1;
		vertices[3].Y = -1;
		vertices[3].Z = 1;
		vertices[4].X = 1;
		vertices[4].Y = -1;
		vertices[4].Z = -1;
		vertices[5].X = 1;
		vertices[5].Y = 1;
		vertices[5].Z = -1;
		vertices[6].X = -1;
		vertices[6].Y = -1;
		vertices[6].Z = -1;
		vertices[7].X = -1;
		vertices[7].Y = 1;
		vertices[7].Z = -1;
		cube.vertices = vertices;

		face faces[8];
		faces[0].A = 1;
		faces[0].A = 3;
		faces[0].A = 5;
		faces[0].r = 255 * 0.85;
		faces[0].g = 255 * 0.85;
		faces[0].b = 255 * 0.85;

		/*
		local mesh = FFIMesh.newMesh(8, 8)
		

		l

		local f = faces[1]
		f.A = 3
		f.B = 4
		f.C = 5
		f.r = r * 0.85
		f.g = g * 0.85
		f.b = b * 0.85

		local f = faces[2]
		f.A = 0
		f.B = 7
		f.C = 2
		f.r = r * 0.85
		f.g = g * 0.85
		f.b = b * 0.85

		local f = faces[3]
		f.A = 6
		f.B = 2
		f.C = 7
		f.r = r * 0.85
		f.g = g * 0.85
		f.b = b * 0.85

		local f = faces[4]
		f.A = 1
		f.B = 7
		f.C = 0
		f.r = r * 0.75
		f.g = g * 0.75
		f.b = b * 0.75

		local f = faces[5]
		f.A = 5
		f.B = 7
		f.C = 1
		f.r = r * 0.75
		f.g = g * 0.75
		f.b = b * 0.75

		local f = faces[6]
		f.A = 0
		f.B = 1
		f.C = 2
		f.r = r
		f.g = g
		f.b = b

		local f = faces[7]
		f.A = 1
		f.B = 2
		f.C = 3
		f.r = r
		f.g = g
		f.b = b

		FFIMesh.calculateMiddlesAndNormals(mesh)

		return mesh
		*/
			/*
		int idx = 0;
		for (int y = 0;y < height;y++)
		{
			for (int x = 0;x < width;x++)
			{
				buffer[idx].r = 255;
				buffer[idx++].a = 255;
			}
		}
		*/
	}
}