local state = require("py-package-info.state")
local logger = require("py-package-info.utils.logger")
local get_dependency_name_from_line = require("py-package-info.helpers.get_dependency_name_from_line")

--- Gets dependency name from current line
-- @return string?
return function()
    local current_line = vim.fn.getline(".")

    local dependency_name = get_dependency_name_from_line(current_line)
    if dependency_name ~= nil then
        dependency_name = string.lower(dependency_name)
    end

    if state.dependencies.installed[dependency_name] then
        return dependency_name
    else
        logger.warn("No valid dependency on current line")

        return nil
    end
end
