local core = require("py-package-info.core")

local file = require("py-package-info.tests.utils.file")
local reset = require("py-package-info.tests.utils.reset")

describe("Core is_valid_pyproject_toml", function()
    before_each(function()
        reset.all()
    end)

    after_each(function()
        reset.all()
    end)

    it("should return true for valid pyproject.toml", function()
        local pyproject_toml = file.create_pyproject_toml({ go = true })

        local is_valid = core.__is_valid_pyproject_toml()

        file.delete(pyproject_toml.path)

        assert.is_true(is_valid)
    end)

    it("should return false if buffer empty", function()
        local is_valid = core.__is_valid_pyproject_toml()

        assert.is_false(is_valid)
    end)

    it("should return false if file not called pyproject.toml", function()
        local path = "some_random_file_that_is_dead.txt"

        file.create({
            name = path,
            go = true,
        })

        local is_valid = core.__is_valid_pyproject_toml()

        file.delete(path)

        assert.is_false(is_valid)
    end)

    it("should return false if toml is invalid format", function()
        local pyproject_toml = file.create_pyproject_toml({
            content = [[
                [tool.poetry]
                gino = ["string", 1]
            ]],
            go = true,
        })

        local is_valid = core.__is_valid_pyproject_toml()

        file.delete(pyproject_toml.path)

        assert.is_false(is_valid)
    end)
end)
