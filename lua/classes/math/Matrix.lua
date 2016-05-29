local class = require 'libs/30log/30log'
local Matrix = class('Matrix')

function Matrix:init(rows, columns)
	if type(rows) == 'table' then
		self.matrix = rows
	else
		local m = {}
		for r = 1, rows do
			m[r] = {}
			for c = 1, columns do
				m[r][c] = 0
			end
		end
		self.matrix = m
	end
end

function Matrix:scalarMultiply(v)
	local a = self.matrix
	
	local aNumRows, aNumCols = #a, #a[1]
	
	local result = Matrix:new(aNumRows, aNumCols)
	local m = result.matrix
	
	for r = 1, aNumRows do
		for c = 1, aNumCols do
			m[r][c] = a[r][c] * v
		end
	end
	
	return result
end

function Matrix:matrixMultiply(other)
	local a = self.matrix
	local b = other.matrix
	
	local aNumRows, aNumCols = #a, #a[1]
	local bNumRows, bNumCols = #b, #b[1]
	
	local result = Matrix:new(aNumRows, bNumCols)
	local m = result.matrix
	
	for r = 1, aNumRows do
		for c = 1, bNumCols do
			local cell = 0
			for i = 1, aNumCols do
				cell = cell + a[r][i] * b[i][c]
			end
			m[r][c] = cell
		end
	end
	
	return result
end

function Matrix.__mul(m1, m2)
	if type(m2) == 'table' then
		return m1:matrixMultiply(m2)
	else
		return m1:scalarMultiply(m2)
	end	
end

function Matrix:scalarAdd(v)
	local a = self.matrix
	
	local aNumRows, aNumCols = #a, #a[1]
	
	local result = Matrix:new(aNumRows, aNumCols)
	local m = result.matrix
	
	for r = 1, aNumRows do
		for c = 1, aNumCols do
			m[r][c] = a[r][c] + v
		end
	end
	
	return result
end

function Matrix:matrixAdd(other)
	local a = self.matrix
	local b = other.matrix
	
	local aNumRows, aNumCols = #a, #a[1]
	
	local result = Matrix:new(aNumRows, aNumCols)
	local m = result.matrix
	
	for r = 1, aNumRows do
		for c = 1, aNumCols do
			m[r][c] = a[r][c] + b[r][c]
		end
	end
	
	return result
end

function Matrix.__add(m1, m2)
	if type(m2) == 'table' then
		return m1:matrixAdd(m2)
	else
		return m1:scalarAdd(m2)
	end	
end

function Matrix:display(sep)
	local sep = sep or ' '
	local m = self.matrix
	print('[')
	for r = 1, #m do
		print('[ ' .. table.concat(m[r], sep) .. ']')
	end	
	print(']')
end

return Matrix