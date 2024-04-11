local spy = require("luassert.spy")

local core = require("py-package-info.core")
local state = require("py-package-info.state")
local config = require("py-package-info.config")
local parser = require("py-package-info.parser")
local reload = require("py-package-info.helpers.reload")
local virtual_text = require("py-package-info.virtual_text")

local reset = require("py-package-info.tests.utils.reset")
local file = require("py-package-info.tests.utils.file")

describe("Helpers reload", function()
    before_each(function()
        reset.all()
    end)

    before_each(function()
        reset.all()
    end)

    it("should reload the buffer if it's pyproject.toml", function()
        local pyproject_toml = file.create_pyproject_toml({ go = true })

        spy.on(parser, "parse_buffer")

        core.load_plugin()
        reload()

        file.delete(pyproject_toml.path)

        assert.spy(parser.parse_buffer).was_called(2)
    end)

    it("should reload the buffer and re-render virtual text if it's displayed and in pyproject.toml", function()
        state.is_virtual_text_displayed = true

        local pyproject_toml = file.create_pyproject_toml({ go = true })

        spy.on(parser, "parse_buffer")
        spy.on(virtual_text, "display")
        spy.on(virtual_text, "clear")

        config.setup()
        core.load_plugin()
        reload()

        file.delete(pyproject_toml.path)

        assert.spy(virtual_text.display).was_called(1)
        assert.spy(virtual_text.clear).was_called(1)
        assert.spy(parser.parse_buffer).was_called(2)
    end)
end)
