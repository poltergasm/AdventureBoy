function rgb(r, g, b, a)
	a = a ~= nil and a or 255
	return r / 255, g / 255, b / 255, a / 255
end

function println(str, x, y)
	love.graphics.setColor(Color.Black)
	love.graphics.print(str, x+2, y+2)
	love.graphics.setColor(Color.Clear)
	love.graphics.print(str, x, y)
end