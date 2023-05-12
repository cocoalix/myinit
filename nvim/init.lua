local utils = require('lua.utils.init')
-- this init.vim is using utf-8
vim.opt.encoding = 'utf-8'
vim.scriptencoding = 'utf-8'

vim.opt.helplang = {'ja', 'en'}

-- disable `vi` compatible
vim.o.compatible = false

-- reset augroup
vim.api.nvim_create_augroup('MyAutoCmd', { clear = true })

-- debug mode
vim.g.is_enable_my_debug = false

-- get preference file path
-- `vim.g.preference_path` defined on ~/.cache/nvim/init.vim
vim.g.my_home_preference_path = vim.fn.expand("~/.config/nvim")
vim.g.my_initvim_path = vim.fn.expand(vim.g.preference_path)

utils.DebugEcho('load base')

require("lua.preferences.base").setup()

utils.DebugEcho('begin ' .. vim.g.my_initvim_path .. ' load')

local python_preference_path = vim.g.my_home_preference_path

-- python path
if not utils.FileExists(python_preference_path .. '/python.lua') then
  local py2pref = ""
  local py3pref = ""

  if vim.fn.has('win32') then
    local path = vim.cmd("!gcm python | select-Object Source")
    local py3pref = "vim.g.python3_host_prog = " .. path

  elseif vim.fn.has('mac') then
    -- TODO: PLZ TEST ME!!
    local py2pref = "vim.g.python2_host_prog = " .. "$PYENV_ROOT.'/versions/neovim2/bin/python'"
    local py3pref = "vim.g.python3_host_prog = " .. "$PYENV_ROOT.'/versions/neovim3/bin/python'"

  end

  local body = py2pref .. "\n" .. py3pref .. "\n"
  io.open(python_preference_path .. '/python.lua', "w"):write(body):close()
end


utils.DebugEcho('load rc')


vim.cmd("runtime /lua/plugins")

vim.cmd("runtime /lua/preferences/ft.lua")
vim.cmd("runtime /lua/preferences/mapping.lua")
vim.cmd("runtime /lua/preferences/color.lua")
vim.cmd("runtime /lua/preferences/command.lua")

utils.DebugEcho('end' .. vim.g.my_initvim_path .. ' load')

