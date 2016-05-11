local SceneManager = require 'classes/scene/SceneManager'
SceneManager = SceneManager:getInstance()

local FontManager = require 'classes/scene/FontManager'
FontManager = FontManager:getInstance()

local HotelScene = require 'classes/scene/HotelScene'
local DialogueScene = require 'classes/scene/DialogueScene'

local Dialogue = require 'classes/simulation/Dialogue'
local dialogue = Dialogue:new()
dialogue.other = { name = 'Bank Guy' }

SceneManager:addScene(HotelScene:new(), 'hotel')
SceneManager:addScene(DialogueScene:new(), 'dialogue')

SceneManager:show('hotel')
SceneManager:show('dialogue', dialogue)

function love.draw()
	local vs = SceneManager.visibleScenes
	
	for i = 1, #vs do
		local vScene = vs[i]
		vScene:draw()
		vScene:update()
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