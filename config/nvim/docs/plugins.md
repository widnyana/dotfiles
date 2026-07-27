# Neovim — Plugins

> **Scope:** this is a [LazyVim](https://www.lazyvim.org/) install — LazyVim's own defaults are not
> re-documented here (see [lazyvim.org/plugins](https://www.lazyvim.org/plugins)). This page covers
> what LazyVim **extras** are enabled and everything layered on top in `lua/plugins/` and
> `lua/widnyana/`.
> **Sources:** `lazyvim.json`, `lua/plugins/*.lua`, `lua/widnyana/**/*.lua`, `lazy-lock.json`. Snapshot 2026-07-18.

---

## How this config is laid out

```
init.lua                    → require("config.lazy")
lua/config/                 → lazy.nvim bootstrap, options, keymaps, autocmds (loaded by LazyVim)
lua/plugins/                → top-level overrides of LazyVim/core plugins
lua/widnyana/               → personal namespace: own plugins + LSP/treesitter server lists
lua/widnyana/plugins/lang/  → per-language extras not covered by a LazyVim extra
```

`lua/config/lazy.lua` imports, in order: LazyVim core → LazyVim extras (from `lazyvim.json`) →
`plugins/*.lua` → `widnyana/plugins/**/*.lua`. Anything in the later two can override an earlier spec
by re-declaring the same plugin name with `opts = function(_, opts) ... end`.

---

## LazyVim extras enabled

| Extra | Gives you |
| --- | --- |
| `editor.navic` | LSP breadcrumb (`class > method > var`) in the lualine statusline |
| `editor.refactoring` | `<leader>cr…` refactor operations (extract function/variable, inline) |
| `lang.git` | git-aware LSP/syntax bits for commit messages, etc. |
| `lang.go` | gopls + `golangci-lint` linter wiring, `<leader>c…` Go code actions |
| `lang.helm` | Helm chart syntax + LSP |
| `lang.json` | jsonls via schemastore (also configured manually, see below) |
| `lang.markdown` | markdown preview/render, `markdownlint` |
| `lang.typescript` | base TS/JS LSP wiring (superseded here by `typescript-tools.nvim`, see below) |
| `lang.yaml` | yamlls via schemastore (also configured manually, see below) |
| `util.dot` | Graphviz `.dot` file preview |
| `util.project` | auto-detects project root, powers the dashboard's "Projects" section |

Full extras catalog: `lazyvim.json`.

---

## Colorschemes & theming

| Plugin | Role |
| --- | --- |
| `craftzdog/solarized-osaka.nvim` | **default at startup** — `storm` style, transparent background |
| `zaldih/themery.nvim` | live-preview theme switcher — run `:Themery` to cycle/pick |
| `ellisonleao/gruvbox.nvim`, `rebelot/kanagawa.nvim`, `rose-pine/neovim`, `catppuccin/nvim`, `sam4llis/nvim-tundra`, `neanias/everforest-nvim`, `nyoom-engineering/oxocarbon.nvim` | alternates, all lazy-loaded and selectable from `:Themery`'s list |

---

## Completion & snippets

| Plugin | Role |
| --- | --- |
| `hrsh7th/nvim-cmp` | completion engine (LazyVim default) |
| `L3MON4D3/LuaSnip` | snippet engine |

`lua/plugins/coding.lua` rewires both to **supertab** behavior: `<Tab>`/`<S-Tab>` cycle the completion
menu or jump snippet placeholders, instead of LazyVim's default split keys.

---

## LSP

Base: `mason-org/mason.nvim` + `neovim/nvim-lspconfig` (LazyVim core). `lua/widnyana/lsp.lua` is the
single source of truth for what Mason installs — edit `M.mason_ensure_installed` there, not per-plugin.

| Language | Server | Notes |
| --- | --- | --- |
| Lua | `lua_ls` | tuned diagnostics/hints, see `lua/plugins/lsp.lua` |
| Python | `ruff` | active (`pyright` wired but disabled — flip `python_lsp` in `lua/plugins/lsp.lua` to switch) |
| Rust | `rust_analyzer` | defaults |
| Go | `gopls` | via `lang.go` extra |
| TypeScript/JS | `typescript-tools.nvim` | replaces `tsserver`, handles LSP + code actions (`fix_all`, `organize_imports`, …); formatting delegated to `biome` via `conform.nvim` |
| JSON | `jsonls` | schemas from `b0o/SchemaStore.nvim` |
| YAML | `yamlls` | schemas from `b0o/SchemaStore.nvim`, plus `cwrau/yaml-schema-detect.nvim` |
| Terraform/HCL | `terraformls` | `lua/widnyana/plugins/lang/terragrunt.lua` |
| Solidity | `nomicfoundation-solidity-language-server` | custom root-dir detection (foundry/hardhat/truffle configs), `lua/widnyana/plugins/lang/solidity.lua` |
| LaTeX | `vimtex` + `texlab` | `K` is unbound inside vimtex buffers to avoid clashing with LSP hover |

Other LSP-adjacent plugins:

| Plugin | Role |
| --- | --- |
| `simrat39/symbols-outline.nvim` | symbols sidebar, `<leader>cs` |
| `SmiteshP/nvim-navic` | breadcrumb trail in the statusline (via `editor.navic` extra above) |

> **Quirk:** `lua/plugins/lsp.lua` declares a `gd` key on `nvim-lspconfig` bound to an **empty
> function**, which overrides LazyVim's default "Goto Definition" picker with a no-op. `gd` currently
> does nothing. Worth a look if you expect it to jump to definitions.

---

## Linting & formatting

`nvim-lint` (LazyVim core) runs linters async; `conform.nvim` handles formatting.

| Filetype | Linters | Formatter |
| --- | --- | --- |
| Python | `cspell` | `ruff` (via Mason) |
| Go | `golangcilint`, `cspell` | `gofumpt`, `goimports-reviser` |
| Rust | `cspell` | (rustfmt via rust-analyzer) |
| YAML | `cspell` | `yamlfmt` |
| Terraform | `terraform_validate`, `cspell` | `hclfmt` |
| HCL | `cspell` | `hclfmt` |
| TypeScript/JS/JSON | `cspell` | `biome` |

`cspell`/`markdownlint`/`shellcheck`/etc. binaries all come from `M.mason_ensure_installed` in
`lua/widnyana/lsp.lua` — that list is the actual source of truth for what's installed; the table
above is what's wired to actually *run*.

---

## Treesitter

`nvim-treesitter` with extra parsers from `lua/widnyana/lsp.lua` (`treesitter_ensure_installed`):
`gitignore`, `http`, `typescript`, `tsx`, `solidity`. `.mdx` files are registered as `markdown`
filetype/treesitter for syntax purposes (`lua/plugins/treesitter.lua`).

---

## Files, search & navigation

| Plugin | Role |
| --- | --- |
| `ibhagwan/fzf-lua` | **default fuzzy finder** — backs `<leader>ff`, `<leader>fg`, `<leader>sg`, etc. |
| `nvim-neo-tree/neo-tree.nvim` | file explorer sidebar — `<leader>fe`/`<leader>fE`/`<leader>ge`/`<leader>be` |
| `folke/snacks.nvim` (picker module) | used directly for the **zoxide** source — `<leader>fz` jumps to any `zoxide`-tracked directory |
| LazyVim `util.project` extra | project root auto-detection, feeds the dashboard's "Projects" list |

Two picker backends coexist by design: fzf-lua covers the general file/grep/buffer pickers, snacks'
picker is used specifically where it has a source fzf-lua doesn't (zoxide).

---

## UI

| Plugin | Role |
| --- | --- |
| `folke/snacks.nvim` | dashboard (custom ASCII logo + keymaps/recent-files/projects sections), terminal, lazygit integration, notifications, window zoom, indent guides, statuscolumn |
| `folke/noice.nvim` | cmdline, messages and popupmenu UI |
| `akinsho/bufferline.nvim` | buffer/tab line, `mode = "tabs"` |
| `lukas-reineke/indent-blankline.nvim` | indent guides; excluded filetypes list lives in `lua/widnyana/config/init.lua` |
| `anuvyklack/windows.nvim` | auto-equalizes splits as you move focus between them, `<leader>m` maximizes/restores the current split |

> **Quirk:** `<Tab>`/`<S-Tab>` are bound twice — once in `lua/config/keymaps.lua` (`:tabnext`/`:tabprev`,
> vim tabs) and once by `bufferline.nvim` (`BufferLineCycleNext`/`Prev`). Whichever loads last wins;
> if `<Tab>` isn't doing what you expect, this is why.
>
> **Quirk:** LazyVim core already provides a window-zoom toggle at `<leader>wm` /
> `<leader>uZ` (`Snacks.toggle.zoom()`). `windows.nvim`'s `<leader>m` is a different mechanism
> (auto-equalize + maximize) but overlaps in purpose — you now have two ways to "make this window big".

---

## Images & diagrams

| Plugin | Role |
| --- | --- |
| `3rd/image.nvim` | renders images inline (kitty backend) — png/jpg/jpeg/gif/webp/svg |
| `3rd/diagram.nvim` | renders mermaid/plantuml/d2 diagrams via `image.nvim` |
| `vhyrro/luarocks.nvim` | build dependency for the above, must load first (`priority = 1000`) |

---

## Web3

| Plugin | Role |
| --- | --- |
| Solidity LSP (see LSP table) | `nomicfoundation-solidity-language-server` |
| `solhint` (Mason) | Solidity linter |

---

## Personal utility modules (not plugins)

| File | Role |
| --- | --- |
| `lua/widnyana/common.lua` | shared LSP client flags (`debounce_text_changes`) |
| `lua/widnyana/utils/init.lua` | `dedup()` — dedupe a list, used by config wiring |
| `lua/widnyana/config/init.lua` | `excluded_filetypes` — consumed by indent-blankline |
| `lua/widnyana/config/validation.lua` | startup checks (git executable, minimum Neovim version); run from `init.lua` |
| `lua/widnyana/config/logging.lua` | wraps `vim.notify`, persists every notification to `stdpath("state")/messages.log`; `setup()` runs from `init.lua` before `lazy.nvim` loads so it also catches bootstrap-time notifications |
| `lua/widnyana/lsp.lua` | `M.toggleInlayHints()` — **defined but not bound to any keymap**, dead code today |

---

## Also see

- [keybindings.md](./keybindings.md) — what's bound to what
- [LazyVim plugin docs](https://www.lazyvim.org/plugins) — everything LazyVim ships by default, not repeated here
