local Entity = require "lib.Entity"
local Vec2   = require "lib.Vector2"
local DynamicEntity = Entity:extends()

local PHYSICS_MULT = 8

function DynamicEntity:new(name, x, y, w, h, max_vel_x, max_vel_y, mass, speed)
  DynamicEntity.super.new(self, name, x, y, w, h)

  self.max_vel = Vec2(max_vel_x or 64, max_vel_y or 100)
  self.orig_max_vel = Vec2(max_vel_x or 64, max_vel_y or 100)
  self.vel = Vec2(0, 0)
  self.dir = 1
  self.grounded = false
  self.mass = mass or 1
  self.speed = speed or 100
  self.is_dynamic = true
  self.alive = true
end

function DynamicEntity:update_physics(dt)
  if self.x < 0 then
    if self.is_enemy then
      self:hit_edge_left()
    end
    self.x = 5
  end

  -- if it goes through the floor, then remove it
  --[[if self.y > CANVAS_HEIGHT+48 then
    self.remove = true
  end]]
  
  if self.grounded then
      self.vel.x = self.vel.x - 50 * dt * PHYSICS_MULT
  else
    self.vel.x = self.vel.x - (8 * self.mass) * dt * PHYSICS_MULT
  end
  
  self.vel.y = self.vel.y + (world.gravity) * dt * PHYSICS_MULT

  if self.vel.x > self.max_vel.x then self.vel.x = self.max_vel.x end
  if self.vel.x < 0 then self.vel.x = 0 end

  self.x = self.x + self.dir*self.vel.x*dt
  self.y = self.y + (self.vel.y)*dt
end

function DynamicEntity:bounce()
  self.vel.y = self.vel.y - 800
  self.is_gripping = false
  self.gripped_ent = nil
end

function DynamicEntity:check_cols(this, other)
end

return DynamicEntity