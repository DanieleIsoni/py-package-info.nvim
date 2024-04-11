local config = require("py-package-info.config")
local show_action = require("py-package-info.actions.show")
local core = require("py-package-info.core")

local reset = require("py-package-info.tests.utils.reset")
local file = require("py-package-info.tests.utils.file")

describe("Actions show", function()
    before_each(function()
        reset.all()
    end)

    after_each(function()
        reset.all()
    end)

    it("should not throw", function()
        file.create_pyproject_toml({ go = true })

        config.setup()
        core.load_plugin()

        assert.has_no.errors(function()
            show_action.run()
        end)
    end)
end)
