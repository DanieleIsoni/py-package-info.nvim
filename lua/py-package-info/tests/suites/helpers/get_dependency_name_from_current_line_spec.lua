local spy = require("luassert.spy")

local core = require("py-package-info.core")
local logger = require("py-package-info.utils.logger")
local get_dependency_name_from_current_line = require("py-package-info.helpers.get_dependency_name_from_current_line")

local file = require("py-package-info.tests.utils.file")
local reset = require("py-package-info.tests.utils.reset")

describe("Helpers get_dependency_name_from_current_line", function()
    before_each(function()
        reset.all()
    end)

    after_each(function()
        reset.all()
    end)

    it("should get the name correctly", function()
        local pyproject_toml = file.create_pyproject_toml({ go = true })

        core.load_plugin()

        vim.cmd(tostring(pyproject_toml.dependencies.mypy.position))

        local dependency_name = get_dependency_name_from_current_line()

        file.delete(pyproject_toml.path)

        assert.are.equals(pyproject_toml.dependencies.mypy.name, dependency_name)
    end)

    it("should return nil if no valid dependency is on the current line", function()
        local pyproject_toml = file.create_pyproject_toml({ go = true })

        core.load_plugin()

        spy.on(logger, "warn")

        vim.cmd("999")

        local dependency_name = get_dependency_name_from_current_line()

        assert.is_nil(dependency_name)
        assert.spy(logger.warn).was_called(1)
        assert.spy(logger.warn).was_called_with("No valid dependency on current line")

        file.delete(pyproject_toml.path)
    end)
end)
