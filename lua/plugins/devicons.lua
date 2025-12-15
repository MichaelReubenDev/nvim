return {
  'nvim-tree/nvim-web-devicons',
  lazy = true,
  opts = {},
  config = function(_, opts)
    local devicons = require 'nvim-web-devicons'
    devicons.setup(opts)

    local function normalize(name, ext)
      if type(name) == 'string' and name:match '^%.env%.' then
        return '.env', 'env'
      end
      return name, ext
    end

    local function wrap(method)
      local original = devicons[method]
      if type(original) ~= 'function' then
        return
      end

      devicons[method] = function(name, ext, opts_)
        local normalized_name, normalized_ext = normalize(name, ext)
        return original(normalized_name, normalized_ext, opts_)
      end
    end

    wrap 'get_icon'
    wrap 'get_icon_color'
    wrap 'get_icon_colors'
    wrap 'get_icon_cterm_color'
  end,
}
