local Entity = require "lib.Entity"
local Player = Entity:extends()

function Player:new(...)
  Player.super.new(self, ...)

  self.is_player = true
  self.image = love.graphics.newImage("assets/gfx/player/idle_D.png")
  self.speed = 4
  self.state = "idle_down"
  self.moving = false
  self.anim  = {
    ["idle_down"] = {
      image = love.graphics.newImage("assets/gfx/player/idle_D.png"),
      frames = 1
    },

    ["idle_up"] = {
      image = love.graphics.newImage("assets/gfx/player/idle_U.png"),
      frames = 1
    },
    ["idle_left"] = {
      image = love.graphics.newImage("assets/gfx/player/idle_R.png"),
      flipped = true,
      frames = 1
    },
    ["idle_right"] = {
      image = love.graphics.newImage("assets/gfx/player/idle_R.png"),
      frames = 1
    },
    ["walk_up"] = {
      image = love.graphics.newImage("assets/gfx/player/walk_U.png"),
      frames = 4
    },
    ["walk_down"] = {
      image = love.graphics.newImage("assets/gfx/player/walk_D.png"),
      frames = 4
    },
    ["walk_right"] = {
      image = love.graphics.newImage("assets/gfx/player/walk_R.png"),
      frames = 4
    },
    ["walk_left"]  = {
      image = love.graphics.newImage("assets/gfx/player/walk_R.png"),
      flipped = true,
      frames = 4
    }
  }

  self:generate_quads()
  self.chunk = self.anim[self.state]["quads"][1]
end

function Player:move_right(dt)

  self.x = self.x + self.speed
  self.dir = 2
  self.state = "walk_right"
  self.idle_state = "right"
  self.moving = true
end

function Player:move_left(dt)
  self.x = self.x - self.speed
  self.dir = 4
  self.state = "walk_left"
  self.idle_state = "left"
  self.moving = true
end

function Player:move_up(dt)
  self.y = self.y - self.speed
  self.dir = 1
  self.state = "walk_up"
  self.idle_state = "up"
  self.moving = true
end

function Player:move_down(dt)
  self.y = self.y + self.speed
  self.dir = 3
  self.state = "walk_down"
  self.idle_state = "down"
  self.moving = true
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

  if self.anim ~= nil then
    if self.moving then
      if self.anim[self.state].frames > 1 then
        self.tick=(self.tick+1)%self.step

        if (self.tick == 0) then
          self.frame = self.frame%#self.anim[self.state]["quads"]+1
          self.chunk = self.anim[self.state]["quads"][self.frame]
        end
      else
        self.chunk = self.anim[self.state]["quads"][1]
      end
    else
      self.chunk = self.anim["idle_down"]["quads"][1]
    end
  end
end

return Player
