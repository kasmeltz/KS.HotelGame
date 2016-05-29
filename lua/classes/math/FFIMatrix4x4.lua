local class = require 'libs/30log/30log'
local FFIMatrix4x4 = class('FFIMatrix')
local instance = FFIMatrix4x4()

local ffi = require 'ffi'

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

function FFIMatrix4x4.newMatrix(
	r1c1, r1c2, r1c3, r1c4,
	r2c1, r2c2, r2c3, r2c4,
	r3c1, r3c2, r3c3, r3c4,
	r4c1, r4c2, r4c3, r4c4)
	
	local m = ffi.new('double[?]', 16)
	m[0] = r1c1
	m[1] = r1c2
	m[2] = r1c3
	m[3] = r1c4
	m[4] = r2c1
	m[5] = r2c2
	m[6] = r2c3
	m[7] = r2c4
	m[8] = r2c1
	m[9] = r2c2
	m[10] = r2c3
	m[11] = r2c4
	m[12] = r2c1
	m[13] = r2c2
	m[14] = r2c3
	m[15] = r2c4

	return m
end

function FFIMatrix.copy(m)
	local result = FFIMatrix.newMatrix(m.rows, m.columns)		
	local a = m.data
	local b = result.data
	local counter = m.rows * m.columns - 1
	for idx = 0, counter do
		b[idx] = a[idx]
	end		
	return result	
end

--[[
function FFIMatrix.setValue(m, r, c, v)
	local d = m.data
	local idx = r * m.columns + c
	d[idx] = v
end

function FFIMatrix.scalarMultiply(m, v)
	local result = FFIMatrix.newMatrix(m.rows, m.columns)		
	local a = m.data
	local b = result.data
	local counter = m.rows * m.columns - 1
	for idx = 0, counter do
		b[idx] = a[idx] * v
	end	
	return result
end

function FFIMatrix.scalarMultiplyInline(m, v)
	local a = m.data
	local counter = m.rows * m.columns - 1
	for idx = 0, counter do
		a[idx] = a[idx] * v
	end	
end

function FFIMatrix.multiply(m1, m2)
	local aRows, aCols = m1.rows, m1.columns
	local bRows, bCols = m2.rows, m2.columns
	
	if aRows ~= bCols or aCols ~= bRows then
		error('Matrix multiplication requires that #columns a = #rows b and #rows a = #columns b')
	end

	local a = m1.data
	local b = m2.data	

	local result = FFIMatrix.newMatrix(m1.rows, m2.columns)		
	local d = result.data
	local dRows, dCols = result.rows, result.columns
	
	for r = 0, aRows - 1 do
		for c = 0, bCols - 1 do
			local cell = 0
			for i = 0, aCols - 1 do
				local aIdx = r * aCols + i
				local bIdx = i * bCols + c			
				cell = cell + a[aIdx] * b[bIdx]
			end
			local mIdx = r * dCols + c
			d[mIdx] = cell
		end
	end
	
	return result
end

function FFIMatrix.scalarAdd(m, v)
	local result = FFIMatrix.newMatrix(m.rows, m.columns)		
	local a = m.data
	local b = result.data
	local counter = m.rows * m.columns - 1
	for idx = 0, counter do
		b[idx] = a[idx] + v
	end	
	return result
end

function FFIMatrix.scalarAddInline(m, v)
	local a = m.data
	local counter = m.rows * m.columns - 1
	for idx = 0, counter do
		a[idx] = a[idx] + v
	end	
end

function FFIMatrix.add(m1, m2)
	local aRows, aCols = m1.rows, m1.columns
	local bRows, bCols = m2.rows, m2.columns
	
	if aRows ~= bRows or aCols ~= bCols then
		error('Matrix multiplication requires that #columns a = #rows b and #rows a = #columns b')
	end

	local a = m1.data
	local b = m2.data	

	local result = FFIMatrix.newMatrix(m1.rows, m1.columns)		
	local c = result.data
	
	local counter = m1.rows * m1.columns - 1
	for idx = 0, counter do
		c[idx] = a[idx] + b[idx]
	end	
	
	return result
end

function FFIMatrix.addInline(m1, m2)
		local aRows, aCols = m1.rows, m1.columns
	local bRows, bCols = m2.rows, m2.columns
	
	if aRows ~= bRows or aCols ~= bCols then
		error('Matrix multiplication requires that #columns a = #rows b and #rows a = #columns b')
	end

	local a = m1.data
	local b = m2.data	
	
	local counter = m1.rows * m1.columns - 1
	for idx = 0, counter do
		a[idx] = a[idx] + b[idx]
	end	
end

function FFIMatrix.scalarSubtract(m, v)
	local result = FFIMatrix.newMatrix(m.rows, m.columns)		
	local a = m.data
	local b = result.data
	local counter = m.rows * m.columns - 1
	for idx = 0, counter do
		b[idx] = a[idx] - v
	end	
	return result
end

function FFIMatrix.scalarSubtractInline(m, v)
	local a = m.data
	local counter = m.rows * m.columns - 1
	for idx = 0, counter do
		a[idx] = a[idx] - v
	end	
end

function FFIMatrix.subtract(m1, m2)
	local aRows, aCols = m1.rows, m1.columns
	local bRows, bCols = m2.rows, m2.columns
	
	if aRows ~= bRows or aCols ~= bCols then
		error('Matrix multiplication requires that #columns a = #rows b and #rows a = #columns b')
	end

	local a = m1.data
	local b = m2.data	

	local result = FFIMatrix.newMatrix(m1.rows, m1.columns)		
	local c = result.data
	
	local counter = m1.rows * m1.columns - 1
	for idx = 0, counter do
		c[idx] = a[idx] - b[idx]
	end	
	
	return result
end

function FFIMatrix.subtractInline(m1, m2)
		local aRows, aCols = m1.rows, m1.columns
	local bRows, bCols = m2.rows, m2.columns
	
	if aRows ~= bRows or aCols ~= bCols then
		error('Matrix multiplication requires that #columns a = #rows b and #rows a = #columns b')
	end

	local a = m1.data
	local b = m2.data	
	
	local counter = m1.rows * m1.columns - 1
	for idx = 0, counter do
		a[idx] = a[idx] - b[idx]
	end	
end

function FFIMatrix.display(m, sep)
	local sep = sep or ' '
	local d = m.data
	print('[')
	local idx = 0
	for r = 0, m.rows - 1 do
		local s = ''
		s = s .. '['
		for c = 0, m.columns - 2 do
			s = s .. d[idx] .. sep
			idx = idx + 1
		end
		s = s .. d[idx] .. ']'
		idx = idx + 1
		print(s)
	end	
	print(']')
end

]]

return FFIMatrix4x4