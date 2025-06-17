-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Detect .rhai files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.rhai",
  callback = function()
    vim.bo.filetype = "rhai"
  end,
})

-- Create user command for setting comment strings on-the-fly
vim.api.nvim_create_user_command("CommentString", function(opts)
  if opts.args == "" then
    print("Current commentstring: " .. vim.bo.commentstring)
  else
    vim.bo.commentstring = opts.args
    print("Commentstring set to: " .. opts.args)
  end
end, {
  nargs = "?",
  desc = "Set or show comment string for current buffer",
  complete = function()
    return {
      "// %s",      -- C-style
      "# %s",       -- Shell/Python-style  
      "-- %s",      -- SQL/Lua-style
      "/* %s */",   -- C block-style
      "<!-- %s -->", -- HTML-style
      "; %s",       -- Lisp-style
    }
  end,
})
