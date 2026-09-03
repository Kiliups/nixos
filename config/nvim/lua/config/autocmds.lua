-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.opt.autoread = true

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained" }, {
  command = "checktime",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function(args)
    vim.diagnostic.enable(false, { bufnr = args.buf })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "image",
  callback = function(args)
    local file = vim.api.nvim_buf_get_name(args.buf)
    if not file:lower():match("%.pdf$") then
      return
    end

    local pages = vim.fn.executable("pdfinfo") == 1
        and tonumber(vim.fn.system({ "pdfinfo", file }):match("Pages:%s+(%d+)"))
      or nil
    vim.b[args.buf].pdf_page = 1

    local change_page = function(delta)
      local page = vim.b[args.buf].pdf_page + delta
      if page < 1 or (pages and page > pages) then
        return
      end

      vim.b[args.buf].pdf_page = page
      Snacks.image.placement.clean(args.buf)
      Snacks.image.placement.new(args.buf, file .. "#page=" .. page, {
        auto_resize = true,
      })
      vim.notify(("PDF page %d/%s"):format(page, pages or "?"), vim.log.levels.INFO)
    end

    vim.keymap.set("n", "n", function()
      change_page(1)
    end, { buffer = args.buf, desc = "Next PDF page" })
    vim.keymap.set("n", "p", function()
      change_page(-1)
    end, { buffer = args.buf, desc = "Previous PDF page" })
  end,
})
