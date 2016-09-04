--local luabins = require 'luabins'

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
local TerrainTypeManager = require 'classes/managers/TerrainTypeManager'
TerrainTypeManager = TerrainTypeManager:getInstance()
local TerrainStripTypeManager = require 'classes/managers/TerrainStripTypeManager'
TerrainStripTypeManager = TerrainStripTypeManager:getInstance()
local ObjectiveTypeManager = require 'classes/managers/ObjectiveTypeManager'
ObjectiveTypeManager = ObjectiveTypeManager:getInstance()
local NameManager =  require 'classes/managers/NameManager'
NameManager = NameManager:getInstance()
local CharacterClassesManager = require 'classes/managers/CharacterClassesManager'
CharacterClassesManager = CharacterClassesManager:getInstance()
local RacesManager = require 'classes/managers/RacesManager'
RacesManager = RacesManager:getInstance()


local GameWorld = require 'classes/simulation/GameWorld'
--local Dialogue = require 'classes/simulation/Dialogue'
--local StoryScene = require 'classes/scene/StoryScene'
--local DialogueScene = require 'classes/scene/DialogueScene'
local RPGSimulationScene = require 'classes/scene/RPGSimulationScene'
	
local gameWorld
function love.load()
	print('----------------------------------------------------------------------')
	print('|                       love.load()                                  |')
	print('----------------------------------------------------------------------')		
	local features = love.graphics.getSupported()
	for k, v in pairs(features) do
		print(k,v)
	end
	
	math.randomseed(os.time())	

	NameManager:initialize()
	TerrainTypeManager:initialize()
	TerrainStripTypeManager:initialize()
	ObjectiveTypeManager:initialize()
	CharacterClassesManager:initialize()
	RacesManager:initialize()

	local font = love.graphics.newFont('data/fonts/courbd.ttf', 10)
	FontManager:addFont(font, 'Courier8')	
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
	gameWorld:generateNewWorld()


	SceneManager:addScene(RPGSimulationScene:new(gameWorld), 'rpgsimulation')
	SceneManager:show('rpgsimulation')	
	
	--SceneManager:show('story', StoryFactory:createStory('begin', gameWorld))
	
	--[[
	local hero = Character:new(gameWorld)
	hero.name = 'Kevin'
	gameWorld.hero = hero		
	
	local other = Character:new(gameWorld)
	other.name = 'Edna'
		
	local dialogue = Dialogue:new('gameIntro', 'start', gameWorld, hero, other)	
	SceneManager:show('dialogue', dialogue)
	]]
	
	
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
	love.graphics.print('FPS: ' .. love.timer.getFPS(), 0, 700)

--[[	
	local gameTime = gameWorld.gameTime
	local date = gameTime:getDateString('%A %B, %d %Y %I:%M:%S %p')
	love.graphics.print(date, 900, 0)
	love.graphics.print('speed: ' ..  gameTime.speedTexts[gameTime.currentSpeed], 900, 15)
	]]
end

function love.keypressed(key, scancode)
	local vs = SceneManager.visibleScenes
	for i = #vs, 1, -1 do
		local vScene = vs[i]	
		if vScene.keypressed then		
			vScene:keypressed(key, scancode)
		end
		if vScene.isBlocking then
			break
		end
	end		
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