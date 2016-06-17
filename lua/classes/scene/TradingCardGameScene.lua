local Scene = require 'classes/scene/Scene'
local TradingCardGameScene = Scene:extend('TradingCardGameScene')

local SceneManager = require 'classes/scene/SceneManager'
SceneManager = SceneManager:getInstance()
local Profiler = require 'classes/Profiler'
Profiler = Profiler:getInstance()

local TCCard = require 'classes/tradingcard/tccard'

function TradingCardGameScene:init()
	TradingCardGameScene.super.init(self, gameWorld)
end

function TradingCardGameScene:draw()	
end
					
function TradingCardGameScene:update(dt)
end

return TradingCardGameScene