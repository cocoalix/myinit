local utils = require("utils")

local km_opts = require("const.keymap")

local g = vim.g
local fn = vim.fn
local api = vim.api
local opt = vim.opt
local keymap = vim.keymap

local vsnip = {
  available = fn["vsnip#available"],
  jumpable = fn["vsnip#jumpable"],
}

function pumvisible()
  local r = fn["pum#visible"]() == 1
  utils.debug_echo("pumvisible: ", tostring(r))
  return r
--  return fn["pum#visible"]()
end

local function pummap(k, f, a)
  utils.debug_echo("args: ", a)
  if pumvisible() then
    if a then
      f(a)
    else
      f()
    end
--    return " "
    return ""
  end

  return k
end

local function ddc_init()
  utils.begin_debug("ddc_init")

  -- Customize global settings
  -- Use around source.
  -- https://github.com/Shougo/ddc-around
  local sources = {
    'around',
    'buffer',
    'file',
    'nvim-lsp',
    'vsnip',
--    'skkeleton',
  }

  local cmd_sources = {
    [':'] = { 'cmdline-history', 'around'},
    ['@'] = { 'cmdline-history', 'input', 'file', 'around'},
    ['>'] = { 'cmdline-history', 'input', 'file', 'around'},
    ['/'] = { 'around', 'line'},
    ['?'] = { 'around', 'line'},
    ['-'] = { 'around', 'line'},
    ['='] = { 'input'},
  }

  -- if has('win32')
  --   local sources = add(s:sources, 'windows-clipboard-history')
  -- endif

  -- Use matcher_head and sorter_rank.
  -- https://github.com/Shougo/ddc-matcher_head
  -- https://github.com/Shougo/ddc-sorter_rank
  local source_option_default = {
    mark        = '   ',
    ignoreCase  = true,
    matchers    = {'matcher_fuzzy'},
    sorters     = {'sorter_fuzzy'},
    converters  = {
      'converter_remove_overlap',
      'converter_truncate',
      'converter_fuzzy',
    },
    maxItems    = 10,
  }
  local source_option_around = {
    mark        = '   ',
    isVolatile  = true,
    matchers    = {'matcher_fuzzy'},
    sorters     = {'sorter_fuzzy'},
    converters  = {'converter_fuzzy'},
    maxItems    = 8,
  }
  local source_option_buffer = {
    mark        = '   ',
    isVolatile  = true,
    matchers    = {'matcher_fuzzy'},
    sorters     = {'sorter_fuzzy'},
    converters  = {'converter_fuzzy'},
  }
  local source_option_file = {
    mark                    = '   ',
    forceCompletionPattern  = '[\\w@:~._-]/[\\w@:~._-]*',
    minAutoCompleteLength   = 2,
    sorters                 = {'sorter_fuzzy'},
  }
  local source_option_nvimlsp = {
    mark                    = '   ',
    isVolatile              = true,
    forceCompletionPattern  = '\\.\\w*|:\\w*|->\\w*',
    matchers                = {'matcher_fuzzy'},
    sorters                 = {'sorter_fuzzy'},
    converters              = {'converter_fuzzy'}
  }
  local source_option_omni = {
    mark = '   ',
  }
