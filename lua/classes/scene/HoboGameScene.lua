local SceneManager = require 'classes/scene/SceneManager'
SceneManager = SceneManager:getInstance()
local Profiler = require 'classes/Profiler'
Profiler = Profiler:getInstance()

local Scene = require 'classes/scene/Scene'
local HoboGameScene = Scene:extend('HoboGameScene')

function HoboGameScene:init()
	HoboGameScene.super.init(self, gameWorld)
end

function HoboGameScene:draw()
end

function HoboGameScene:update(dt)
end

return HoboGameScene