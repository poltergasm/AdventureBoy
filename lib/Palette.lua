local function col(r, g, b)
	return r / 255, g / 255, b / 255
end

local Palette = {
	["Blue1"] = { col(39,253,245) },
	["Blue2"] = { col(111,254,248) },
	["Pink"] = { col(249,141,201) },

	["Clear"] = { 1, 1, 1, 1 },
	["Black"] = {0, 0, 0, 1}
}

return Palette