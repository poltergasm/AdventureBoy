local Anim8  = require "lib.Anim8"
local Entity = require "lib.Entity"
local Player = Entity:extends()

function Player:new(...)
  Player.super.new(self, ...)

  self.is_player = true
  self.image = love.graphics.newImage("assets/gfx/player/spritesheet.png")
  self.speed = 4
  self.state = "idle_down"
  self.last_state = self.state
  self.moving = false
  local g = Anim8.newGrid(48, 48, self.image:getWidth(), self.image:getHeight())
  self.anim  = {
    --idle
    ["idle_down"] = Anim8.newAnimation(g('1-1', 8), 1),
    ["idle_up"] = Anim8.newAnimation(g('1-1', 10), 1),
    ["idle_left"] = Anim8.newAnimation(g('1-1', 9), 1):flipH(),
    ["idle_right"] = Anim8.newAnimation(g('1-1', 9), 1),

    -- attack
    ["attack_down"] = Anim8.newAnimation(g('1-2', 1), 0.2, function() self.state = self.last_state end),
    ["attack_up"] = Anim8.newAnimation(g('1-2', 3), 0.2, function() self.state = self.last_state end),
    ["attack_left"] = Anim8.newAnimation(g('1-2', 2), 0.2, function() self.state = self.last_state end):flipH(),
    ["attack_right"] = Anim8.newAnimation(g('1-2', 2), 0.2, function() self.state = self.last_state end),

    -- walk
    ["walk_up"] = Anim8.newAnimation(g('1-4', 19), 0.2),
    ["walk_down"] = Anim8.newAnimation(g('1-4', 17), 0.2),
    ["walk_right"] = Anim8.newAnimation(g('1-4', 18), 0.2),
    ["walk_left"]  = Anim8.newAnimation(g('1-4', 18), 0.2):flipH()
  }

  --self:generate_quads()
  --self.chunk = self.anim[self.state]["quads"][1]
end

function Player:move_right(dt)

  self.x = self.x + self.speed
  self.dir = 2
  self.state = "walk_right"
  self.direction = "right"
  self.moving = true
end

function Player:move_left(dt)
  self.x = self.x - self.speed
  self.dir = 4
  self.state = "walk_left"
  self.direction = "left"
  self.moving = true
end

function Player:move_up(dt)
  self.y = self.y - self.speed
  self.dir = 1
  self.state = "walk_up"
  self.direction = "up"
  self.moving = true
end

function Player:move_down(dt)
  self.y = self.y + self.speed
  self.dir = 3
  self.state = "walk_down"
  self.direction = "down"
  self.moving = true
end

function Player:attack()
  self.attacking = true
  self.last_state = self.state
  self.state = "attack_" .. self.direction
end

function Player:collides(normal, other, dt)
  if other.is_enemy then self:die() end
end

function Player:die()
  --Sound.Hurt:play()
  self.remove = true
  --Game:create_whoosh(self.pos.x, self.pos.y, "player")
  Attempts = Attempts + 1
  self:take_life()
end

function Player:take_life()
  Lives = Lives - 1
end

function Player:update(dt)
  Player.super.update(self, dt)
  self.anim[self.state]:update(dt)
end

return Player
