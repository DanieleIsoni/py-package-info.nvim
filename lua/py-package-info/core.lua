-- TODO: if you have invalid toml, then fix it, plugin still wont run

local toml = require("py-package-info.libs.toml")
local parser = require("py-package-info.parser")
local state = require("py-package-info.state")
local to_boolean = require("py-package-info.utils.to-boolean")

local M = {}

--- Checks if the currently opened file
---    - Is a file named pyproject.toml
---    - Has content
---    - TOML is in valid format
-- @return boolean
M.__is_valid_pyproject_toml = function()
    local buffer_name = vim.api.nvim_buf_get_name(0)
    local is_pyproject_toml = to_boolean(string.match(buffer_name, "pyproject.toml$"))

    if not is_pyproject_toml then
        return false
    end

    local has_content = to_boolean(vim.api.nvim_buf_get_lines(0, 0, -1, false))

    if not has_content then
        return false
    end

    local buffer_content = vim.api.nvim_buf_get_lines(0, 0, -1, false)

    if pcall(function()
        toml.parse(table.concat(buffer_content))
    end) then
        return true
    end

    return false
end

--- Parser current buffer if valid
-- @return nil
M.load_plugin = function()
    if not M.__is_valid_pyproject_toml() then
        state.is_loaded = false

        return nil
    end

    state.buffer.save()
    state.is_loaded = true

    parser.parse_buffer()
end

return M
