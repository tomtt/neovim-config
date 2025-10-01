-- Better popup behavior
vim.opt.completeopt = { "menu", "menuone", "noinsert", "noselect" }
vim.opt.shortmess:append("c")
-- vim.opt.pumheight = 12

-- Avoid indexing giant logs, node_modules, tmp
local cmp = require("cmp")
cmp.setup({
  completion = { keyword_length = 2 },
  preselect  = cmp.PreselectMode.None,
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-n>"]     = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ["<C-p>"]     = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ["<CR>"]      = cmp.mapping.confirm({ select = true }),
    ["<Esc>"]     = cmp.mapping.close(),
  }),
  -- show source labels like [LSP], [Buf], [Path]
  formatting = {
    fields = { "abbr", "menu", "kind" },
    format = function(entry, vim_item)
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        buffer   = "[Buf]",
        path     = "[Path]",
      })[entry.source.name] or ("[" .. entry.source.name .. "]")
      return vim_item
    end,
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp", priority = 1000 },
    { name = "path",     priority = 750  },
  }, {
    { name = "buffer",   priority = 250,
      option = {
        get_bufnrs = function()
          local bufs = {}
          for _, b in ipairs(vim.api.nvim_list_bufs()) do
            local name = vim.api.nvim_buf_get_name(b)
            local ok, stat = pcall(vim.loop.fs_stat, name)
            local skip = name:match("/log/") or name:match("node_modules/") or name:match("/tmp/")
            if ok and stat and stat.size < 200*1024 and not skip and vim.api.nvim_buf_is_loaded(b) then
              table.insert(bufs, b)
            end
          end
          return bufs
        end,
      }
    }
  }),

  -- rank LSP highest, then path, then a *filtered* buffer source
  sources = cmp.config.sources({
    { name = "nvim_lsp", priority = 1000 },
    { name = "path",     priority = 750  },
  }, {
    {
      name = "buffer",
      priority = 250,
      option = {
        keyword_pattern = [[\k\+]],
        -- Only small, relevant buffers (skip logs / huge files)
        get_bufnrs = function()
          local bufs = {}
          for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(bufnr)
               and vim.api.nvim_buf_get_option(bufnr, "buftype") == "" then
              local name = vim.api.nvim_buf_get_name(bufnr)
              -- skip log files & anything over ~200KB
              local ok, stat = pcall(vim.loop.fs_stat, name)
              local is_log = name:match("/log/") or name:match("%.log$")
              if ok and stat and stat.size < 200 * 1024 and not is_log then
                table.insert(bufs, bufnr)
              end
            end
          end
          return bufs
        end,
      },
    },
  }),

  -- sorting: keep LSP score high, then locality/recent
  sorting = {
    priority_weight = 2,
    comparators = {
      cmp.config.compare.score,         -- LSP score
      cmp.config.compare.locality,
      cmp.config.compare.recently_used,
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.kind,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
})

-- Wire LSP → cmp so LSP completions show up (and rank well)
local capabilities = require("cmp_nvim_lsp").default_capabilities()
require("lspconfig").ruby_lsp.setup({ capabilities = capabilities })

