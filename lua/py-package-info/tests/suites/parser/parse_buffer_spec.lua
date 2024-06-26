local core = require("py-package-info.core")
local parser = require("py-package-info.parser")
local state = require("py-package-info.state")
local clean_version = require("py-package-info.helpers.clean_version")

local file = require("py-package-info.tests.utils.file")
local reset = require("py-package-info.tests.utils.reset")

describe("Parser parse_buffer", function()
    before_each(function()
        reset.all()
    end)

    after_each(function()
        reset.all()
    end)

    it("should map and set all dependencies to state", function()
        local pyproject_toml = file.create_pyproject_toml({ go = true })

        core.load_plugin()
        parser.parse_buffer()

        local expected_dependency_list = {}

        for _, dependency in pairs(pyproject_toml.dependencies) do
            expected_dependency_list[dependency.name] = {
                current = clean_version(dependency.version.current),
            }
        end

        file.delete(pyproject_toml.path)

        assert.are.same(expected_dependency_list, state.dependencies.installed)
    end)
end)
