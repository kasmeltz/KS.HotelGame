local SceneManager = require 'classes/scene/SceneManager'
SceneManager = SceneManager:getInstance()
local Character = require 'classes/simulation/Character'
local Dialogue = require 'classes/simulation/Dialogue'
local Scene = require 'classes/scene/Scene'
local HotelScene = Scene:extend('HotelScene')

function HotelScene:draw()

end

function HotelScene:keyreleased(key, scancode)
	local gw = self.gameWorld
	
	if key == 'a' then
		local character = Character:new(gw)
		character.name = 'Bank Guy'	
		local dialogue = Dialogue:new('gameIntro', 'start', gw, gw.hero, character)
		SceneManager:show('dialogue', dialogue)
	end
end

return HotelScene