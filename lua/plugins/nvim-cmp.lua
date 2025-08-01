-- nvim-cmp: Autocompletion engine
return {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    -- Snippet engine (required by nvim-cmp)
    {
      'L3MON4D3/LuaSnip',
      build = (function()
        -- Build Step is needed for regex support in snippets
        -- Remove the below condition to re-enable on windows
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
    },
    'saadparwaiz1/cmp_luasnip',

    -- Completion sources
    'hrsh7th/cmp-nvim-lsp',     -- LSP completions
    'hrsh7th/cmp-path',         -- File path completions
    'hrsh7th/cmp-buffer',       -- Buffer text completions
  },
  config = function()
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    luasnip.config.setup {}

    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      completion = { completeopt = 'menu,menuone,noinsert' },

      -- Key mappings for completion
      mapping = cmp.mapping.preset.insert {
        -- Select next/previous item
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),

        -- Scroll documentation window
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),

        -- Accept completion
        ['<C-y>'] = cmp.mapping.confirm { select = true },

        -- Manually trigger completion
        ['<C-Space>'] = cmp.mapping.complete {},

        -- Navigate snippets
        ['<C-l>'] = cmp.mapping(function()
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          end
        end, { 'i', 's' }),
        ['<C-h>'] = cmp.mapping(function()
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          end
        end, { 'i', 's' }),
      },

      -- Completion sources (in order of priority)
      sources = {
        { name = 'nvim_lsp' },    -- LSP completions (highest priority)
        { name = 'luasnip' },     -- Snippet completions
        { name = 'path' },        -- File path completions
        { name = 'buffer' },      -- Text from current buffer (lowest priority)
      },
    }
  end,
}