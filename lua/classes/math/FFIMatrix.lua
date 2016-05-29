local class = require 'libs/30log/30log'
local FFIMatrix = class('FFIMatrix')
local instance = FFIMatrix()

local ffi = require 'ffi'
ffi.cdef[[
	typedef struct { uint32_t rows; uint32_t columns; double *data; } matrix;
]]

function FFIMatrix.new() 
  error('Cannot instantiate FFIMatrix')
end

function FFIMatrix.extend() 
  error('Cannot extend from a FFIMatrix')
end

function FFIMatrix:init()	
end

function FFIMatrix:getInstance()
  return instance
end

function FFIMatrix.newMatrix(rows, columns)
	local ffiMatrix = ffi.new('matrix')
	local ffiMatrixData = ffi.new('double[?]', rows * columns)
	ffiMatrix.data = ffiMatrixData
	ffiMatrix.rows = rows
	ffiMatrix.columns = columns	
	return ffiMatrix
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

return FFIMatrix