local SceneManager = require 'classes/scene/SceneManager'
SceneManager = SceneManager:getInstance()
local Character = require 'classes/simulation/Character'
local Dialogue = require 'classes/simulation/Dialogue'
local Scene = require 'classes/scene/Scene'
local HotelScene = Scene:extend('HotelScene')

function HotelScene:draw()

end

function HotelScene:keyreleased(key, scancode)
end

return HotelScene