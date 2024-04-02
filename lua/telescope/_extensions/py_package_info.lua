local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
    error("This extension requires 'telescope.nvim'. (https://github.com/nvim-telescope/telescope.nvim)")
end

local telescope_py_package_info_config = require("telescope._extensions.py_package_info.config")
local telescope_py_package_info_picker = require("telescope._extensions.py_package_info.picker")

return telescope.register_extension({
    setup = telescope_py_package_info_config.setup,
    exports = {
        py_package_info = telescope_py_package_info_picker.picker,
    },
})
