local config = require("py-package-info.config")
local install_action = require("py-package-info.actions.install")
local core = require("py-package-info.core")

local reset = require("py-package-info.tests.utils.reset")
local file = require("py-package-info.tests.utils.file")

describe("Actions install", function()
    before_each(function()
        reset.all()
    end)

    after_each(function()
        reset.all()
    end)

    it("should not throw on production dependency install", function()
        file.create_pyproject_toml({ go = true })

        config.setup()
        core.load_plugin()

        assert.has_no.errors(function()
            install_action.run()

            vim.api.nvim_input("<CR>")
            vim.api.nvim_input("dayjs")
            vim.api.nvim_input("<CR>")
        end)
    end)

    it("should not throw on development dependency install", function()
        file.create_pyproject_toml({ go = true })

        config.setup()
        core.load_plugin()

        assert.has_no.errors(function()
            install_action.run()

            vim.api.nvim_input("j")
            vim.api.nvim_input("<CR>")
            vim.api.nvim_input("prettier")
            vim.api.nvim_input("<CR>")
        end)
    end)
end)
