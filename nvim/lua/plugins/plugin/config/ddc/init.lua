local global = require("plugins.plugin.config.ddc.global")
local notice = require("plugins.plugin.config.ddc.notice")

local M = {
  global = global,
  notice = notice,

  events = global.autocomplete_events,
}

return M
