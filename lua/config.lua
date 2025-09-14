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
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["im"] = "@function.inner",   -- method inner
        ["am"] = "@function.outer",   -- method outer
        ["iM"] = "@class.inner",
        ["aM"] = "@class.outer",
        ["ir"] = "@block.inner",
        ["ar"] = "@block.outer",
      },
    },
  },
}

-- Treesitter folds
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr   = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

vim.keymap.set("n", "<leader>zm", function()
  local ts = vim.treesitter
  local node = (ts.get_node and ts.get_node({}))  -- Neovim ≥0.10
                or require('nvim-treesitter.ts_utils').get_node_at_cursor()
  while node do
    local t = node:type()
    if t == "method" or t == "singleton_method" then
      local srow = node:range()  -- start_row
      vim.api.nvim_win_set_cursor(0, { srow + 1, 0 })
      vim.cmd("normal! zc")
      return
    end
    node = node:parent()
  end
end, { desc = "Fold current method" })

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
