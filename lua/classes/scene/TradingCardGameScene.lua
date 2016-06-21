local Scene = require 'classes/scene/Scene'
local TradingCardGameScene = Scene:extend('TradingCardGameScene')

local SceneManager = require 'classes/scene/SceneManager'
SceneManager = SceneManager:getInstance()
local Profiler = require 'classes/Profiler'
Profiler = Profiler:getInstance()

local TCCard = require 'classes/tradingcard/tccard'
local TradingCardDrawable = require 'classes/drawable/tradingcard/TradingCardDrawable'

function TradingCardGameScene:init()
	TradingCardGameScene.super.init(self, gameWorld)	
	local decks =  {}
	
	for p = 1, 2 do
		local deck = {}
		for i = 1, 10 do
			local atk = love.math.random(1,10)
			local def = love.math.random(1,10)
			local cost = love.math.random(1,10)
			local card = TCCard:new(self.gameWorld, atk, def, cost)
			local cardDrawable = TradingCardDrawable:new(card)			
			deck[#deck + 1] = cardDrawable
		end
		decks[#decks+ 1] = deck
	end
	
	self.decks = decks	
end

function TradingCardGameScene:draw()	
	local decks = self.decks
	local deck = decks[1]
	
	local sx = 50
	local sy = 550
	for i = 1, 5 do
		local cardDrawable = deck[i]
		cardDrawable:draw(sx, sy, 175, 250)
		sx = sx + 225
		
	end
end
					
function TradingCardGameScene:update(dt)
end

return TradingCardGameScene