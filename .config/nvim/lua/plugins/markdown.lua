return {
  "preservim/vim-markdown", -- Markdown syntax plugin
  config = function()
    vim.g.markdown_folding = 1 -- Enable folding for Markdown files
    vim.g.markdown_math = 1 -- Enable LaTeX math syntax
  end,
}
