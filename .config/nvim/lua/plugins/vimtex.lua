return {
  "lervag/vimtex", -- vimtex plugin for LaTeX support
  config = function()
    vim.g.vimtex_compiler_method = "latexmk" -- Use latexmk for compilation
    vim.g.vimtex_view_method = "sumatrapdf" -- Use SumatraPDF for PDF viewing (Windows)
  end,
}
