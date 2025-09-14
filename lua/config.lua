require('lspconfig').ruby_lsp.setup({
  -- Prefer the version-manager shim so it matches your project Ruby:
  cmd = { vim.fn.expand('~/.rbenv/shims/ruby-lsp') },
  -- Optional: init_options for add-ons / formatting limits, etc.
})
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {silent = true})
vim.keymap.set('n', 'gr', vim.lsp.buf.references, {silent = true})

-- require('nvim-treesitter.configs').setup{
--   ensure_installed = { 'ruby', 'lua', 'vim', 'bash', 'json', 'yaml' },
--   highlight = { enable = true },
--   indent    = { enable = true },
-- }
-- Treesitter folds
-- vim.o.foldmethod = 'expr'
-- vim.o.foldexpr   = 'nvim_treesitter#foldexpr()'
--
-- vim.api.nvim_create_autocmd('LspAttach', {
--   callback = function(ev)
--     local buf = ev.buf
--     local map = function(mode, lhs, rhs) vim.keymap.set(mode, lhs, rhs, {buffer = buf}) end
--     map('n','gd', vim.lsp.buf.definition)
--     map('n','gD', vim.lsp.buf.declaration)
--     map('n','gr', vim.lsp.buf.references)
--     map('n','gi', vim.lsp.buf.implementation)
--     map('n','K',  vim.lsp.buf.hover)
--     map('n','<leader>rn', vim.lsp.buf.rename)
--     -- Also make Ctrl-] use LSP tags:
--     vim.bo[buf].tagfunc = 'v:lua.vim.lsp.tagfunc'
--   end
-- })
