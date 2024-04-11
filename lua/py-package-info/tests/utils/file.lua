local uuid = require("py-package-info.utils.uuid")

local M = {}

--- Creates the file in a random directory
-- @return string - path to the created file
M.generate_file = function(suffix)
    local id = uuid()
    local path = "./temp/" .. id .. "/"

    os.execute("rm -rf " .. path)
    os.execute("mkdir " .. path)

    return "./temp/" .. id .. "/" .. (suffix or "")
end

--- Creata generic pyproject.toml file
-- @param props: table? - possible options
-- {
--     go: boolean? - if true, goes to pyproject.toml instantly after creation
--     content: string? - content to put in the file
-- }
-- @return table
-- {
--     path: string - path to the created file
-- }
M.create_pyproject_toml = function(props)
    local path = M.generate_file("pyproject.toml")
    local file = io.open(path, "w")

    if props.content then
        file:write(props.content)
    else
        file:write([[
            [tool.poetry]
            name = "a-name"
            version = "0.1.0"
            readme = "README.md"

            [tool.poetry.dependencies]
            python = "~3.12"
            Django = "~4.2.8"
            gunicorn = "^20.1.0"

            [tool.poetry.group.dev.dependencies]
            mypy = "1.8.0"
        ]])
    end

    local dependencies = {
        django = {
            name = "Django",
            version = {
                current = "~4.2.8",
                latest = "5.0.0",
            },
            position = 8,
        },
        gunicorn = {
            name = "gunicorn",
            version = {
                current = "^20.1.0",
                latest = "20.2.3",
            },
            position = 9,
        },
        mypy = {
            name = "mypy",
            version = {
                current = "1.8.0",
                latest = "1.10.0",
            },
            position = 12,
        },
    }

    file:close()

    if props.go then
        M.go(path)
    end

    return {
        path = path,
        dependencies = dependencies,
        total_count = 3,
    }
end

--- Create a file under the given path
-- @param props: table? -- contains
-- {
--      path: string path with file name to create
--      content: string? - content to put in the file
--      go: boolean? - if true, switch to the created file right away
--      randomize: boolean? - if true, file will be placed in a folder with a unique path
-- }
-- @return nil
M.create = function(props)
    local path = props.name

    if props.randomize then
        path = M.generate_file(props.name)
    end

    local file = io.open(path, "w")

    if props.content ~= nil then
        file:write(props.content)
    end

    file:close()

    if props.go then
        M.go(path)
    end

    return { path = path }
end

--- Go to a file under the given path
-- @param path: path with file name to go to
-- @return nil
M.go = function(path)
    vim.cmd("find " .. path)
end

--- Delete a file under the given path
-- @param path: path with file name to delete
-- @return nil
M.delete = function(path)
    vim.cmd("edit void")
    os.remove(path)
end

return M
