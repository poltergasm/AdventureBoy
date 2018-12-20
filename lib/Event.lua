local Entity = require "lib.Entity"
local Event  = Entity:extends()

function Event:new(...)
	Event.super.new(self, ...)

	self.is_collectable = true
	self.event = true
end

function Event:on_touch()
end

function Event:update(dt)
	Event.super.update(self, dt)
end

return Event