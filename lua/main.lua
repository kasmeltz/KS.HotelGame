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

--[[
for _, file in ipairs(love.filesystem.getDirectoryItems('classes/scene')) do
	local scene = require ('classes/scene/' .. file:gsub('.lua', ''))
end
]]

local GameTime = require 'classes/simulation/GameTime'
local Dialogue = require 'classes/simulation/Dialogue'
local GameWorld = require 'classes/simulation/GameWorld'
local HotelScene = require 'classes/scene/HotelScene'
local BankScene = require 'classes/scene/BankScene'
local StoryScene = require 'classes/scene/StoryScene'
local DialogueScene = require 'classes/scene/DialogueScene'
local Character = require 'classes/simulation/Character'
local ShearTestScene = require 'classes/scene/ShearTestScene'
local RenderingPipelineTest = require 'classes/scene/RenderingPipelineTest'
local ShaderDebugScene = require 'classes/scene/ShaderDebugScene'
local SchmupScene = require 'classes/scene/SchmupScene'
local ColorMatchScene = require 'classes/scene/ColorMatchScene'
local SpaceSimulatorScene = require 'classes/scene/SpaceSimulatorScene'
local TowerDefenseScene = require 'classes/scene/TowerDefenseScene'

local LongTimeScene = require 'classes/scene/LongTimeScene'
local HoboDefenseTitleScene = require 'classes/scene/HoboDefenseTitleScene'
local HoboGameScene = require 'classes/scene/HoboGameScene'
	
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
	font = love.graphics.newFont('data/fonts/courbd.ttf', 64)
	FontManager:addFont(font, 'Courier64')
	font = love.graphics.newFont('data/fonts/comicbd.ttf', 48)
	FontManager:addFont(font, 'ComicBold48')
	font = love.graphics.newFont('data/fonts/Dirty Fox.ttf', 48)
	FontManager:addFont(font, 'DirtyFox')
	font = love.graphics.newFont('data/fonts/arialbd.ttf', 92)
	FontManager:addFont(font, 'ArialBold92')
		
	gameWorld = GameWorld:new()
	local gameTime = GameTime:new()
	gameTime:setTime(2016, 2, 1, 7, 55, 0)
	gameTime:setSpeed(5)
	gameWorld.gameTime = gameTime
		
	
				
	--SceneManager:addScene(BankScene:new(gameWorld), 'bank')
	--SceneManager:addScene(HotelScene:new(gameWorld), 'hotel')
	--SceneManager:addScene(StoryScene:new(gameWorld), 'story')
	
	--SceneManager:addScene(ShearTestScene:new(gameWorld), 'shearTest')
	--SceneManager:addScene(ShaderDebugScene:new(gameWorld), 'shaderDebug')	
	--SceneManager:addScene(SchmupScene:new(gameWorld), 'schmup')
	--SceneManager:addScene(RenderingPipelineTest:new(gameWorld), 'renderingPipelineTest')	
	--SceneManager:addScene(ColorMatchScene:new(gameWorld), 'colorMatch')	
	--SceneManager:show('colorMatch')
	--SceneManager:addScene(SchmupScene:new(gameWorld), 'schmup')
	--SceneManager:show('schmup')
	--SceneManager:addScene(SpaceSimulatorScene:new(gameWorld), 'ss')
	--SceneManager:show('ss')	
	
	SceneManager:addScene(LongTimeScene:new(gameWorld), 'longtime')
	SceneManager:addScene(HoboDefenseTitleScene:new(gameWorld), 'hobodefensetitle')	
	SceneManager:addScene(HoboGameScene:new(gameWorld), 'hobogame')	
	--SceneManager:show('hobogame')	
		
	--[[
	local hero = Character:new(gameWorld)
	hero.name = 'Kevin'
	gameWorld.hero = hero		
	
	local other = Character:new(gameWorld)
	other.name = 'Edna'
		
	local dialogue = Dialogue:new('gameIntro', 'start', gameWorld, hero, other)
	SceneManager:addScene(DialogueScene:new(gameWorld), 'dialogue')		
	SceneManager:show('dialogue', dialogue)
	]]	
	
	SceneManager:show('longtime')	
	--SceneManager:show('hobodefensetitle')	
	--SceneManager:show('ss')		
	--SceneManager:show('shaderDebug')
	
	--SceneManager:show('shearTest')
	--SceneManager:show('shaderDebug')		
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
	love.graphics.clear()
	
	local vs = SceneManager.visibleScenes	
	for i = 1, #vs do
		local vScene = vs[i]
		vScene:draw()
	end		

	love.graphics.setFont(FontManager:getFont('Courier12'))	
	love.graphics.setColor(255,255,255)
	love.graphics.print('FPS: ' .. love.timer.getFPS(), 0, 0)

--[[	
	local gameTime = gameWorld.gameTime
	local date = gameTime:getDateString('%A %B, %d %Y %I:%M:%S %p')
	love.graphics.print(date, 900, 0)
	love.graphics.print('speed: ' ..  gameTime.speedTexts[gameTime.currentSpeed], 900, 15)
	]]
end

function love.keyreleased(key, scancode)
	local vs = SceneManager.visibleScenes
	for i = #vs, 1, -1 do
		local vScene = vs[i]	
		if vScene.keyreleased then		
			vScene:keyreleased(key, scancode)
		end
		if vScene.isBlocking then
			break
		end
	end		
end

function love.mousereleased(x, y, button, istouch)
	local vs = SceneManager.visibleScenes
	for i = #vs, 1, -1 do
		local vScene = vs[i]	
		if vScene.mousereleased then				
			vScene:mousereleased(x, y, button, istouch)
		end
		if vScene.isBlocking then
			break
		end
	end		
end

function love.mousepressed(x, y, button, istouch)
	local vs = SceneManager.visibleScenes
	for i = #vs, 1, -1 do
		local vScene = vs[i]
		if vScene.mousepressed then			
			vScene:mousepressed(x, y, button, istouch)
		end
		if vScene.isBlocking then
			break
		end
	end		
end

function love.mousemoved(x, y, button, istouch)
	local vs = SceneManager.visibleScenes
	for i = #vs, 1, -1 do
		local vScene = vs[i]	
		if vScene.mousemoved then					
			vScene:mousemoved(x, y, button, istouch)
		end
		if vScene.isBlocking then
			break
		end
	end		
end

function love.threaderror(thread, errorstr)
  print("Thread error!\n"..errorstr)
end