local c = require("theme")

local activehl = {fg = c.neutral0, bg = c.neutral6}
local inactivehl = {fg = c.neutral6, bg = c.neutral3}

require("feline").setup(
  {
    colors = activehl,
    components = {
      left = {
        active = {
          {provider = "file_info", type = "unique"}
        },
        inactive = {
          {provider = "file_info", type = "unique", hl = inactivehl}
        }
      },
      mid = {active = {}, inactive = {}},
      right = {active = {}, inactive = {}}
    }
  }
)
