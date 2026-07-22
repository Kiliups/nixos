return {
  "okuuva/auto-save.nvim",
  version = "^1.0.0",
  opts = {
    condition = function(buf)
      return vim.bo[buf].buftype == "" and vim.api.nvim_buf_get_name(buf) ~= ""
    end,
  },
}
