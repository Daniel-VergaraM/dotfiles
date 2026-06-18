require("config.lazy")
require("config.fix_resize")

vim.api.nvim_create_autocmd("VimLeave", {
  callback = function()
    io.write("\027[?1049l")
  end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    require("noice").disable()
    vim.cmd("mode") -- fuerza redraw limpio
    io.write("\027[?1049l\027[?47l\027[?1047l") -- limpia alternate buffers
    io.flush()
    vim.fn.system("clear || cls")
  end,
})
