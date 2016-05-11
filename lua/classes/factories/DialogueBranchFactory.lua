local class = require 'libs/30log/30log'
local DialogueBranchFactory = class('DialogueFactory')
local instance = DialogueBranchFactory()

local rootDirectory = '/data/dialogues/'

function DialogueBranchFactory.new() 
  error('Cannot instantiate DialogueBranchFactory') 
end

function DialogueBranchFactory.extend() 
  error('Cannot extend from a DialogueBranchFactory')
end

function DialogueBranchFactory:init()	
end

function DialogueBranchFactory:getInstance()
  return instance
end

function DialogueBranchFactory:createBranches(dialogueName, gameWorld, hero, other)
	local dialogueText, size = love.filesystem.read(rootDirectory .. dialogueName .. '.dat')
	local context = { gameWorld = gameWorld, hero = hero, other = other }
	local condition = assert(loadstring('return ' .. dialogueText))
	setfenv(condition, context)
	return condition()
end

return DialogueBranchFactory