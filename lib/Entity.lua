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
  if self.image then
    if self.state then
      local ox, oy, sx, sy, kx, ky = 0, 0, 1, 1, 0, 0
      if self.anim[self.state].flipped then
        local _,_,w,h = self.chunk:getViewport()
        sx = sx * -1
        ox = w - ox
        kx = kx * -1
        ky = ky * -1
      end
      love.graphics.draw(self.anim[self.state].image, self.chunk, self.x, self.y, 0, sx, sy, ox, oy, kx, ky)
    else
      love.graphics.draw(self.image, self.x, self.y)
    end
  end
end

return Entity