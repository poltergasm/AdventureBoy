local pow = math.pow
local sqrt = math.sqrt

local Class = require "lib.Class"
local Vec2 = Class:extends()

function Vec2:new(x, y)
  self.x = x or 0
  self.y = y or 0
end

function Vec2:mag()
  return sqrt(pow(self.x, 2) + pow(self.y, 2))
end

function Vec2.static_div(v1, divisor)
  return Vec2(v1.x / divisor, v1.y / divisor)
end

function Vec2.static_mul(v1, val)
  return Vec2(v1.x * val, v1.y * val)
end

function Vec2:mul(val)
  self.x = self.x * val
  self.y = self.y * val
end

function Vec2.sub(v1, v2)
  return Vec2(v1.x - v2.x, v1.y - v2.y)
end

function Vec2.add(v1, v2)
  return Vec2(v1.x + v2.x, v1.y + v2.y)
end

function Vec2:div(val)
  self.x = self.x / val
  self.y = self.y / val
end

function Vec2:normalize()
  local mag = self:mag()
  self.x = self.x / mag
  self.y = self.y / mag
end

function Vec2:copy()
  return Vec2(self.x, self.y)
end

return Vec2
