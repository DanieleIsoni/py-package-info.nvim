local state = require("py-package-info.state")
local logger = require("py-package-info.utils.logger")
local virtual_text = require("py-package-info.virtual_text")

local M = {}

--- Runs the hide virtual text action
-- @return nil
M.run = function()
    if not state.is_loaded then
        logger.warn("Not in valid pyproject.toml file")

        return
    end

    virtual_text.clear()
end

return M