--  local source_option_skkeleton = {
--    mark        = ' 🎌 ',
--    isVolatile  = true,
--    matchers    = {'skkeleton'},
--    sorters     = {},
--  }

  -- local source_option_path = {
  --   mark = '   ',
  --   forceCompletionPattern = '[\\w@:~._-]/[\\w@:~._-]*',
  --   minAutoCompleteLength = 2,
  --   sorters = ['sorter_fuzzy'],
  -- }
  local source_option_vsnip = {
    mark        = '   ',
    dup         = true,
    matchers    = {'matcher_fuzzy'},
    sorters     = {'sorter_fuzzy'},
    converters  = {'converter_fuzzy'}
  }
  local source_option_cmdlinehistory = {
    mark        = '   ',
    isVolatile  = true,
    matchers    = {'matcher_fuzzy'},
    sorters     = {'sorter_fuzzy'},
    converters  = {'converter_fuzzy'}
  }
  local source_option_shellhistory = {
    mark              = '   ',
    isVolatile        = true,
    minKeywordLength  = 2,
    maxKeywordLength  = 50,
    matchers          = {'matcher_fuzzy'},
    sorters           = {'sorter_fuzzy'},
    converters        = {'converter_fuzzy'}
  }
  local source_options = {
    ["_"]               = source_option_default,
    ["around"]          = source_option_around,
    ['buffer']          = source_option_buffer,
    ['file']            = source_option_file,
    ["nvim-lsp"]        = source_option_nvimlsp,
    ["omni"]            = source_option_omni,
    ['vsnip']           = source_option_vsnip,
    ["cmdline-history"] = source_option_cmdlinehistory,
    ["shell-history"]   = source_option_shellhistory,
  }


  -- if has('win32')
  --   local source_options["windows-clipboard-history"] = { mark"; '', }
  -- endif

  local source_params_around = {
    maxSize = 500,
  }

  local source_params_buffer = {
    requireSameFiletype = false,
    fromAltBuf          = true,
    bufNameStyle        = 'basename',
  }

  local source_params_file = {
    trailingSlash   = true,
    followSymlinks  = true,
  }

  local source_params_nvimlsp = {
    maxSize =    20,
  }

  local source_params = {
    ['around']   = source_params_around,
    ['buffer']   = source_params_buffer,
    ['file']     = source_params_file,
    ['nvim-lsp'] = source_params_nvimlsp,
  }
  -- sourceParams['path'] = {
  --   "cmd"; {'fd', '--max-depth', '5'},
  -- }

  -- if fn.has('win32') then
  --   source_params["windows-clipboard-history"] = {
  --     "maxSize"; 100,
  --     "maxAbbrWidth"; 100,
  --   }
  -- end

  local filter_params_matcher_fuzzy = {
    splitMode = 'word'
  }

  local filter_params_converter_fuzzy = {
    hlGroup = 'SpellBad'
  }

  local filter_params_truncate = {
    maxAbbrWidth = 40,
    maxInfoWidth = 40,
    maxKindWidth = 20,
    maxMenuWidth = 20,
    ellipsis = '..',
  }

  local filter_params = {
    ['matcher_fuzzy']       = filter_params_matcher_fuzzy,
    ['converter_fuzzy']     = filter_params_converter_fuzzy,
    ["converter_truncate"]  = filter_params_truncate,
  }


  -- --  Filetype
  -- fn."ddc#custom#patch_filetype"]({'toml'}, {
  --   sourceOptions = {
  --     ["nvim-lsp"] = { forceCompletionPattern = '\\.|[={[,"]\\s*' },
  --   }
  -- })

  -- fn."ddc#custom#patch_filetype"](
  -- {
  --   'python', 'typescript', 'typescriptreact', 'rust', 'markdown', 'yaml',
  --   'json', 'sh', 'lua', 'toml', 'go'
  -- }, {
  --   sources = { ['nvim-lsp'] = sources },
  -- })


  local autocomplete_events  = {
    'InsertEnter',  'TextChangedI', 'TextChangedP',
    'CmdlineEnter', 'CmdlineChanged',
  }
  --  integrate preferences.
  local patch_global = {
    sources             = sources,
    cmdlineSources      = cmd_sources,
    sourceOptions       = source_options,
    sourceParams        = source_params,
    filterParams        = filter_params,
    backspaceCompletion = true,
    autoCompleteEvents  = autocomplete_events,
    ui                  = 'pum',
  }

  fn["ddc#custom#patch_global"](patch_global)

  --  use ddc.
  fn["ddc#enable"]()

  utils.end_debug("ddc_init")
end

local function ddc_preference()
  utils.begin_debug("ddc_preference")

  --  Key mappings
  --  For insert mode completion
  utils.keymap_set({
    mode  = { "i", "c", },
    lhs   = '<C-n>',
    rhs   = function()
      if pumvisible() then
        fn["pum#map#insert_relative"](1)
      else
        return '<C-n>'
      end
    end,
    opts  = km_opts.ens
  })
  utils.keymap_set({
    mode  = { "i", "c", },
    lhs   = '<C-p>',
    rhs   = function()
      if pumvisible() then
        fn["pum#map#insert_relative"](-1)
      else
        return '<C-p>'
      end
    end,
    opts  = km_opts.en
  })
  utils.keymap_set({
    mode  = { "i", "c", },
    lhs   = '<C-e>',
    rhs   = function()
      if pumvisible() then
        fn["pum#map#cancel"]()
      else
        return '<C-e>'
      end
    end,
    opts  = km_opts.en
  })
  utils.keymap_set({
    mode  = { "i", "c", },
    lhs   = '<C-y>',
    rhs   = function()
      if pumvisible() then
        fn["pum#map#confirm"]()
      end
    end,
    opts  = km_opts.en
  })
  utils.keymap_set({
    mode  = { "i", "c", },
    lhs   = '<CR>',
    rhs   = function()
      if pumvisible() then
        fn["pum#map#confirm"]()
      else
        return "<CR>"
      end
    end,
    opts  = km_opts.ens
  })
  -- Manually open the completion menu
  utils.keymap_set({
    mode  = { "i", "c", },
    lhs   = '<C-Space>',
    rhs   = function()
      if pumvisible() then
        fn["ddc#map#manual_complete"]()
      else
        return '<C-Space>'
      end
    end,
    opts  = {
      replace_keycodes  = false,
      expr              = true,
      desc              = '[ddc.vim] Manually open popup menu'
    }
  })
  utils.keymap_set({
    mode  = { "i", "c", },
    lhs   = '<C-l>',
    rhs   = function()
      if pumvisible() then
        fn["ddc#map#extend"]()
      else
        return '<C-l>'
      end
    end,
    opts  = km_opts.ns
  })
  utils.keymap_set({
    mode  = { "i", "c", },
    lhs   = '<C-x><C-f>',
    rhs   = function()
      if pumvisible() then
        fn["ddc#map#manual_complete"]('path')
      else
        return '<C-x><C-f>'
      end
    end,
    opts  = km_opts.ns
  })

  utils.end_debug("ddc_preference")
