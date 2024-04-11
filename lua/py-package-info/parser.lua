local toml = require("py-package-info.libs.toml")
local state = require("py-package-info.state")
local clean_version = require("py-package-info.helpers.clean_version")

local M = {}

M.parse_buffer = function()
    local buffer_lines = vim.api.nvim_buf_get_lines(state.buffer.id, 0, -1, false)
    local buffer_toml_value = toml.parse(table.concat(buffer_lines, "\n"))

    local std_dependencies
    if buffer_toml_value and buffer_toml_value["tool"] and buffer_toml_value["tool"]["poetry"] then
        std_dependencies = buffer_toml_value["tool"]["poetry"]["dependencies"]
    end
    local all_dependencies_toml = vim.tbl_extend(
        "error",
        {},
        -- buffer_toml_value["devDependencies"] or {},
       std_dependencies or {}
    )

    local installed_dependencies = {}

    for name, value in pairs(all_dependencies_toml) do
        local version
        if type(value) == "string" then
            version = clean_version(value)
        elseif value["version"] then
            version = clean_version(value["version"])
        end
        if name ~= "python" and version then
            installed_dependencies[name] = {
                current = version,
            }
        end
    end

    state.buffer.lines = buffer_lines
    state.dependencies.installed = installed_dependencies
end

return M
