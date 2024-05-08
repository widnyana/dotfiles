local M = {}

-- Packages that should be installed by Mason
M.mason_ensure_installed = {
  -- lsp
  "ansible-language-server",
  "golangci-lint-langserver",
  "lua-language-server",
  "marksman",
  "ruff-lsp",
  "rust-analyzer",
  "sqls",
  "texlab",
  "typescript-language-server",
  "yaml-language-server",

  -- linter
  "ansible-lint",
  "golangci-lint",
  "luacheck",
  "ruff",
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
}

M.treesitter_ensure_installed = {
  "gitignore",
  "http",

  -- Typescript
  "typescript",
  "tsx",
}

return M
