local g   = vim.g
local api = vim.api
local keymap = vim.keymap

return {
  {
    'voldikss/vim-floaterm',
    lazy = true,
    cmd = 'Floaterm',
    keys = {
      { "^", "<cmd>FloatermToggle<CR>", mode = "n" },
    },
    config = function()
      g.floaterm_autoclose  = 1
      g.floaterm_height     = 0.3
      g.floaterm_width      = 0.8
      g.floaterm_position   = "bottom"
      g.floaterm_title      = 'floaterm $1/$2'

      local augroup_id = api.nvim_create_augroup('floaterm', {})
      api.nvim_create_autocmd('FileType', {
        group = augroup_id,
        pattern = 'floaterm',
        callback = function ()
          keymap.set('n', 'q', '<Cmd>FloatermToggle<CR>', { noremap = true, silent = true, buffer = true })
        end
      })

      api.nvim_create_user_command("Floaterm",  '<Cmd>FloatermToggle<CR>', {})
    end

  }
}

