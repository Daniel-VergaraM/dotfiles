-- fix_resize.lua
-- Fixes redraw race between Windows Terminal + Git Bash + LazyVim dashboard
if vim.fn.has("win32") == 1 then
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      -- Delay redraw slightly to avoid triggering unwanted terminal resizes
      vim.defer_fn(function()
        vim.cmd("redraw!")
      end, 150)
    end,
  })
end
