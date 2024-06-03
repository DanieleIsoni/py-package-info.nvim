local core = require("py-package-info.core")
local get_dependency_name_from_line = require("py-package-info.helpers.get_dependency_name_from_line")

local file = require("py-package-info.tests.utils.file")
local reset = require("py-package-info.tests.utils.reset")

describe("Helpers get_dependency_name_from_line", function()
    before_each(function()
        reset.all()
    end)

    after_each(function()
        reset.all()
    end)

    it("should return nil if line is not in correct format", function()
        local dependency_name = get_dependency_name_from_line('"react = "1.2.2"')

        assert.is_nil(dependency_name)
    end)

    it("should return nil if version not in the correct format", function()
        local dependency_name = get_dependency_name_from_line('"react": "10s,s.0"')

        assert.is_nil(dependency_name)
    end)

    it("should return nil if dependency not on the list", function()
        local pyproject_toml = file.create_pyproject_toml({ go = true })

        core.load_plugin()

        local dependency_name = get_dependency_name_from_line('"dep_that_does_not_exist": "1.0.0"')

        file.delete(pyproject_toml.path)

        assert.is_nil(dependency_name)
    end)

    it("should return dependency name if line is valid and dependency is in pyproject.toml", function()
        local pyproject_toml = file.create_pyproject_toml({ go = true })

        core.load_plugin()

        local dependency_name = get_dependency_name_from_line(
            string.format(
                '%s = "%s"',
                pyproject_toml.dependencies.django.name,
                pyproject_toml.dependencies.django.version.current
            )
        )

        file.delete(pyproject_toml.path)

        assert.are.equals(pyproject_toml.dependencies.django.name, dependency_name)
    end)
end)
