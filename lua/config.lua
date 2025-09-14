require('lspconfig').ruby_lsp.setup({
  -- Prefer the version-manager shim so it matches your project Ruby:
  cmd = { vim.fn.expand('~/.rbenv/shims/ruby-lsp') },
  -- Optional: init_options for add-ons / formatting limits, etc.
})
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {silent = true})
vim.keymap.set('n', 'gr', vim.lsp.buf.references, {silent = true})

require('nvim-treesitter.configs').setup{
  ensure_installed = { 'ruby', 'lua', 'vim', 'bash', 'json', 'yaml' },
  highlight = { enable = true },
  indent    = { enable = true },
}
-- Treesitter folds
vim.o.foldmethod = 'expr'
vim.o.foldexpr   = 'nvim_treesitter#foldexpr()'
