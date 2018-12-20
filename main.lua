local Throttle = require "lib.Throttle"
local Baton    = require "lib.Baton"
local Moan = require "lib.Moan"

require "lib.Utils"

input = Baton.new {
	["controls"] = {
		["right"] = {'key:right'},
		["left"]  = {'key:left'},
		["up"]    = {'key:up'},
		["down"]  = {'key:down'},
		["action"] = {'key:z'},
		["back"]   = {'key:x'},
		["cmsg"] = {'key:space'}
	}
}

world = nil
CANVAS_WIDTH, CANVAS_HEIGHT = 768, 768
Attempts = 0
Lives = 0
Color = require "lib.Palette"
SceneManager = require "lib.SceneManager"
Canvas 	= love.graphics.newCanvas(CANVAS_WIDTH, CANVAS_HEIGHT)
Font = {
	["Main"] = love.graphics.newFont("assets/fonts/manaspc.ttf", 20)
}
Song = {
	["song1"] = love.audio.newSource("assets/audio/bgm/adventure.wav", "stream")
}

Sound = {}

function load_sounds()
	local sfx_path = "assets/audio/sfx"
	local name
	for _,file in pairs(love.filesystem.getDirectoryItems(sfx_path)) do
		name = file:match("(.+)%..+")
		Sound[name] = love.audio.newSource(sfx_path .. "/" .. file, "static")
	end
end

function love.load()
	Throttle:init(60)
	Canvas:setFilter("nearest", "nearest")
	love.window.setTitle("Adventure Boy")
	love.window.setMode(768, 768)
	love.graphics.setFont(Font.Main)
	load_sounds()
	Moan.font = Font.Main
	Moan.typeSound = Sound.TypeSound
	Moan.optionOnSelectSound = Sound.OptionSelect
	Moan.optionSwitchSound = Sound.OptionSwitch
	Moan.autoWrap = true
	
	SceneManager:add({
		["SGame"]  = require "scenes.Game"()
	})
	SceneManager:switch("SGame")
end

function love.update(dt)
	Throttle:update()
	input:update()
	SceneManager:update(dt)
end

function love.draw()
	love.graphics.setCanvas(Canvas)
	SceneManager:draw()
	love.graphics.setCanvas()
	love.graphics.draw(Canvas)
	--[[local screenW,screenH = love.graphics.getDimensions()
	local canvasW,canvasH = Canvas:getDimensions()
	scaleX = love.graphics.getWidth() / canvasW
	scaleY = love.graphics.getHeight() / canvasH
	love.graphics.draw(Canvas, 0, 0, 0, scaleX, scaleY)]]
	Throttle:draw()
end