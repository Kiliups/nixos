-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.opt.autoread = true

vim.api.nvim_create_autocmd("BufEnter", {
  command = "checktime",
})

if vim.env.XDG_CURRENT_DESKTOP == "niri" then
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
          local last_buffer = #vim.fn.getbufinfo({ buflisted = 1 }) == 1
          Snacks.bufdelete({ buf = args.buf, force = true })
          if last_buffer then
            Snacks.dashboard.open({ buf = 0, win = 0 })
          end
        end
      end)
    end,
  })
end
