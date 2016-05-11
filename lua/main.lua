local GameWorld = require 'classes/simulation/GameWorld'
local gw = GameWorld:new()

local SceneManager = require 'classes/scene/SceneManager'
SceneManager = SceneManager:getInstance()

local FontManager = require 'classes/scene/FontManager'
FontManager = FontManager:getInstance()

local HotelScene = require 'classes/scene/HotelScene'
local DialogueScene = require 'classes/scene/DialogueScene'

local Character = require 'classes/simulation/Character'
local character = Character:new()
character.name = 'Bank Guy'

local Dialogue = require 'classes/simulation/Dialogue'
local dialogue = Dialogue:new()
dialogue.other = character

SceneManager:addScene(HotelScene:new(), 'hotel')
SceneManager:addScene(DialogueScene:new(), 'dialogue')

SceneManager:show('hotel')
SceneManager:show('dialogue', dialogue)

function love.update()
	gw:update()
	
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