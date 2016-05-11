local class = require 'libs/30log/30log'
local StoryFactory = class('StoryFactory')
local instance = StoryFactory()

local rootDirectory = '/data/stories/'

function StoryFactory.new() 
  error('Cannot instantiate StoryFactory') 
end

function StoryFactory.extend() 
  error('Cannot extend from a StoryFactory')
end

function StoryFactory:init()	
end

function StoryFactory:getInstance()
  return instance
end

function StoryFactory:createStory(storyName, gameWorld, hero)
	local storyCode, size = love.filesystem.read(rootDirectory .. storyName .. '.dat')
	local context = { gameWorld = gameWorld, hero = hero, math = math }
	local condition = assert(loadstring('return ' .. storyCode))
	setfenv(condition, context)
	return condition()
end

return StoryFactory