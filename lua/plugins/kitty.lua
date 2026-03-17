-- init.lua
return {
  "MunsMan/kitty-navigator.nvim",
  build = {
    "cp navigate_kitty.py ~/.config/kitty",
    "cp pass_keys.py ~/.config/kitty",
  },
  -- The default keymaps by lazy.nvim use <c-hjkl> to navigate between windows
  -- https://github.com/LazyVim/LazyVim/blob/6055e59613b406f9c4312c95e56f604fb839a97e/lua/lazyvim/config/keymaps.lua#L13-L17
  -- Need to redefine the key to override it
  keys = {
    {
      "<C-h>",
      function()
        require("kitty-navigator").navigateLeft()
      end,
      desc = "Move left a Split",
      mode = { "n" },
    },
    {
      "<C-j>",
      function()
        require("kitty-navigator").navigateDown()
      end,
      desc = "Move down a Split",
      mode = { "n" },
    },
    {
      "<C-k>",
      function()
        require("kitty-navigator").navigateUp()
      end,
      desc = "Move up a Split",
      mode = { "n" },
    },
    {
      "<C-l>",
      function()
        require("kitty-navigator").navigateRight()
      end,
      desc = "Move right a Split",
      mode = { "n" },
    },
  },
}
