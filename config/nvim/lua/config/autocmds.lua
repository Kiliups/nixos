-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
  pattern = "*",
  callback = function()
    if vim.bo.modified and vim.fn.expand("%") ~= "" then
      vim.cmd("silent write")
    end
  end,
})

vim.opt.autoread = true

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  command = "checktime",
})

vim.api.nvim_create_autocmd("BufReadCmd", {
  pattern = {
    "*.pdf",
    "*.PDF",
    "*.png",
    "*.PNG",
    "*.jpg",
    "*.JPG",
    "*.jpeg",
    "*.JPEG",
    "*.gif",
    "*.GIF",
    "*.webp",
    "*.WEBP",
    "*.bmp",
    "*.BMP",
    "*.svg",
    "*.SVG",
    "*.mp4",
    "*.MP4",
    "*.mkv",
    "*.MKV",
    "*.webm",
    "*.WEBM",
    "*.mov",
    "*.MOV",
    "*.avi",
    "*.AVI",
    "*.mp3",
    "*.MP3",
    "*.flac",
    "*.FLAC",
    "*.wav",
    "*.WAV",
    "*.ogg",
    "*.OGG",
  },
  callback = function(args)
    vim.ui.open(vim.api.nvim_buf_get_name(args.buf))
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(args.buf) then
        vim.api.nvim_buf_delete(args.buf, { force = true })
      end
    end)
  end,
})
