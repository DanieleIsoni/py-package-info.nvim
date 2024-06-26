local spy = require("luassert.spy")

local core = require("py-package-info.core")
local state = require("py-package-info.state")
local parser = require("py-package-info.parser")
local to_boolean = require("py-package-info.utils.to-boolean")

local file = require("py-package-info.tests.utils.file")
local reset = require("py-package-info.tests.utils.reset")

describe("Core load_plugin", function()
    before_each(function()
        reset.all()
    end)

    after_each(function()
        reset.all()
    end)

    it("should return nil if not in pyproject.toml", function()
        local is_loaded = to_boolean(core.load_plugin())

        assert.is_false(is_loaded)
    end)

    it("should load the plugin if in pyproject.toml", function()
        local pyproject_toml = file.create_pyproject_toml({ go = true })

        spy.on(parser, "parse_buffer")
        spy.on(state.buffer, "save")

        core.load_plugin()

        file.delete(pyproject_toml.path)

        assert.spy(state.buffer.save).was_called(1)
        assert.spy(parser.parse_buffer).was_called(1)
    end)
end)
