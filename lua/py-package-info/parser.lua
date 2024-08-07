local toml = require("py-package-info.libs.toml")
local state = require("py-package-info.state")
local clean_version = require("py-package-info.helpers.clean_version")

local M = {}

M.parse_buffer = function()
    local buffer_lines = vim.api.nvim_buf_get_lines(state.buffer.id, 0, -1, false)
    local buffer_toml_value, err_msg = toml.parse(table.concat(buffer_lines, "\n"))
    if err_msg then
        error(err_msg)
    end

    local tool_poetry
    if buffer_toml_value and buffer_toml_value["tool"] and buffer_toml_value["tool"]["poetry"] then
        tool_poetry = buffer_toml_value["tool"]["poetry"]
    end

    local std_dependencies
    if tool_poetry then
        std_dependencies = tool_poetry["dependencies"]
    end

    local poetry_groups
    if tool_poetry and tool_poetry["group"] then
        poetry_groups = tool_poetry["group"]
    end

    local dev_dependencies
    if poetry_groups and poetry_groups["dev"] then
        dev_dependencies = poetry_groups["dev"]["dependencies"]
    end
    local all_dependencies_toml = vim.tbl_extend(
        "error",
        {},
        -- buffer_toml_value["devDependencies"] or {},
        dev_dependencies or {},
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
            installed_dependencies[string.lower(name)] = {
                current = version,
            }
        end
    end

    state.buffer.lines = buffer_lines
    state.dependencies.installed = installed_dependencies
end

return M
