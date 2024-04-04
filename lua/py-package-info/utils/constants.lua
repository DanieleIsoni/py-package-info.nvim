local M = {}

M.HIGHLIGHT_GROUPS = {
    outdated = "PyPackageInfoOutdatedVersion",
    up_to_date = "PyPackageInfoUpToDateVersion",
}

M.PACKAGE_MANAGERS = {
    poetry = "poetry",
}

M.DEPENDENCY_TYPE = {
    production = "prod",
    development = "dev",
}

M.LEGACY_COLORS = {
    up_to_date = "237",
    outdated = "173",
}

M.COMMANDS = {
    show = "PyPackageInfoShow",
    show_force = "PyPackageInfoShowForce",
    hide = "PyPackageInfoHide",
    delete = "PyPackageInfoDelete",
    update = "PyPackageInfoUpdate",
    install = "PyPackageInfoInstall",
}

M.AUTOGROUP = "PyPackageInfoAutogroup"

return M
