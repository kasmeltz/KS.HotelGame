local SceneManager = require 'classes/scene/SceneManager'
SceneManager = SceneManager:getInstance()
local FontManager = require 'classes/scene/FontManager'
FontManager = FontManager:getInstance()
local StoryFactory = require 'classes/factories/StoryFactory'
StoryFactory = StoryFactory:getInstance()

local GameWorld = require 'classes/simulation/GameWorld'
local HotelScene = require 'classes/scene/HotelScene'
local BankScene = require 'classes/scene/BankScene'
local StoryScene = require 'classes/scene/StoryScene'
local DialogueScene = require 'classes/scene/DialogueScene'
local Character = require 'classes/simulation/Character'
	
local gameWorld
function love.load()
	local font = love.graphics.newFont('data/fonts/courbd.ttf', 12)
	FontManager:addFont(font, 'Courier12')
	local font = love.graphics.newFont('data/fonts/courbd.ttf', 16)
	FontManager:addFont(font, 'Courier16')
	font = love.graphics.newFont('data/fonts/courbd.ttf', 32)
	FontManager:addFont(font, 'Courier32')

	gameWorld = GameWorld:new()
	
	local hero = Character:new(gameWorld)
	hero.name = 'Kevin'
	gameWorld.hero = hero
				
	SceneManager:addScene(BankScene:new(gameWorld), 'bank')
	SceneManager:addScene(HotelScene:new(gameWorld), 'hotel')
	SceneManager:addScene(StoryScene:new(gameWorld), 'story')
	SceneManager:addScene(DialogueScene:new(gameWorld), 'dialogue')

	SceneManager:show('bank')
	SceneManager:show('story', StoryFactory:createStory('begin', gameWorld))
end

function love.update()
	gameWorld:update()
	
	local vs = SceneManager.visibleScenes
	
	for i = 1, #vs do
		local vScene = vs[i]
		vScene:update()
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