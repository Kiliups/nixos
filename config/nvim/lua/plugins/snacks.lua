return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        matcher = {
          fuzzy = true,
          smartcase = true,
          ignorecase = true,
        },
        sources = {
          explorer = { hidden = true, ignored = true },
          files = {
            hidden = true,
            matcher = { fuzzy = true },
          },
          grep = {
            hidden = true,
            matcher = { fuzzy = true },
          },
        },
      },
    },
  },
}
