return {
  version = "1.2",
  luaversion = "5.1",
  tiledversion = "1.2.0",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 120,
  height = 37,
  tilewidth = 8,
  tileheight = 8,
  nextlayerid = 5,
  nextobjectid = 3,
  properties = {},
  tilesets = {
    {
      name = "tiles",
      firstgid = 1,
      tilewidth = 8,
      tileheight = 8,
      spacing = 0,
      margin = 0,
      columns = 2,
      image = "../assets/gfx/tiles.png",
      imagewidth = 16,
      imageheight = 24,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 8,
        height = 8
      },
      properties = {},
      terrains = {},
      tilecount = 6,
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      id = 1,
      name = "Background",
      x = 0,
      y = 0,
      width = 120,
      height = 37,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "base64",
      compression = "zlib",
      data = "eJztw8EJAAAMA6H7ZP+Vu0dRcNVUVVVVVVVVVVVVVVVVVVVVVR8+sZ9WuQ=="
    },
    {
      type = "tilelayer",
      id = 2,
      name = "Floor",
      x = 0,
      y = 0,
      width = 120,
      height = 37,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {
        ["collidable"] = true
      },
      encoding = "base64",
      compression = "zlib",
      data = "eJzt19EKgCAQRNGy/v+b66FQZGPdKKvpHtiHJKxhCHIYAAAAAAAAAAAAAAAK5qdfALeiX230q41+tan3q57Po55fPZ9HPb96Ps/X8qfg/V/Ld7Xe+ad1xm129fWRVEwr+r1PqmasZte67o2FfrWp5/Mo5i+/Z8V8EYr56TdTyV/+c9Fv1jt/9P/X28tCv1mP/JFOvbNSyz70m0XzT41rZ75T67xj7R3Z4+/9Rs+YZ8+hPZ5rzd/7BQC80wL+pwEG"
    },
    {
      type = "tilelayer",
      id = 3,
      name = "Scenery",
      x = 0,
      y = 0,
      width = 120,
      height = 37,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "base64",
      compression = "zlib",
      data = "eJztw7EJAAAIA7CC///sC13FBJIAAAAAAAAAAAAAAAAAAABw1RQB4LMFBWMAHA=="
    },
    {
      type = "objectgroup",
      id = 4,
      name = "Objects",
      visible = true,
      opacity = 1.38778e-16,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 1,
          name = "start",
          type = "",
          shape = "rectangle",
          x = 16,
          y = 248,
          width = 8,
          height = 8,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 2,
          name = "enemy",
          type = "",
          shape = "rectangle",
          x = 96,
          y = 256,
          width = 8,
          height = 8,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
