local spy = require("luassert.spy")

local core = require("py-package-info.core")
local state = require("py-package-info.state")
local config = require("py-package-info.config")
local virtual_text = require("py-package-info.virtual_text")

local file = require("py-package-info.tests.utils.file")
local reset = require("py-package-info.tests.utils.reset")

describe("Virtual_text display", function()
    before_each(function()
        reset.all()
    end)

    after_each(function()
        reset.all()
    end)

    it("should be called for each dependency in pyproject.toml", function()
        local pyproject_toml = file.create_pyproject_toml({ go = true })

        config.setup()
        core.load_plugin()

        spy.on(virtual_text, "__display_on_line")

        virtual_text.display()

        file.delete(pyproject_toml.path)

        assert.spy(virtual_text.__display_on_line).was_called(pyproject_toml.total_count)
        assert.is_true(state.is_virtual_text_displayed)
    end)
end)
