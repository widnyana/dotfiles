---
artifact_contract: ce-unified-plan/v1
artifact_readiness: implementation-ready
execution: code
product_contract_source: ce-plan-bootstrap
created: 2026-07-15
---

# fix: Resolve Neovim boot errors — invalid autocmd event and stale plugin lock

## Summary

Neovim fails to start due to two issues in the dotfiles config: an invalid autocmd event (`ErrorMsg`) in `lua/config/autocmds.lua` that throws a hard Lua error at boot, and a stale `async.nvim` entry in `lazy-lock.json` that has no corresponding plugin spec.

## Problem Frame

The Neovim config at `config/nvim/` (symlinked to `~/.config/nvim`) is a LazyVim-based setup. Two independent issues prevent clean startup:

1. **Invalid autocmd event.** `lua/config/autocmds.lua` registers an autocmd with `{ "ErrorMsg", "WarningMsg" }` as events. These are Vim highlight groups, not valid Neovim autocmd events. `nvim_create_autocmd` throws `Invalid 'event': 'ErrorMsg'` at boot, aborting the config load.

2. **Stale plugin lock entry.** `lazy-lock.json` contains `"async.nvim"` with a commit hash, but no plugin spec in any `lua/` file references it. Lazy.nvim reports `spec=nil` for it. It is an orphaned entry — likely installed through the `:Lazy` UI or as a transitive dependency of a spec that was later removed.

## Requirements

- R1: Neovim must start without the `Invalid 'event': 'ErrorMsg'` error
- R2: The `vim.notify` logging wrapper (which already logs all notification-path messages) must remain intact
- R3: `lazy-lock.json` must not contain entries for plugins with no corresponding spec
- R4: No new plugin specs or imports should be added — the fix is purely subtractive

## Key Technical Decisions

- **KTD1: Remove the invalid autocmd, don't replace it.** The `vim.notify` wrapper defined immediately above the invalid autocmd already catches and logs all messages routed through Neovim's notification system. Raw editor errors that bypass `vim.notify` cannot be intercepted by any valid Neovim autocmd event. Removing the block loses no functional coverage.
- **KTD2: Remove `async.nvim` from lockfile only.** No plugin spec references `async.nvim` anywhere in the config. The lockfile entry is the only trace. No spec file changes are needed.

## Scope Boundaries

### In scope
- Remove the `ErrorMsg`/`WarningMsg` autocmd block from `config/nvim/lua/config/autocmds.lua`
- Remove the `async.nvim` entry from `config/nvim/lazy-lock.json`
- Clean up the orphaned plugin directory from disk

### Deferred to Follow-Up Work
- If the config layout changes again, keep plan paths rooted at `config/nvim/` for this repo so the implementation units, verification contract, and scope list stay in one reference frame.

### Out of scope
- No changes to plugin spec files, `init.lua`, `lazy.lua`, or any other config
- No replacement autocmd for error logging — the `vim.notify` wrapper is sufficient
- No changes to `refactoring.nvim` (it has its own spec and is unrelated)

## Implementation Units

### U1. Remove invalid autocmd from autocmds.lua

- **Goal:** Remove the `nvim_create_autocmd({ "ErrorMsg", "WarningMsg" }, ...)` block that causes a hard boot error
- **Requirements:** R1, R2
- **Dependencies:** None
- **Files:**
  - Modify: `config/nvim/lua/config/autocmds.lua`
- **Approach:** Delete lines 53-59 (the autocmd block). Keep the `vim.notify` wrapper at lines 45-51 intact.
- **Test scenarios:**
  - Happy path: Start Neovim headless — no `Invalid 'event': 'ErrorMsg'` error in `:messages` or state log
  - Error path: Confirm the `vim.notify` wrapper still logs messages to `messages.log` (e.g., trigger a notification and check the log)
- **Verification:** `nvim --headless -c "qa"` exits cleanly; `grep -i "ErrorMsg\|WarningMsg" ~/.local/state/nvim/messages.log` returns empty

### U2. Remove stale async.nvim from lazy-lock.json

- **Goal:** Remove the orphaned `async.nvim` lock entry so Lazy doesn't track a plugin with no spec
- **Requirements:** R3, R4
- **Dependencies:** None
- **Files:**
  - Modify: `config/nvim/lazy-lock.json`
- **Approach:** Delete the `"async.nvim"` line from the JSON object. Validate the resulting JSON is parseable.
- **Test scenarios:**
  - Happy path: `python3 -c "import json; json.load(open('config/nvim/lazy-lock.json'))"` succeeds
  - Integration: `nvim --headless -c "lua local p=require('lazy').plugins(); for _,pl in ipairs(p) do if pl.name=='async.nvim' then print('found') end end" -c "qa"` prints nothing
- **Verification:** JSON parse passes; Lazy plugin list no longer shows `async.nvim`

### U3. Clean up orphaned plugin directory

- **Goal:** Remove the orphaned `async.nvim` install from the Lazy plugin cache
- **Requirements:** R3
- **Dependencies:** U2
- **Files:** None (disk cleanup)
- **Approach:** Run `:Lazy clean` inside Neovim, or `rm -rf ~/.local/share/nvim/lazy/async.nvim/`
- **Test scenarios:**
  - Happy path: `ls ~/.local/share/nvim/lazy/async.nvim/` returns "No such file or directory"
- **Verification:** Plugin directory no longer exists on disk

## Verification Contract

1. `nvim --headless -c "qa"` exits with code 0
2. `grep -i "ErrorMsg\|WarningMsg" ~/.local/state/nvim/messages.log` returns empty
3. `python3 -c "import json; json.load(open('config/nvim/lazy-lock.json'))"` succeeds
4. `grep "async.nvim" config/nvim/lazy-lock.json` returns empty
5. `ls ~/.local/share/nvim/lazy/async.nvim/ 2>&1` returns "No such file or directory"
6. Open Neovim normally — no boot errors in `:messages`

## Definition of Done

- [ ] U1: autocmd block removed, boot error gone
- [ ] U2: async.nvim removed from lockfile, JSON valid
- [ ] U3: orphaned plugin directory cleaned up
- [ ] All verification checks pass
- [ ] Neovim starts cleanly in normal mode
