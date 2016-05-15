local luabins = require 'luabins'

print()
print('----------------------------------------------------------------------')
print('|                       START LUA EXECUTION                          |')
print('----------------------------------------------------------------------')

local jv = jit.version
print('----------------------------------------------------------------------')
print('|                       LuaJIT version                               |')
print('----------------------------------------------------------------------')
print(jv)
	
local SceneManager = require 'classes/scene/SceneManager'
SceneManager = SceneManager:getInstance()
local FontManager = require 'classes/scene/FontManager'
FontManager = FontManager:getInstance()
local StoryFactory = require 'classes/factories/StoryFactory'
StoryFactory = StoryFactory:getInstance()

local GameTime = require 'classes/simulation/GameTime'
local GameWorld = require 'classes/simulation/GameWorld'
local HotelScene = require 'classes/scene/HotelScene'
local BankScene = require 'classes/scene/BankScene'
local StoryScene = require 'classes/scene/StoryScene'
local DialogueScene = require 'classes/scene/DialogueScene'
local Character = require 'classes/simulation/Character'

local ShearTestScene = require 'classes/scene/ShearTestScene'
local RenderingPipelineTest = require 'classes/scene/RenderingPipelineTest'
local ShaderDebugScene = require 'classes/scene/ShaderDebugScene'
	
local gameWorld
function love.load()
	print('----------------------------------------------------------------------')
	print('|                       love.load()                                  |')
	print('----------------------------------------------------------------------')		
	local features = love.graphics.getSupported()
	for k, v in pairs(features) do
		print(k,v)
	end
	
	--local thread = love.thread.newThread('threads/world.lua')
	--thread:start()
	
	local font = love.graphics.newFont('data/fonts/courbd.ttf', 12)
	FontManager:addFont(font, 'Courier12')
	local font = love.graphics.newFont('data/fonts/courbd.ttf', 16)
	FontManager:addFont(font, 'Courier16')
	font = love.graphics.newFont('data/fonts/courbd.ttf', 32)
	FontManager:addFont(font, 'Courier32')

	gameWorld = GameWorld:new()
	local gameTime = GameTime:new()
	gameTime:setTime(2016, 2, 1, 7, 55, 0)
	gameTime:setSpeed(5)
	gameWorld.gameTime = gameTime
		
	local hero = Character:new(gameWorld)
	hero.name = 'Kevin'
	gameWorld.hero = hero
				
	SceneManager:addScene(BankScene:new(gameWorld), 'bank')
	SceneManager:addScene(HotelScene:new(gameWorld), 'hotel')
	SceneManager:addScene(StoryScene:new(gameWorld), 'story')
	SceneManager:addScene(DialogueScene:new(gameWorld), 'dialogue')
	
	SceneManager:addScene(ShearTestScene:new(gameWorld), 'shearTest')
	SceneManager:show('shearTest')
	SceneManager:addScene(ShaderDebugScene:new(gameWorld), 'shaderDebug')
	--SceneManager:show('shaderDebug')
	
	--SceneManager:addScene(RenderingPipelineTest:new(gameWorld), 'renderingPipelineTest')	
	--SceneManager:show('renderingPipelineTest')
	
	--SceneManager:show('bank')
	--SceneManager:show('story', StoryFactory:createStory('begin', gameWorld))
end

function love.update(dt)
	collectgarbage("step", 500)

	gameWorld:update(dt)
	
	local vs = SceneManager.visibleScenes
	
	for i = #vs, 1, -1 do
		local vScene = vs[i]
		vScene:update(dt)
		if vScene.isBlocking then
			break
		end
	end	
end

function love.draw()
	local vs = SceneManager.visibleScenes	
	for i = 1, #vs do
		local vScene = vs[i]
		vScene:draw()
	end		

	love.graphics.setFont(FontManager:getFont('Courier12'))	
	love.graphics.setColor(255,255,255)
	love.graphics.print('FPS: ' .. love.timer.getFPS(), 0, 0)
	
	local gameTime = gameWorld.gameTime
	local date = gameTime:getDateString('%A %B, %d %Y %I:%M:%S %p')
	love.graphics.print(date, 900, 0)
end

function love.keyreleased(key, scancode)
	local vs = SceneManager.visibleScenes
	for i = #vs, 1, -1 do
		local vScene = vs[i]		
		vScene:keyreleased(key, scancode)
		if vScene.isBlocking then
			break
		end
	end		
end

function love.threaderror(thread, errorstr)
  print("Thread error!\n"..errorstr)
end