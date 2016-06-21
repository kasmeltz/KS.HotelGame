local FontManager = require 'classes/scene/FontManager'
FontManager = FontManager:getInstance()

local Drawable = require 'classes/drawable/Drawable'
local TradingCardDrawable = Drawable:extend('TradingCardDrawable')

function TradingCardDrawable:init(card) 
	TradingCardDrawable.super.init(self)
	
	self.card = card
end

function TradingCardDrawable:draw(x, y, w, h) 
	love.graphics.setColor(0,0,255)
	love.graphics.setLineWidth(4)
	love.graphics.rectangle('line', x, y, w, h)

	local font = FontManager:getFont('Courier16')
	love.graphics.setFont(font)
	love.graphics.setColor(255,255,0)
	love.graphics.print(self.card.attack, x + 5, y + 5)
	love.graphics.setColor(255,0,0)
	love.graphics.printf(self.card.defense, x + w - 45, y + 5, 40, 'right')
	love.graphics.setColor(0,255,0)
	love.graphics.print(self.card.cost, x + 5, y + h - 21)	
end

return TradingCardDrawable