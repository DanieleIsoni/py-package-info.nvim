local state = require("py-package-info.state")
local to_boolean = require("py-package-info.utils.to-boolean")
local clean_version = require("py-package-info.helpers.clean_version")
local toml = require("py-package-info.libs.toml")

--- Checks if the given string conforms to 1.0.0 version format
-- @param value: string - value to check if conforms
-- @return boolean
local is_valid_dependency_version = function(value)
    if type(value) == "table" then
        value = value["version"]
    end

    if type(value) ~= "string" then
        return false
    end

    local cleaned_version = clean_version(value)

    if cleaned_version == nil then
        return false
    end

    local position = 0
    local is_valid = true

    -- Check that the first two chunks in version string are numbers
    -- Everything beyond could be unstable version suffix
    for chunk in string.gmatch(cleaned_version, "([^.]+)") do
        if position == 0 and type(tonumber(chunk)) ~= "number" then
            is_valid = false
        end

        position = position + 1
    end

    return is_valid
end

--- Gets the dependency name from the given buffer line
-- @param line: string - buffer line from which to get the name from
-- @return string?
return function(line)
    local parsed_line = toml.parse(line)
    if parsed_line == nil then
        return nil
    end

    local length = 0
    local parsed_line_key = nil
    local parsed_line_value = nil

    for k, v in pairs(parsed_line) do
        length = length + 1
        parsed_line_key = string.lower(k)
        parsed_line_value = v
    end

    if length ~= 1 then
        return nil
    end

    local is_installed = to_boolean(state.dependencies.installed[parsed_line_key])
    local is_valid_version = is_valid_dependency_version(parsed_line_value)

    if is_installed and is_valid_version then
        return parsed_line_key
    end

    return nil
end
