return {
  {
    "3rd/image.nvim",
    dependencies = { "luarocks.nvim" },
    config = function()
      require("image").setup({
        backend = "kitty",
        max_height_window_percentage = 50,
        hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.svg" },
      })
    end,
  },
  {
    "3rd/diagram.nvim",
    dependencies = {
      "3rd/image.nvim",
    },
    opts = { -- you can just pass {}, defaults below
      renderer_options = {
        mermaid = {
          background = nil, -- nil | "transparent" | "white" | "#hex"
          theme = "forest", -- nil | "default" | "dark" | "forest" | "neutral"
          scale = 1, -- nil | 1 (default) | 2  | 3 | ...
        },
        plantuml = {
          charset = nil,
        },
        d2 = {
          theme_id = nil,
          dark_theme_id = nil,
          scale = nil,
          layout = nil,
          sketch = nil,
        },
      },
    },
  },
}
