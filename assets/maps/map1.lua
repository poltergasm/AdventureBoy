return {
  version = "1.2",
  luaversion = "5.1",
  tiledversion = "1.2.0",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 16,
  height = 16,
  tilewidth = 48,
  tileheight = 48,
  nextlayerid = 5,
  nextobjectid = 4,
  properties = {},
  tilesets = {
    {
      name = "tiles",
      firstgid = 1,
      tilewidth = 48,
      tileheight = 48,
      spacing = 0,
      margin = 0,
      columns = 16,
      image = "../gfx/tiles.png",
      imagewidth = 768,
      imageheight = 1440,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 48,
        height = 48
      },
      properties = {},
      terrains = {},
      tilecount = 480,
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      id = 2,
      name = "Floor",
      x = 0,
      y = 0,
      width = 16,
      height = 16,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "base64",
      compression = "zlib",
      data = "eJxjYBgFILCSCDyc9RNj1kDrx2cWMXoGs35s5lECWIhUBwBy7T4T"
    },
    {
      type = "tilelayer",
      id = 1,
      name = "Solids",
      x = 0,
      y = 0,
      width = 16,
      height = 16,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {
        ["collidable"] = true
      },
      encoding = "base64",
      compression = "zlib",
      data = "eJxjYBj6YAYQz0TCs7CIwcSxgRVo/FVQsTNI+DRUnBT9yOA2Hv1P0Pi7gXgPlP0cSfwIkfbjArjs3wHEO6F4DRn6kQG6X5AByF/Y4gI5rvZg0UfILcT6HxkghyU5+pHtx+dnYvQjhz9yHKxGE0fGu/CYDfMPMfEFAJ5JLkE="
    },
    {
      type = "tilelayer",
      id = 3,
      name = "Scenery",
      x = 0,
      y = 0,
      width = 16,
      height = 16,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {
        ["collidable"] = true
      },
      encoding = "base64",
      compression = "zlib",
      data = "eJxjYBgFIHAGiE9SaMYNajhkFBAEd4hU9xqInwLxMyh7sIDvA+0AJAAArggH4g=="
    },
    {
      type = "objectgroup",
      id = 4,
      name = "Objects",
      visible = true,
      opacity = 0,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 1,
          name = "exit",
          type = "",
          shape = "rectangle",
          x = 288,
          y = 720,
          width = 48,
          height = 48,
          rotation = 0,
          visible = true,
          properties = {
            ["goto"] = "map2"
          }
        },
        {
          id = 2,
          name = "player_start",
          type = "",
          shape = "rectangle",
          x = 192,
          y = 240,
          width = 48,
          height = 48,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 3,
          name = "enter",
          type = "",
          shape = "rectangle",
          x = 288,
          y = 672,
          width = 48,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
