<div align="center">

## All the `poetry` commands I don't want to type

> Highly inspired by [package-info.nvim](https://github.com/vuki656/package-info.nvim)

</div>

<div align="center">

![Lua](https://img.shields.io/badge/Made%20with%20Lua-blueviolet.svg?style=for-the-badge&logo=lua&logoColor=white)

</div>

<div align="center">

![License](https://img.shields.io/badge/License-GPL%20v3-brightgreen?style=flat-square)
![Status](https://img.shields.io/badge/Status-Beta-informational?style=flat-square)
![Neovim](https://img.shields.io/badge/Neovim-0.5+-green.svg?style=flat-square&logo=Neovim&logoColor=white)

</div>

## ✨ Features

- Display latest dependency versions as virtual text
- Upgrade dependency on current line to latest version
- Delete dependency on current line
- Install a different version of a dependency on current line
- Install new dependency
- Loading animation hook (to be placed in status bar or anywhere else)

<div align="center">

### Display Latest Package Version

Runs `poetry show --top-level --outdated` in the background and then compares the output with versions in `pyproject.toml` and displays them as virtual text.

</div>

#### Keybinding

```lua
vim.api.nvim_set_keymap(
    "n",
    "<leader>ps",
    "<cmd>lua require('py-package-info').show()<cr>",
    { silent = true, noremap = true }
)
```

- **NOTE:** after the first outdated dependency fetch, it will show the cached results for the next hour instead of re-fetching every time.
- If you would like to force re-fetching every time you can provide `force = true` like in the example below:

```lua
vim.api.nvim_set_keymap(
    "n",
    "<leader>ps",
    "<cmd>lua require('py-package-info').show({ force = true })<cr>",
    { silent = true, noremap = true }
)
```

<div align="center">

### Delete Dependency

Runs `poetry remove` in the background and reloads the buffer.

</div>

#### Keybinding

```lua
vim.api.nvim_set_keymap(
    "n",
    "<leader>pd",
    "<cmd>lua require('py-package-info').delete()<cr>",
    { silent = true, noremap = true }
)
```

<div align="center">

### Install New Dependency

Runs `poetry add dependency` in the background and reloads the buffer.

</div>

#### Keybinding

```lua
vim.api.nvim_set_keymap(
    "n",
    "<leader>pi",
    "<cmd>lua require('py-package-info').install()<cr>",
    { silent = true, noremap = true }
)
```

<div align="center">

### Loading Hook

Function that can be placed anywhere to display the loading status from the plugin.

</div>

#### Usage

- It can be used anywhere in `neovim` by invoking `return require('py-package-info').get_status()`

```lua
local py_package_info = require("py-package-info")

-- Galaxyline
section.left[10] = {
    PyPackageInfoStatus = {
        provider = function()
            return py_package_info.get_status()
        end,
    },
}

-- Feline
components.right.active[5] = {
    provider = function()
        return py_package_info.get_status()
    end,
    hl = {
        style = "bold",
    },
    left_sep = "  ",
    right_sep = " ",
}

-- LuaLine
sections.lualine_x[3] = {}
    function()
        return py_package_info.get_status()
    end,
}
```

## ⚡️ Requirements

- Neovim >= 0.6.0
- Poetry
- [Patched font](https://github.com/ryanoasis/nerd-fonts/tree/gh-pages) if you want icons

## 📦 Installation

### [packer](https://github.com/wbthomason/packer.nvim)

```lua
use({
    "DanieleIsoni/py-package-info.nvim",
    requires = "MunifTanjim/nui.nvim",
})
```

### [lazy](https://github.com/folke/lazy.nvim)

```lua
{
    "DanieleIsoni/py-package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
        require('py-package-info').setup()
    end
}
```

## ⚙️ Configuration

### Usage

```lua
require('py-package-info').setup()
```

### Defaults

```lua
{
    colors = {
        up_to_date = "#3C4048", -- Text color for up to date dependency virtual text
        outdated = "#d19a66", -- Text color for outdated dependency virtual text
    },
    icons = {
        enable = true, -- Whether to display icons
        style = {
            up_to_date = "|  ", -- Icon for up to date dependencies
            outdated = "|  ", -- Icon for outdated dependencies
        },
    },
    autostart = true, -- Whether to autostart when `pyproject.toml` is opened
    hide_up_to_date = false, -- It hides up to date versions when displaying virtual text
    hide_unstable_versions = false, -- It hides unstable versions from version list e.g next-11.1.3-canary3
}
```

#### 256 Color Terminals

- If the vim option `termguicolors` is false, package-info switches to 256 color mode.
- In this mode [cterm color numbers](https://jonasjacek.github.io/colors/) are used
  instead of truecolor hex codes and the color defaults are:

```lua
colors = {
    up_to_date = "237", -- cterm Grey237
    outdated = "173", -- cterm LightSalmon3
}
```

## ⌨️ All Keybindings

**Plugin has no default Keybindings**.

You can copy the ones below:

```lua
-- Show dependency versions
vim.keymap.set({ "n" }, "<LEADER>ps", require("py-package-info").show, { silent = true, noremap = true })

-- Hide dependency versions
vim.keymap.set({ "n" }, "<LEADER>pc", require("py-package-info").hide, { silent = true, noremap = true })

-- Toggle dependency versions
vim.keymap.set({ "n" }, "<LEADER>pt", require("py-package-info").toggle, { silent = true, noremap = true })

-- Update dependency on the line
vim.keymap.set({ "n" }, "<LEADER>pu", require("py-package-info").update, { silent = true, noremap = true })

-- Delete dependency on the line
vim.keymap.set({ "n" }, "<LEADER>pd", require("py-package-info").delete, { silent = true, noremap = true })

-- Install a new dependency
vim.keymap.set({ "n" }, "<LEADER>pi", require("py-package-info").install, { silent = true, noremap = true })
```

## 🔭 Telescope

> Highly inspired by [telescope-lazy.nvim](https://github.com/tsakirist/telescope-lazy.nvim)

### Configuration

```lua
require("telescope").setup({
    extensions = {
        py_package_info = {
            -- Optional theme (the extension doesn't set a default theme)
            theme = "ivy",
        },
    },
})

require("telescope").load_extension("py_package_info")
```

### Available Commands

```
:Telescope py_package_info
```

## 📝 Notes

- Display might be slow on a project with a lot of dependencies. This is due to the
  `poetry show --top-level --outdated` command taking a long time. Nothing can be done about that
- Idea was inspired by [akinsho](https://github.com/vuki656) and his [package-info.nvim](https://github.com/vuki656/package-info.nvim)
- Readme template stolen from [folke](https://github.com/folke)
