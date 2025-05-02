local M = {}

-- Packages that should be installed by Mason
M.mason_ensure_installed = {
  -- lsp
  "ansible-language-server",
  "dockerfile-language-server",
  "docker-compose-language-service",
  "golangci-lint-langserver",
  "lua-language-server",
  "marksman",
  "rust-analyzer",
  "sqls",
  "texlab",
  "templ",
  "typescript-language-server",
  "yaml-language-server",

  -- linter
  "ansible-lint",
  "basedpyright",
  "golangci-lint",
  "luacheck",
  "selene",
  "shellcheck",
  "vale",
  "yamllint",

  -- formatter
  "gofumpt",
  "goimports-reviser",
  "jq",
  "hclfmt",
  "latexindent",
  "prettier",
  "prettierd",
  "ruff",
  "shfmt",
  "sqlfmt",
  "stylua",
  "usort",
  "yamlfmt",

  --web3
  "nomicfoundation-solidity-language-server",
  "solhint",
}

M.treesitter_ensure_installed = {
  "gitignore",
  "http",

  -- Typescript
  "typescript",
  "tsx",

  -- Web3
  "solidity",
}

function M.toggleInlayHints()
  vim.lsp.inlay_hint.enable(false, not vim.lsp.inlay_hint.is_enabled())
end

return M
