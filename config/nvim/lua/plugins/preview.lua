return {
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    opts = {
      preview = {
        filetypes = { "markdown", "typst", "asciidoc", "html", "latex", "yaml" },
      },
    },
  },
  {
    "3rd/image.nvim",
    opts = {
      backend = "kitty",
      integrations = {
        markdown = { only_render_image_at_cursor = true },
      },
    },
  },
}
