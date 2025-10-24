local lspconfig = require'lspconfig'

lspconfig.ruby_lsp.setup({
  -- Prefer the version-manager shim so it matches your project Ruby:
  cmd = { vim.fn.expand('~/.rbenv/shims/ruby-lsp') },
  -- Optional: init_options for add-ons / formatting limits, etc.
})


local on_rust_attach = function(client, bufnr)
  vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
end

lspconfig.rust_analyzer.setup({
    on_attach = on_rust_attach,
    settings = {
        ["rust-analyzer"] = {
            imports = {
                granularity = {
                    group = "module",
                },
                prefix = "self",
            },
            cargo = {
                buildScripts = {
                    enable = true,
                },
            },
            procMacro = {
                enable = true
            },
        }
    }
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

-- disable the built-ins so it won't grab <leader>s
require("treesj").setup({ use_default_keymaps = false })

require('gitsigns').setup()

-- code modification mappings
vim.keymap.set("n", "<leader>mt", require("treesj").toggle, { desc = "Split/Join toggle" })
vim.keymap.set("n", "<leader>mj", require("treesj").join,   { desc = "Join" })
vim.keymap.set("n", "<leader>mx", require("treesj").split,  { desc = "Split" })

-- ]m/[m for method navigation (Tree-sitter, robust)
local function goto_method(next_dir)
  local ts = vim.treesitter
  local bufnr = 0
  local cursor_row = vim.api.nvim_win_get_cursor(0)[1] - 1

  local parser = ts.get_parser(bufnr, "ruby")
  if not parser then return end
  local root = parser:parse()[1]:root()

  -- One capture name + two alternatives
  local query = ts.query.parse("ruby", [[
    [
      (method)
      (singleton_method)
    ] @m
  ]])

  local best -- store the best start row we found
  for id, node in query:iter_captures(root, bufnr, 0, -1) do
    if query.captures[id] == "m" and node then
      local sr = node:range() -- start_row, start_col, end_row, end_col (we only need start_row)
      if next_dir then
        if sr > cursor_row and (not best or sr < best) then best = sr end
      else
        if sr < cursor_row and (not best or sr > best) then best = sr end
      end
    end
  end

  if best then
    vim.api.nvim_win_set_cursor(0, { best + 1, 0 })
  end
end
vim.api.nvim_create_autocmd("FileType", {
  pattern = "ruby",
  callback = function()
    vim.keymap.set("n", "]m", function() goto_method(true) end,  { buffer=true, desc="Next method" })
    vim.keymap.set("n", "[m", function() goto_method(false) end, { buffer=true, desc="Prev method" })
  end,
})

-- default mappings for leap
require('leap').set_default_mappings()

require("which-key").setup({
  disable = { filetypes = { "TelescopePrompt" } },
})

-- require('telescope').load_extension('fzf')
require('telescope').load_extension('ui-select')
-- LSP code actions (Ruby LSP will include "Disable <Cop> for this line")
vim.keymap.set({ "n", "v" }, "<leader>ma", function()
  vim.lsp.buf.code_action()
end, { desc = "Code actions" })

-- neotest config
local ok_neotest, neotest = pcall(require, "neotest")
if ok_neotest then
  neotest.setup({
    adapters = {
      require("neotest-minitest"),
    },
  })
  vim.keymap.set("n", "<leader>tn", function() neotest.run.run() end, { desc = "Test: nearest" })
  vim.keymap.set("n", "<leader>tf", function() neotest.run.run(vim.fn.expand("%")) end, { desc = "Test: file" })
  vim.keymap.set("n", "<leader>ts", neotest.summary.toggle, { desc = "Test: summary" })
  vim.keymap.set("n", "<leader>to", neotest.output.open,                       {desc="Test: output"})
end

-- Distinct background for neotest windows (summary + outputs)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "neotest-summary", "neotest-output", "neotest-output-panel" },
  callback = function()
    -- Define a custom background color (tweak this hex to taste)
    vim.api.nvim_set_hl(0, "NeotestWinBg", { bg = "#12020e" })

    -- Make the whole window use that bg (Normal, non-current, signs, and tildes)
    vim.wo.winhighlight = table.concat({
      "Normal:NeotestWinBg",
      "NormalNC:NeotestWinBg",
      "SignColumn:NeotestWinBg",
      "EndOfBuffer:NeotestWinBg",
      "FloatBorder:NeotestWinBg",
      "CursorLine:NeotestWinBg",
    }, ",")
  end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.api.nvim_set_hl(0, "NeotestWinBg", { bg = "#12020e" })
  end,
})

-- Replace the glyphs to your taste (requires a Nerd Font or similar)
local define = vim.fn.sign_define
define("neotest_passed",  { text = "✓", texthl = "NeotestPassed",  numhl = "" })
define("neotest_failed",  { text = "✗", texthl = "NeotestFailed",  numhl = "" })
define("neotest_running", { text = "…", texthl = "NeotestRunning", numhl = "" })
define("neotest_skipped", { text = "-", texthl = "NeotestSkipped", numhl = "" })
define("neotest_unknown", { text = "?", texthl = "NeotestUnknown", numhl = "" })

-- yanky config (yank ring picker)
local ok_yanky, yanky = pcall(require, "yanky")
if ok_yanky then
  yanky.setup({})
  pcall(require("telescope").load_extension, "yank_history")
  vim.keymap.set("n", "<leader>fy", "<cmd>Telescope yank_history<cr>", { desc = "Yank history" })
end

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

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local buf = ev.buf
    local map = function(mode, lhs, rhs) vim.keymap.set(mode, lhs, rhs, {buffer = buf}) end
    map('n','gd', vim.lsp.buf.definition)
    map('n','gD', vim.lsp.buf.declaration)
    map('n','gr', vim.lsp.buf.references)
    map('n','gi', vim.lsp.buf.implementation)
    map('n','K',  vim.lsp.buf.hover)
    map('n','<leader>rn', vim.lsp.buf.rename)
    -- Also make Ctrl-] use LSP tags:
    vim.bo[buf].tagfunc = 'v:lua.vim.lsp.tagfunc'
  end
})

require('nvls').setup()
vim.api.nvim_create_autocmd('BufEnter', { 
  command = "syntax sync fromstart",
  pattern = { '*.ly', '*.ily', '*.tex' }
})

require("telescope").load_extension("file_browser")
vim.keymap.set("n", "<leader>fe",
  ":Telescope file_browser<CR>",
  { desc = "Browse files" })

