local camera = {}
camera.x = 0
camera.y = 0
camera.layers = {}

function camera:newLayer(scale, func)
  table.insert(self.layers, { draw = func, scale = scale })
  table.sort(self.layers, function(a, b) return a.scale < b.scale end)
end

function camera:set()
  love.graphics.push()
  love.graphics.translate(-self.x, -self.y)
end

function camera:unset()
  love.graphics.pop()
end

function camera:move(dx, dy)
  self.x = self.x + (dx or 0)
  self.y = self.y + (dy or 0)
end

function camera:setPosition(x, y)
  self.x = x or self.x
  --self.y = y or self.y
  self.y = 150
end

function camera:draw()
  local bx, by = self.x, self.y

  for _, v in ipairs(self.layers) do
    self.x = bx * v.scale
    self.y = by * v.scale
    --camera:set()
    v.draw()
    --camera:unset()
  end
end

return camera