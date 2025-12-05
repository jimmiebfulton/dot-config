-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.root_spec = { "lsp", { ".jj", ".git", "lua" }, "cwd" }
vim.g.lazyvim_picker = "snacks" -- Or "fzf" or "snacks"
vim.g.snacks_animate = true -- Enable animations for snacks picker
vim.opt.timeoutlen = 500
vim.wo.signcolumn = "auto:2"

if vim.g.neovide then
  vim.g.neovide_cursor_vfx_mode = "torpedo"
  vim.g.neovide_cursor_vfx_particle_lifetime = 2.0
  vim.g.neovide_cursor_vfx_opacity = 400.0
  vim.g.neovide_fullscreen = false
  vim.g.neovide_input_macos_option_key_is_meta = "only_left"
  vim.g.neovide_transparency = 0.98
  vim.g.neovide_normal_opacity = 0.98
end

-- vim.g.firenvim_config = {
--   globalSettings = { alt = "all" },
--   localSettings = {
--     [".*"] = {
--       cmdline = "firenvim",
--       content = "text",
--       priority = 0,
--       selector = "textarea",
--       takeover = "always",
--     },
--   },
-- }
--
-- if vim.g.started_by_firenvim == true then
--   vim.o.laststatus = 0
-- else
--   vim.o.laststatus = 2
-- end
