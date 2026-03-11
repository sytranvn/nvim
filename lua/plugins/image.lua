return {
  "3rd/image.nvim",
  opts = {
    backend = "kitty", -- Kitty will provide the best experience, but you need a compatible terminal
    integrations = {
      markdown = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = false,
        only_render_image_at_cursor = true,
        filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
      },
    }, -- do whatever you want with image.nvim's integrations
    max_width = 100, -- tweak to preference
    max_height = 12, -- ^
    max_height_window_percentage = math.huge, -- this is necessary for a good experience
    max_width_window_percentage = math.huge,
    window_overlap_clear_enabled = true,
    window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
  },
}
