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

    local id = loading.new("|  󰇚 Fetching latest versions")

    job({
        toml = false,
        command = "poetry show -o -T",
        on_start = function()
            loading.start(id)
        end,
        on_success = function(outdated_dependencies_raw)
            local outdated_dependencies = {}
            local out_deps_words = {}
            for word in outdated_dependencies_raw:gmatch("%S+") do
                table.insert(out_deps_words, word)
            end
            local i = 1
            while i < #out_deps_words do
                local outdated_dependency = {}
                local outdated_dependency_name = out_deps_words[i]
                outdated_dependency.current = out_deps_words[i + 1]
                outdated_dependency.latest = out_deps_words[i + 2]
                if outdated_dependency_name and outdated_dependency.current and outdated_dependency.latest then
                    outdated_dependencies[outdated_dependency_name] = outdated_dependency
                end
                i = i + 3
            end
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
