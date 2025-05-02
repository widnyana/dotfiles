local common = require("widnyana.common")
local util = require("lspconfig.util")


local M = {}

local root_files = {
  "ape-config.yaml",
  "foundry.toml",
  "hardhat.config.js",
  "hardhat.config.ts",
  "remappings.txt",
  "truffle-config.js",
  "truffle.js",
}

M.opts = {
  flags = common.flags,
  cmd = {
    "nomicfoundation-solidity-language-server",
    "--stdio"
  },
  filetypes = {
    "solidity"
  },
  root_dir = util.root_pattern(unpack(root_files)) or util.find_git_ancestor,
  single_file_support = true,
  settings = {
    capabilities = {
      textDocument = {
        completion = {
          completionItem = {
            snippetSupport = true,
          },
        },
      },
    },
  },
}


return M