end

local function snippet_preference()
  utils.begin_debug("snippet_preference")

  utils.keymap_set({
    mode  = { "i", "s", },
    lhs   = '<Tab>',
    rhs   = function()
      if vsnip.available(1) then
        utils.feedkey('<Plug>(vsnip-expand-or-jump)', "")
      else
        return '<Tab>'
      end
    end,
    opts  = km_opts.e
  })
  utils.keymap_set({
    mode  = { "i", "s", },
    lhs   = '<S-Tab>',
    rhs   = function()
      if vsnip.jumpable(-1) then
        utils.feedkey('<Plug>(vsnip-jump-prev)', "")
      else
        return '<S-Tab>'
      end
    end,
    opts  = km_opts.e
  })


  utils.end_debug("snippet_preference")
end


return {
  {
    'Shougo/ddc.vim',
    lazy = true,
    event = { 'InsertEnter', 'CursorHold' },
    dependencies = {
      'vim-denops/denops.vim',

      'Shougo/pum.vim',
      'Shougo/ddc-ui-pum',
      'Shougo/ddc-source-nvim-lsp',
      'Shougo/ddc-source-around',
      'Shougo/ddc-buffer',
      --  'ddc-dictionary',
      'LumaKernel/ddc-source-file',
      'tani/ddc-fuzzy',
      'Shougo/ddc-cmdline-history',
      'delphinus/ddc-shell-history',
      'Shougo/ddc-matcher_head',
      'Shougo/ddc-source-omni',
      --  'ddc-path',
      'Shougo/ddc-sorter_rank',
      'hrsh7th/vim-vsnip',
      'hrsh7th/vim-vsnip-integ',
      'rafamadriz/friendly-snippets',

      'Shougo/ddc-converter_remove_overlap',
      'matsui54/ddc-converter_truncate',

      'Milly/windows-clipboard-history.vim',

      'vim-skk/skkeleton',

      'matsui54/denops-popup-preview.vim',
      'matsui54/denops-signature_help',
    },
    config = function()
        ddc_init()
        ddc_preference()
        snippet_preference()
    end
  },
  {
    lazy = true,
    'vim-skk/skkeleton',
    dependencies = {
      'vim-denops/denops.vim',
    },
    config = function()
      --  skkeleton
      local skkeleton_dir = fn.expand('~/.cache/.skkeleton')
      if fn.isdirectory(skkeleton_dir) ~= 1 then
          fn.mkdir(skkeleton_dir, 'p')
      end

      fn["skkeleton#config"]({ completionRankFile = '~/.cache/.skkeleton/rank.json' })
    end
  },
  {
    lazy = true,
    'matsui54/denops-popup-preview.vim',
    dependencies = {
      'vim-denops/denops.vim',
      'Shougo/pum.vim',
    },
    event = { 'User DenopsReady' },
    config = function()
      g.popup_preview_config = {
        delay = 10,
        maxWidth = 100,
        winblend = 10,
      }
      --      fn."popup_preview#enable"]()
      api.nvim_call_function('popup_preview#enable', {})
    end,
    init = function()
    end
  },
  {
    lazy = true,
    'matsui54/denops-signature_help',
    dependencies = {
      'vim-denops/denops.vim',
      'Shougo/pum.vim',
    },
    event = { 'User DenopsReady' },
    config = function()
      g.signature_help_config = {
        contentsStyle = 'currentLabel',
        viewStyle = 'virtual',
      }
      --      fn."signature_help#enable"]()
      api.nvim_call_function('signature_help#enable', {})
    end,
  },
}

