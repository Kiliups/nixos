local plugins = {
  { import = "lazyvim.plugins.extras.lang.nix" },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        denols = { mason = false },
        nil_ls = false,
        nixd = { mason = false },
      },
    },
  },
  { import = "lazyvim.plugins.extras.lang.json" },
  { import = "lazyvim.plugins.extras.lang.markdown" },
  { import = "lazyvim.plugins.extras.lang.typescript" },
  { import = "lazyvim.plugins.extras.lang.tailwind" },
  { import = "lazyvim.plugins.extras.linting.eslint" },
  { import = "lazyvim.plugins.extras.formatting.prettier" },
}

if vim.fn.has("mac") == 0 then
  table.insert(plugins, { import = "lazyvim.plugins.extras.ai.copilot" })
end

return plugins
