-- stolen from https://github.com/Allaman/nvim/blob/37e0917f92341e921fd6bbb5f19b6cec43e2b767/lua/core/checks.lua
local fn = require("utils.functions")

local required_programs = {
    go = "Some Go related features might not work",
    node = "Mason will not be able to install some LSPs/tools",
    python3 = "Some Python related features might not work",
    cargo = "Some Rust related features might not work",
    tectonic = "Latex build command will not work",
    rg = "a highly recommended grep alternative (ripgrep is the package name)",
    fd = "a highly recommended find alternative",
}

local function checkRequirement(command, msg)
    if not fn.isExecutableAvailable(command) then
        fn.notify(
            string.format("Missing %s binary or not found in PATH - %s", command, msg),
            vim.log.levels.WARN,
            "config.checks"
        )
    end
end

for k, v in pairs(required_programs) do
    checkRequirement(k, v)
end

if not fn.isNeovimVersionsatisfied(9) then
    fn.notify(
        string.format("This config probably won't work very well with Neovim < 0.9"),
        vim.log.levels.WARN,
        "config.checks"
    )
end
