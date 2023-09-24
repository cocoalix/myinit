local g = vim.g
local fn = vim.fn
local uv = vim.uv
local api = vim.api
local opt = vim.opt
local keymap = vim.keymap

local myWinPick = require("plugins.plugin.individual.winpick")
local utils = require("utils")

local M = {}

function M.setup()
end

function M.configure()
  g.denopsPath = fn["stdpath"]("data") .. "/lazy/denops.vim/denops/@denops-private"
  g.denops_server_addr = '127.0.0.1:33576'
end

function M.build4Windows()
  local denopsCliPath = g.denopsPath .. "/cli.ts"
  local serviceScriptPath = g.my_home_preference_path .. "/boot_denops.bat"
  utils.io.debug_echo("denops PATH: " .. denopsCliPath)

  -- Windows起動時にdenopsを上げてくれるやつを ~/.config/nvim/boot_denops.lua に記述
  if not utils.fs.exists(serviceScriptPath) then
    local body = "deno run -A --no-lock " .. denopsCliPath .. " --hostname=0.0.0.0 --port 33576"
    io.open(serviceScriptPath, "w"):write(body):close()
  end

  local startupBat = [[~/AppData/Roaming/Microsoft/Windows/Start\ Menu/Programs/Startup/boot_denops.vbs]]
  io.open(startupBat, "w"):write([[Set ws = CreateObject(“Wscript.Shell”)\nws.run "cmd /c ]] .. serviceScriptPath .. [[, vbhide]]):close()
end

function M.build()
  if fn["has"]("win32") then
    M.build4Windows()
  end
end

return M