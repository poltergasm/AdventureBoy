local Throttle = {}

function Throttle:init(fps)
	self.fps = fps and fps or 60
	self.min_dt = 1/fps
	self.next_time = love.timer.getTime()
end

function Throttle:update()
	self.next_time = self.next_time + self.min_dt
end

function Throttle:draw()
	local cur_time = love.timer.getTime()
	if self.next_time <= cur_time then
		self.next_time = cur_time
		return
	end
	love.timer.sleep(self.next_time - cur_time)
end

return Throttle