local sti = require "lib.sti"
local bump = require "lib.bump"
local Entity = require "lib.Entity"
local Transfer = require "ents.Transfer"
local Player = require "ents.Player"
local Scene = require "lib.Scene"
local Game  = Scene:extends()

local player, map

function Game:new(...)
	math.randomseed(os.time())
	Game.super.new(self, ...)
	love.physics.setMeter(48)
end

function Game:on_enter()
	self:load_map("map1")
	Moan.new({"Polter", Color.Blue2}, {"Welcome to the game"})
end

function Game:load_map(f)
	map = sti("assets/maps/" .. f .. ".lua", { "bump" })
	world = bump.newWorld(48)
	world.gravity = gravity
	map:bump_init(world)
	self.entity_mgr:set_world(world)
	
	for _,v in pairs(map.objects) do
		if v.name == "player_start" then
			--name, x, y, w, h, max_vel_x, max_vel_y, mass, speed
			player = Player("ent_player", v.x, v.y, 40, 48)
			self.entity_mgr:add(player)
		elseif v.name == "exit" then
			local transfer = Transfer("ent_exit", v.x, v.y, 48, 48)
			self.entity_mgr:add(transfer)
		end
	end
end

function Game:check_cols(ent, cols, idx, dt)
  ent.grounded = false
  for i,v in ipairs(cols) do
    local other = cols[i].other
    local this  = cols[i].normal

    if ent.name == "ent_player" and other.name == "ent_enemy" then
      ent:die()
    end

    if ent.collides ~= nil then ent:collides(this, other, dt) end
  end
end

local player_filter = function(item, other)
  if     other.is_prop   then return "cross"
  elseif other.is_wall   then return "slide"
  elseif other.is_exit   then return "touch"
  elseif other.is_spring then return "bounce"
  else return "slide" end
end

function Game:update(dt)
	Game.super.update(self, dt)
	Moan.update(dt)
	map:update(dt)

    for i = #self.entity_mgr.entities, 1, -1 do
	    local ent = self.entity_mgr.entities[i]
	    if not ent.is_prop then
	      if ent.is_dynamic then
	        ent:update_physics(dt)
	      end
	      ent.x, ent.y, cols = world:move(ent, ent.x, ent.y, player_filter)
	      self:check_cols(ent, cols, i, dt)
	    end
	end

	if input:down "right" then player:move_right()
	elseif input:down "left" then player:move_left()
	elseif input:down "up" then player:move_up()
	elseif input:down "down" then player:move_down() end
	--else player.state = "idle_" .. player.direction end

	if input:pressed "action" then player:attack() end
	if input:pressed "cmsg" then Moan.selectPressed() end
	if input:pressed "back" then
		Song.song1:play()
	end
end

function Game:draw()
	love.graphics.clear(Color.Black)
	map:draw()
	Game.super.draw(self)
	Moan.draw()
end

return Game