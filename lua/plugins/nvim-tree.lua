return {
  'nvim-tree/nvim-tree.lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    sort = {
      sorter = 'case_sensitive',
    },
    filters = {
      dotfiles = false,
      git_ignored = false,
    },
    view = {
      adaptive_size = true,
      width = {
        min = 30,
        max = 60,
      },
    },
    renderer = {
      group_empty = true,
      icons = {
        show = {
          file = true,
          folder = true,
          folder_arrow = true,
          git = true,
        },
      },
    },
    actions = {
      open_file = {
        quit_on_open = false,
      },
    },
    on_attach = function(bufnr)
      local api = require('nvim-tree.api')
      
      local function opts(desc)
        return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      -- Default mappings
      api.config.mappings.default_on_attach(bufnr)

      -- Custom keymap: Shift+Enter to open in new tab
      vim.keymap.set('n', '<S-CR>', api.node.open.tab, opts('Open in new tab'))
    end,
  },
}
