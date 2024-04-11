local core = require("py-package-info.core")
local state = require("py-package-info.state")
local constants = require("py-package-info.utils.constants")
local config = require("py-package-info.config")
local virtual_text = require("py-package-info.virtual_text")

local file = require("py-package-info.tests.utils.file")
local reset = require("py-package-info.tests.utils.reset")

describe("Virtual_text display_on_line", function()
    before_each(function()
        reset.all()
    end)

    after_each(function()
        reset.all()
    end)

    it("should set the virtual text in the correct position", function()
        local pyproject_toml = file.create_pyproject_toml({ go = true })
        local dependency = pyproject_toml.dependencies.mypy

        config.setup()
        core.load_plugin()

        state.dependencies.outdated = {
            [dependency.name] = {
                latest = dependency.version.latest,
                current = dependency.version.current,
            },
        }

        virtual_text.__display_on_line(dependency.position + 1, dependency.name)

        local virtual_text_positions = vim.api.nvim_buf_get_extmarks(state.buffer.id, state.namespace.id, 0, -1, {})

        file.delete(pyproject_toml.path)

        assert.are.equals(dependency.position, virtual_text_positions[1][2])
    end)

    it("should set the virtual text with no icon if icons are disabled", function()
        local pyproject_toml = file.create_pyproject_toml({ go = true })
        local dependency = pyproject_toml.dependencies.mypy

        config.setup({ icons = { enable = false } })
        core.load_plugin()

        state.dependencies.outdated = {
            [dependency.name] = {
                latest = dependency.version.latest,
                current = dependency.version.current,
            },
        }

        local dependency_metadata = virtual_text.__display_on_line(dependency.position + 1, dependency.name)

        file.delete(pyproject_toml.path)

        assert.are.equals("", dependency_metadata.icon)
    end)

    it("shouldn't set the virtual text for up to date dependencies if hide_up_to_date is true", function()
        local pyproject_toml = file.create_pyproject_toml({ go = true })
        local dependency = pyproject_toml.dependencies.gunicorn

        config.setup({ hide_up_to_date = true })
        core.load_plugin()

        state.dependencies.outdated = {
            [dependency.name] = {
                latest = dependency.version.latest,
                current = dependency.version.current,
            },
        }

        local dependency_metadata = virtual_text.__display_on_line(dependency.position + 1, dependency.name)

        file.delete(pyproject_toml.path)

        assert.are.equals("", dependency_metadata.icon)
        assert.are.equals("", dependency_metadata.version)
    end)

    it("should display the latest version if the current one is out of date", function()
        local pyproject_toml = file.create_pyproject_toml({ go = true })
        local dependency = pyproject_toml.dependencies.django

        config.setup()
        core.load_plugin()

        state.dependencies.outdated = {
            [dependency.name] = {
                latest = dependency.version.latest,
                current = dependency.version.current,
            },
        }

        local dependency_metadata = virtual_text.__display_on_line(dependency.position + 1, dependency.name)

        file.delete(pyproject_toml.path)

        assert.are.equals(config.options.icons.style.outdated, dependency_metadata.icon)
        assert.are.equals(dependency.version.latest, dependency_metadata.version)
        assert.are.equals(constants.HIGHLIGHT_GROUPS.outdated, dependency_metadata.group)
    end)

    it("should display the existing version when the latest is the same", function()
        local pyproject_toml = file.create_pyproject_toml({ go = true })
        local dependency = pyproject_toml.dependencies.gunicorn

        config.setup()
        core.load_plugin()

        state.dependencies.outdated = {
            [dependency.name] = {
                latest = dependency.version.latest,
                current = dependency.version.current,
            },
        }

        local dependency_metadata = virtual_text.__display_on_line(dependency.position + 1, dependency.name)

        file.delete(pyproject_toml.path)

        assert.are.equals(config.options.icons.style.up_to_date, dependency_metadata.icon)
        assert.are.equals(dependency.version.current, dependency_metadata.version)
        assert.are.equals(constants.HIGHLIGHT_GROUPS.up_to_date, dependency_metadata.group)
    end)
end)
