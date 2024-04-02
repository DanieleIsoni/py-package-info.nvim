local spy = require("luassert.spy")
local toggle_action = require("py-package-info").toggle

local config = require("py-package-info.config")
local core = require("py-package-info.core")
local virtual_text = require("py-package-info.virtual_text")

local reset = require("py-package-info.tests.utils.reset")
local file = require("py-package-info.tests.utils.file")

describe("Actions toggle", function()
    before_each(function()
        reset.all()
    end)

    after_each(function()
        reset.all()
    end)

    it("should not throw", function()
        file.create_package_json({ go = true })

        spy.on(virtual_text, "clear")
        spy.on(virtual_text, "display")

        config.setup()
        core.load_plugin()

        assert.has_no.errors(function()
            toggle_action()
        end)
    end)
end)
