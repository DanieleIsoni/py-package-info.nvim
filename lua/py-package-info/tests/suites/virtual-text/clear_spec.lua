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

    it("shouldn't run if virtual text is not displayed", function()
        spy.on(vim.api, "nvim_buf_clear_namespace")

        virtual_text.clear()

        assert.spy(vim.api.nvim_buf_clear_namespace).was_called(0)
    end)

    it("should clear all existing virtual text", function()
        local pyproject_toml = file.create_pyproject_toml({ go = true })

        spy.on(vim.api, "nvim_buf_clear_namespace")

        config.setup()
        core.load_plugin()
        virtual_text.display()
        virtual_text.clear()

        local virtual_text_positions = vim.api.nvim_buf_get_extmarks(state.buffer.id, state.namespace.id, 0, -1, {})

        file.delete(pyproject_toml.path)

        assert.spy(vim.api.nvim_buf_clear_namespace).was_called(1)
        assert.is_true(vim.tbl_isempty(virtual_text_positions))
    end)
end)
