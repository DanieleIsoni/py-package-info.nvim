local constants = require("py-package-info.utils.constants")
local config = require("py-package-info.config")

local file = require("py-package-info.tests.utils.file")
local reset = require("py-package-info.tests.utils.reset")

describe("Config register_package_manager", function()
    before_each(function()
        reset.all()
    end)

    after_each(function()
        reset.all()
    end)

    it("should detect poetry package manager", function()
        local created_file = file.create({ name = "pyproject.toml" })

        config.__register_package_manager()

        file.delete(created_file.path)

        assert.are.equals(constants.PACKAGE_MANAGERS.poetry, config.options.package_manager)
    end)
end)
