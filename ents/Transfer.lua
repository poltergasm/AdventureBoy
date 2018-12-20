local Event = require "lib.Event"
local Transfer  = Event:extends()

function Transfer:new(...)
	Transfer.super.new(self, ...)
	self.exit = true
end

function Transfer:on_touch()
	Moan.new({"Transfer", Color.Pink}, {"Transfer triggered"})
end

function Transfer:update(dt)
	Transfer.super.update(self, dt)
end

return Transfer