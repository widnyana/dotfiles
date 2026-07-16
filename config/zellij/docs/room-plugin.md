# room — Zellij tab switcher

> **Source:** <https://github.com/rvcas/room> — README snapshot (2026-07)
> A [Zellij](https://zellij.dev) plugin for quickly searching and switching between tabs.

## Usage

- `Tab` to cycle through the tab list
- `Up` and `Down` to cycle through the tab list
- `Enter` to switch to the selected tab
- Start typing to filter the tab list
- `Esc` or `Ctrl c` to exit
- Quick jump to a tab by pressing its displayed number

> To enable quick jumps, set `quick_jump true`. Downside: you won't be able to
> properly filter down tabs that have a number in their name.

## Installation

Download `room.wasm` from the [latest release](https://github.com/rvcas/room/releases/latest):

```sh
mkdir -p ~/.config/zellij/plugins && \
  curl -fL "https://github.com/rvcas/room/releases/latest/download/room.wasm" \
  -o ~/.config/zellij/plugins/room.wasm
```

> The location is just a convention — you can keep `room.wasm` anywhere.

## Keybinding (upstream example)

Add inside the `keybinds` section of your zellij config:

```kdl
shared_except "locked" {
    bind "Ctrl y" {
        LaunchOrFocusPlugin "file:~/.config/zellij/plugins/room.wasm" {
            floating true
            ignore_case true
            quick_jump true
        }
    }
}
```

> You likely already have a `shared_except "locked"` block — add the `bind` there.

### Config options

| Option       | Default | Effect                                                                                  |
| ------------ | ------- | --------------------------------------------------------------------------------------- |
| `floating`   | —       | Open room as a floating pane.                                                           |
| `ignore_case`| `false` | When `true`, filtering ignores the case of both the filter string and the tab name.    |
| `quick_jump` | `false` | When `true`, press a tab's displayed number to jump to it (breaks filtering of tabs whose names contain that digit). |

## Pipe commands

room supports programmatic pane focusing via Zellij's plugin pipe system.

### focus-pane

Focus a specific terminal pane by ID:

```sh
zellij pipe --plugin file:~/.config/zellij/plugins/room.wasm --name focus-pane -- <pane_id>
```

Zellij's CLI can switch tabs but has no command to focus a pane by ID; the plugin
API can (`focus_terminal_pane`), so this pipe command bridges that gap. It pairs
with [claude-zellij-whip](https://github.com/rvcas/claude-zellij-whip), which
sends native notifications that, when clicked, (1) focus the terminal window,
(2) switch to the correct Zellij tab, and (3) focus the exact pane where
[Claude Code](https://docs.anthropic.com/en/docs/claude-code) is running.

## Local wiring (this dotfiles)

- **Binary:** `~/.config/zellij/plugins/room.wasm` → `~/.dotfiles/config/zellij/plugins/room.wasm`
- **Keybind:** bound inside the **tab** mode as `Ctrl t` then `f` (see `config.kdl`, `tab {}` block). Chosen to avoid clashing with `zellij_forgot`, which is already on `Ctrl y`. Config: `floating true`, `ignore_case true`, `quick_jump true`.

## Development

Requires [rust](https://rustup.rs/), then:

```sh
zellij action new-tab --layout ./dev.kdl
```
