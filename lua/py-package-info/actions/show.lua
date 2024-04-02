local state = require("py-package-info.state")
local parser = require("py-package-info.parser")
local job = require("py-package-info.utils.job")
local virtual_text = require("py-package-info.virtual_text")
local reload = require("py-package-info.helpers.reload")

local loading = require("py-package-info.ui.generic.loading-status")

local M = {}

--- Runs the show outdated dependencies action
-- @return nil
M.run = function(options)
    if not state.is_loaded then
        return
    end

    reload()

    options = options or { force = false }

    if state.last_run.should_skip() and not options.force then
        virtual_text.display()
        reload()

        return
    end

    local id = loading.new("| 󰇚 Fetching latest versions")

    job({
        json = true,
        command = "npm outdated --json",
        ignore_error = true,
        on_start = function()
            loading.start(id)
        end,
        on_success = function(outdated_dependencies)
            state.dependencies.outdated = outdated_dependencies

            parser.parse_buffer()
            virtual_text.display()
            reload()

            loading.stop(id)

            state.last_run.update()
        end,
        on_error = function()
            loading.stop(id)
        end,
    })
end

return M
