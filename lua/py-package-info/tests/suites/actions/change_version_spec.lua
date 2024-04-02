local config = require("py-package-info.config")
local change_version_action = require("py-package-info.actions.change-version")
local core = require("py-package-info.core")

local reset = require("py-package-info.tests.utils.reset")
local file = require("py-package-info.tests.utils.file")

describe("Actions change_version", function()
    before_each(function()
        reset.all()
    end)

    after_each(function()
        reset.all()
    end)

    it("should not throw", function()
        local package_json = file.create_package_json({ go = true })

        config.setup()
        core.load_plugin()

        vim.cmd(tostring(package_json.dependencies.eslint.position))

        assert.has_no.errors(function()
            change_version_action.run()
        end)
    end)
end)
