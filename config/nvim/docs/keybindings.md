# Neovim — Keybindings

> **Scope:** this is a LazyVim install. LazyVim alone ships several hundred keymaps across its core
> and enabled extras — those are **not** re-listed here; press `<leader>` and wait, or see
> [lazyvim.org/keymaps](https://www.lazyvim.org/keymaps) for the full stock set. This page documents,
> **completely**, everything this repo adds or changes on top of that stock set.
> **Leader key:** `<Space>`.
> **Sources:** `lua/config/keymaps.lua`, `keys = {}` tables across `lua/plugins/*.lua` and
> `lua/widnyana/**/*.lua`. Snapshot 2026-07-18, verified against the running config.

---

## Start here — daily drivers

| I want to… | press | source |
| --- | --- | --- |
| find a file | `<leader>ff` | LazyVim (fzf-lua) |
| live grep | `<leader>sg` | LazyVim (fzf-lua) |
| jump to a `zoxide` directory | `<leader>fz` | **this repo** |
| toggle the file explorer | `<leader>fe` | LazyVim (neo-tree) |
| toggle inline terminal | `<leader>ft` | LazyVim (snacks) |
| open lazygit | `<leader>gg` | LazyVim (snacks) |
| maximize/restore current split | `<leader>m` | **this repo** |
| split window below / right | `ss` / `sv` | **this repo** |
| move between windows | `sh` `sj` `sk` `sl` | **this repo** |
| next / prev diagnostic | `]d` / `[d` | LazyVim |
| jump to next diagnostic (this repo's binding) | `<C-j>` | **this repo** (overrides LazyVim's window-nav) |
| format buffer | `<leader>cf` | LazyVim |
| symbols outline | `<leader>cs` | LazyVim extra (symbols-outline.nvim) |
| next / prev buffer-tab | `<Tab>` / `<S-Tab>` | **this repo** (bufferline) |

---

## Custom layer — everything this repo adds or changes

This is the complete, non-abbreviated list. Anything not here is stock LazyVim.

### `lua/config/keymaps.lua`

| Key | Mode | Does |
| --- | --- | --- |
| `+` | n | increment number under cursor (`<C-a>`) |
| `-` | n | decrement number under cursor (`<C-x>`) |
| `dw` | n | delete word **backward** (`vb_d`) — note: shadows the built-in `dw` (delete word forward) |
| `<C-a>` | n | select entire buffer (`gg<S-v>G`) |
| `<Leader>o` | n | insert blank line below, stay in normal mode, no comment continuation |
| `<Leader>O` | n | insert blank line above, same |
| `<C-m>` | n | jump forward in jumplist (`<C-i>`) — ⚠️ see quirk below, this also affects `<CR>` |
| `te` | n | `:tabedit` (starts the command, doesn't submit) |
| `ss` | n | `:split` |
| `sv` | n | `:vsplit` |
| `sh` / `sj` / `sk` / `sl` | n | move focus to window left/down/up/right (`<C-w>h/j/k/l`) |
| `<C-j>` | n | jump to next diagnostic — **replaces** LazyVim's default "go to window below" |

### Plugin-attached keys (new or repo-specific)

| Key | Plugin | Does |
| --- | --- | --- |
| `<leader>fz` | `snacks.nvim` picker | Zoxide picker — jump to any `zoxide`-tracked directory |
| `<leader>m` | `windows.nvim` | Toggle-maximize the current split (also auto-equalizes splits as you move focus) |
| `<Tab>` | `bufferline.nvim` | Next buffer-tab (`BufferLineCycleNext`) |
| `<S-Tab>` | `bufferline.nvim` | Prev buffer-tab (`BufferLineCyclePrev`) |
| `<leader>fe` / `<leader>fE` | `neo-tree.nvim` | Explorer at root dir / at cwd |
| `<leader>e` / `<leader>E` | `neo-tree.nvim` | same as above (remapped aliases) |
| `<leader>ge` | `neo-tree.nvim` | Git status explorer |
| `<leader>be` | `neo-tree.nvim` | Buffer explorer |
| `<leader>cs` | `symbols-outline.nvim` | Toggle symbols outline sidebar |

### Inside the neo-tree window (buffer-local, not global)

| Key | Does |
| --- | --- |
| `e` | focus filesystem view |
| `b` | focus buffers view |
| `g` | focus git-status view |
| `Y` | copy the node's path to the system clipboard |
| `O` | open the node with the OS default application |
| `<Space>` | unbound (`none`) — neo-tree's default space-toggle is disabled |

(Neo-tree's own defaults — `<CR>` open, `a` add, `d` delete, `r` rename, etc. — still apply; press `?`
inside the explorer for its full list.)

---

## Known conflicts & quirks

Documented as-is, not fixed — flagging so they're not a surprise:

- **`gd` does nothing.** `lua/plugins/lsp.lua` binds `gd` on `nvim-lspconfig` to an empty function,
  overriding LazyVim's default "Goto Definition" picker. If `gd` isn't jumping anywhere, this is why.
- **`<C-j>` no longer moves focus to the window below.** LazyVim's default `<C-h/j/k/l>` window
  navigation is broken specifically for `j` — `keymaps.lua` repurposes it for "next diagnostic".
  `<C-h>`, `<C-k>`, `<C-l>` still navigate windows as normal; use `sj` (this repo's own binding) to
  move down a window instead.
- **`<C-m>` remap also remaps `<Enter>`.** In terminals, `Ctrl-M` and `<CR>` send the same byte, so
  vim treats them as one binding. Remapping `<C-m>` to "jump forward in jumplist" means pressing
  `<Enter>` in normal mode does that too, instead of its usual "move down + first non-blank" behavior.
- **Two ways to maximize a window.** LazyVim core already provides `<leader>wm` / `<leader>uZ`
  (`Snacks.toggle.zoom()`). `windows.nvim`'s `<leader>m` (this repo) does something related but
  distinct — auto-equalize plus maximize/restore. Both work; they're not the same command.

---

## Also see

- [plugins.md](./plugins.md) — what each plugin is for
- [lazyvim.org/keymaps](https://www.lazyvim.org/keymaps) — full stock LazyVim keymap reference
- In-editor: press `<leader>` and wait for which-key's popup, or `:WhichKey` for the full live list
