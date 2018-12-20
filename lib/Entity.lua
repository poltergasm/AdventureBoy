local Class = require "lib.Class"

local Entity = Class:extends()

function Entity:new(name, x, y, w, h)
  self.x = x or 0
  self.y = y or 0
  self.w   = w or 0
  self.h   = h or 0
  self.speed = 1
  self.image = nil
  self.remove = false
  self.is_player = false
  self.direction = "down"
  self.state  = nil
  self.idle_state = "down"
  self.frame = 1
  self.step  = 8
  self.tick  = 0
  self.name   = name or "base_entity"
  self.is_dynamic = false
  self.movement = "fixed" -- fixed, random, follow

  -- for collision filters
  self.is_collectable = false
  self.is_wall = false
  self.is_exit = false
  self.is_spring = false
end

function Entity:add(c, ...)
  local comp = require("lib.components." .. c)(self, ...)
  self[c] = comp
end

function Entity:remove(obj)
  self.remove = true
  obj.world:remove(self)
end

function Entity:generate_quads()
  if self.anim ~= nil then
    for k,v in pairs(self.anim) do
      v.quads = {}
      local i
      for i = 0, v.frames-1 do
        self.anim[k].quads[i+1] = love.graphics.newQuad(i*48, 0, 48, 48, v.image:getDimensions())
      end
    end
  end
end

function Entity:update(dt)
  --[[if self.state then
    self.state:update(dt)
  end]]
end

function Entity:draw()
  if self.anim ~= nil then
    self.anim[self.state]:draw(self.image, self.x, self.y)
  end
end

return Entity