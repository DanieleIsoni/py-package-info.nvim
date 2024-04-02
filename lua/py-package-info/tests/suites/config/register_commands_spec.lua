local constants = require("py-package-info.utils.constants")
local config = require("py-package-info.config")

local reset = require("py-package-info.tests.utils.reset")

describe("Config register_commands", function()
    before_each(function()
        reset.all()
    end)

    after_each(function()
        reset.all()
    end)

    it("should register commands", function()
        config.__register_commands()

        assert.has_no.errors(function()
            for _, command in pairs(constants.COMMANDS) do
                vim.cmd(command)
            end
        end)
    end)
end)
