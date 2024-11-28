local markdown = require("plugins.plugin.lsp.helper.markdown")

local list = {
  markdown = markdown,
}

local M = {}

M.setup = function()
  for _, v in ipairs(list) do
    v.setup()
  end
end

return M
