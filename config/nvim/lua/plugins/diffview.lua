return {
  {
    "dlyongemallo/diffview.nvim",
    version = "*",
    keys = {
      {
        "<leader>gv",
        function()
          local view = require("diffview.lib").get_current_view()

          if view then
            vim.cmd("DiffviewClose")
          else
            vim.cmd("DiffviewOpen")
          end
        end,
        desc = "Toggle Diffview",
      },
    },
  },
}
