--local luabins = require 'luabins'
--local sti = require 'libs/sti'

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
local StoryFactory = require 'classes/factories/StoryFactory'
StoryFactory = StoryFactory:getInstance()

--[[
for _, file in ipairs(love.filesystem.getDirectoryItems('classes/scene')) do
	local scene = require ('classes/scene/' .. file:gsub('.lua', ''))
end
]]


local Dialogue = require 'classes/simulation/Dialogue'
local GameWorld = require 'classes/simulation/GameWorld'
local HotelScene = require 'classes/scene/HotelScene'
local BankScene = require 'classes/scene/BankScene'
local StoryScene = require 'classes/scene/StoryScene'
local DialogueScene = require 'classes/scene/DialogueScene'
local Character = require 'classes/simulation/Character'
local LongTimeScene = require 'classes/scene/LongTimeScene'
local HoboDefenseTitleScene = require 'classes/scene/HoboDefenseTitleScene'
local SpaceSimulatorScene = require 'classes/scene/SpaceSimulatorScene'
local TowerDefenseScene = require 'classes/scene/TowerDefenseScene'
local BeatEmUpGameScene = require 'classes/scene/BeatEmUpGameScene'
local OperationGameScene = require 'classes/scene/OperationGameScene'
local TradingCardGameScene = require 'classes/scene/TradingCardGameScene'
local PlatformerGameScene = require 'classes/scene/PlatformerGameScene'
local SkillTreeScene = require 'classes/scene/SkillTreeScene'
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
	
	--local thread = love.thread.newThread('threads/world.lua')
	--thread:start()
	
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
		
				
	--SceneManager:addScene(DialogueScene:new(gameWorld), 'dialogue')		
	--SceneManager:addScene(StoryScene:new(gameWorld), 'story')	
	SceneManager:addScene(LongTimeScene:new(gameWorld), 'longtime')
	SceneManager:addScene(HoboDefenseTitleScene:new(gameWorld), 'hobodefensetitle')	
	SceneManager:addScene(TowerDefenseScene:new(gameWorld), 'towerdefense')		
	
	--SceneManager:addScene(BeatEmUpGameScene:new(gameWorld), 'beatemup')	
	--SceneManager:addScene(OperationGameScene:new(gameWorld), 'operationgame')	
	SceneManager:addScene(TradingCardGameScene:new(gameWorld), 'tradingcardgame')		
	SceneManager:addScene(PlatformerGameScene:new(gameWorld), 'platformergame')		
	SceneManager:addScene(SkillTreeScene:new(gameWorld), 'skilltree')	
	SceneManager:addScene(RPGSimulationScene:new(gameWorld), 'rpgsimulation')
	
	--SceneManager:show('operationgame')	
	--SceneManager:show('hobodefensetitle')	
	--SceneManager:show('tradingcardgame')	
	--SceneManager:show('longtime')	
	--SceneManager:show('platformergame')	
	--SceneManager:show('skilltree')	
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
	love.graphics.print('FPS: ' .. love.timer.getFPS(), 0, 0)

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

--[[
--STI DEMO
function love.load()
    -- Grab window size
    windowWidth  = love.graphics.getWidth()
    windowHeight = love.graphics.getHeight()

    -- Set world meter size (in pixels)
    love.physics.setMeter(32)

    -- Load a map exported to Lua from Tiled
    map = sti.new("assets/maps/map01.lua", { "box2d" })

    -- Prepare physics world with horizontal and vertical gravity
    world = love.physics.newWorld(0, 0)

    -- Prepare collision objects
    map:box2d_init(world)

    -- Create a Custom Layer
    map:addCustomLayer("Sprite Layer", 3)

    -- Add data to Custom Layer
    local spriteLayer = map.layers["Sprite Layer"]
    spriteLayer.sprites = {
        player = {
            image = love.graphics.newImage("assets/sprites/player.png"),
            x = 64,
            y = 64,
            r = 0,
        }
    }

    -- Update callback for Custom Layer
    function spriteLayer:update(dt)
        for _, sprite in pairs(self.sprites) do
            sprite.r = sprite.r + math.rad(90 * dt)
        end
    end

    -- Draw callback for Custom Layer
    function spriteLayer:draw()
        for _, sprite in pairs(self.sprites) do
            local x = math.floor(sprite.x)
            local y = math.floor(sprite.y)
            local r = sprite.r
            love.graphics.draw(sprite.image, x, y, r)
        end
    end
end

function love.update(dt)
    map:update(dt)
end

function love.draw()
    -- Translation would normally be based on a player's x/y
    local translateX = 0
    local translateY = 0

    -- Draw Range culls unnecessary tiles
    map:setDrawRange(-translateX, -translateY, windowWidth, windowHeight)

    -- Draw the map and all objects within
    map:draw()

    -- Draw Collision Map (useful for debugging)
    love.graphics.setColor(255, 0, 0, 255)
    map:box2d_draw()

    -- Reset color
    love.graphics.setColor(255, 255, 255, 255)
end
]]