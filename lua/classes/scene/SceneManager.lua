local class = require 'libs/30log/30log'
local SceneManager = class('SceneManager', { scenes = {}, visibleScenes = {} })
local instance = SceneManager()

function SceneManager.new() 
  error('Cannot instantiate SceneManager') 
end

function SceneManager.extend() 
  error('Cannot extend from a SceneManager')
end

function SceneManager:init()	
end

function SceneManager:getInstance()
  return instance
end

function SceneManager:addScene(scene, name)
	scene:initialize()
	self.scenes[name] = scene
end

function SceneManager:deleteScene(name) 
	local scene = self.scenes[name]
	if scene == nil then	
		error('Attempting to delete scene "' .. name .. '" which doesn\'t exist')
	end
	
	scene:destroy()
	self.scenes[name] = nil
end

function SceneManager:show(name, params)
	local scene = self.scenes[name]
	if scene == nil then	
		error('Attempting to show scene "' .. name .. '" which doesn\'t exist')
	end
	
	local vs = self.visibleScenes
	
	if not scene.isOverlay then
		for i = 1, #vs do
			local vScene = vs[i]
			vScene:hide()
			vs[i] = nil
		end		
	end
	
	scene:show(params)
	vs[#vs + 1] = scene
end

function SceneManager:hide()
	local scene = self.visibleScenes[#self.visibleScenes]
	if scene == nil then	
		error('Attempting to hide but there is no scene!')
	end
	scene:hide()
	self.visibleScenes[#self.visibleScenes] = nil
end

return SceneManager