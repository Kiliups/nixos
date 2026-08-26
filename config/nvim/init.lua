-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Neovim bug: inlay-hint decoration provider caches a column that can go out of
-- range after an edit shortens a line, crashing nvim_buf_set_extmark("inline").
-- Guard the shared call and skip out-of-range hints. Remove once fixed upstream.
local orig_set_extmark = vim.api.nvim_buf_set_extmark
vim.api.nvim_buf_set_extmark = function(bufnr, ns, line, col, opts)
  if opts and opts.virt_text_pos == "inline" and vim.api.nvim_get_namespaces()["nvim.lsp.inlayhint"] == ns then
    local line_len = #(vim.api.nvim_buf_get_lines(bufnr, line, line + 1, false)[1] or "")
    if col > line_len then
      return
    end
  end
  return orig_set_extmark(bufnr, ns, line, col, opts)
end
