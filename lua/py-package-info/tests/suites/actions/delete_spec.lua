local config = require("py-package-info.config")
local delete_action = require("py-package-info.actions.delete")
local core = require("py-package-info.core")

local reset = require("py-package-info.tests.utils.reset")
local file = require("py-package-info.tests.utils.file")

describe("Actions delete", function()
    before_each(function()
        reset.all()
    end)

    after_each(function()
        reset.all()
    end)

    it("should not throw on confirm", function()
        local pyproject_toml = file.create_pyproject_toml({ go = true })

        config.setup()
        core.load_plugin()

        vim.cmd(tostring(pyproject_toml.dependencies.mypy.position))

        assert.has_no.errors(function()
            delete_action.run()

            vim.api.nvim_input("<CR>")
        end)
    end)

    it("should not throw on cancel", function()
        local pyproject_toml = file.create_pyproject_toml({ go = true })

        config.setup()
        core.load_plugin()

        vim.cmd(tostring(pyproject_toml.dependencies.mypy.position))

        assert.has_no.errors(function()
            delete_action.run()

            vim.api.nvim_input("<CR>j")
        end)
    end)
end)
