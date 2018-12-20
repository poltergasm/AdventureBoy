local Tiled = {}
local quads = {}
local ts

function Tiled:load(path, img)
	--assert(img ~= nil, "Tiled:load (Expecting path and image)")
	self.data = love.filesystem.load(path)()
	ts = self.data.tilesets[1]
	self.image = img

	-- generate quads
	for y = 0, (ts.imageheight / ts.tileheight) - 1 do
		for x = 0, (ts.imagewidth / ts.tileheight) - 1 do
			local q = love.graphics.newQuad(
				x * ts.tilewidth,
				y * ts.tileheight,
				ts.tilewidth,
				ts.tileheight,
				self.image:getDimensions()
			)
			table.insert(quads, q)
		end
	end

	-- grab objects and collidables
	for k,v in pairs(self.data.layers) do
		if v.type == "objectgroup" then
			self.objects = v.objects
			break
		end

		if v.type == "tilelayer" then
			if v.properties.collidable ~= nil then
				if v.properties.collidable then
					self.collidables = v.data
				end
			end
		end
	end

	return self
end

function Tiled:draw()
	for i, layer in ipairs(self.data.layers) do
		if layer.height ~= nil then
			for y = 0, layer.height - 1 do
				for x = 0, layer.width - 1 do
					local idx = (x + y * layer.width) + 1
					local tid = layer.data[idx]
					if tid ~= 0 then
						local q = quads[tid]
						local xx = x * ts.tilewidth
						local yy = y * ts.tileheight
						love.graphics.draw(self.image, q, xx, yy)
					end
				end
			end
		end
	end
end

return Tiled