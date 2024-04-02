local config = require("py-package-info.config")
local to_boolean = require("py-package-info.utils.to-boolean")

local reset = require("py-package-info.tests.utils.reset")

describe("Config register_start", function()
    before_each(function()
        reset.all()
    end)

    after_each(function()
        reset.all()
    end)

    it("should register load command", function()
        config.__register_start()

        local autocommands = vim.api.nvim_exec("autocmd BufEnter", true)

        local is_registered =
            to_boolean(string.find(autocommands, "require('py-package-info.core').load_plugin()", 0, true))

        assert.is_true(is_registered)
    end)
end)
