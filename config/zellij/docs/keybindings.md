# Zellij — Keybindings

> **Scope:** the *effective* keymap for this machine — zellij **0.40.1** stock defaults overlaid with the customizations in `config.kdl` (`keybinds {}` keeps stock defaults; only the `tmux` mode is a full redefinition). Full coverage: every binding is listed below, nothing omitted.
> **Sources:** `zellij setup --dump-config` (stock 0.40.1) + `config.kdl:7-216`. Snapshot 2026-07.
> **Legend:** `†` marks a binding that differs from (or is added beyond) stock zellij — see [Custom layer](#custom-layer--what-differs-from-stock-zellij).

---

## Start here — the keys you'll actually use

You start in **Normal** mode: every key goes straight to your shell. The chords below just work — you do not need to think about modes yet.

| I want to… | press |
| --- | --- |
| open a new pane | `Alt + n` |
| move between panes | `Alt + h j k l`  (← ↓ ↑ →) |
| open a new tab | `Ctrl+t` then `n` |
| switch tab | `Alt + l` (next)  /  `Alt + h` (prev) |
| fullscreen a pane | `Ctrl+p` then `f` |
| search old output | `Ctrl+s` then `s`, type your query, `Enter` |
| jump to any tab by name | `Ctrl+t` then `f` |
| show the in-app cheatsheet | `Ctrl + y` |
| lock (pass *all* keys to the shell) | `Ctrl + g` |
| quit zellij | `Ctrl + q` |

> **How to read a chord:** a two-key combo like `Ctrl+t n` means — hold `Ctrl`, press `t`, **release**, then press `n`. The first key puts you in a mode; the second does the thing.

---

## The status bar changed — how modes work

When you press a `Ctrl + <key>` like `Ctrl+t` or `Ctrl+p`, you enter a **mode** — the status bar changes color and shows which one (`TAB`, `PANE`, `RESIZE`…). Now your keys talk to zellij, not your shell. Each mode is just a group of related one-key actions.

**Getting back to Normal:** press the *same* `Ctrl + <key>` again, or press `Esc` / `Enter`. That toggle is the one rule to remember — the ten chords above hide it for daily use.

| prefix | mode | what it's for |
| --- | --- | --- |
| `Ctrl p` | Pane | split, focus, close, fullscreen, float panes |
| `Ctrl t` | Tab | new / close / switch / rename tabs, fuzzy jump |
| `Ctrl s` | Scroll | scroll back, search, copy |
| `Ctrl o` | Session | detach, session & plugin managers |
| `Ctrl n` | Resize | grow / shrink the focused pane |
| `Ctrl h` | Move | reorder the focused pane |
| `Ctrl a` | Tmux | tmux-style chords (`"` `%` `c` `,` …) † |

> Plus two globals: `Ctrl g` toggles **Locked** (passthrough everything, even the prefixes), and `Ctrl q` quits.

The full list of keys inside each mode is in the [reference below](#full-reference--every-binding-by-mode).

---

## Custom layer — what differs from stock zellij

Six changes on top of the zellij 0.40.1 defaults (marked `†` in the reference):

- **Tmux prefix is `Ctrl a`** (stock: `Ctrl b`), and **`]` = edit scrollback** is added. Every other tmux chord matches stock.
- **Pane `c` / `r` are swapped:** `c` = new pane right, `r` = rename pane (stock: `c` = rename, `r` = new right).
- **Tab `f`** launches **room**, a fuzzy tab switcher.
- **Scroll `Alt c`** copies the selection (stock leaves it unset).
- **Session `p`** launches the **plugin manager**.
- **Global `Ctrl y`** launches **zellij_forgot**, an in-app cheatsheet.

---

## Full reference — every binding by mode

Every mode below follows the same shape: the **prefix** is the headline (it toggles you in and out), and the keys act **only while you're in that mode**.

### Normal
Shell passthrough — every key goes to your shell. This is the mode you start in; there are no zellij binds here.

### Locked — prefix `Ctrl g`
In Locked, *every* key (including the prefixes above) passes straight to the shell — nothing intercepts them.

| key | does |
| --- | --- |
| `Ctrl g` | toggle Locked ↔ Normal |

### Resize — prefix `Ctrl n`
`Ctrl n` toggles Resize: press to enter, press again (or `Esc`) to leave.

| key | does |
| --- | --- |
| `h` / `←` | grow left |
| `j` / `↓` | grow down |
| `k` / `↑` | grow up |
| `l` / `→` | grow right |
| `H` / `J` / `K` / `L` | shrink (same four directions) |
| `=` / `+` | grow (both axes) |
| `-` | shrink (both axes) |

### Pane — prefix `Ctrl p`
`Ctrl p` toggles Pane. Most actions return you to Normal afterwards.

| key | does |
| --- | --- |
| `h` / `←` | focus left |
| `j` / `↓` | focus down |
| `k` / `↑` | focus up |
| `l` / `→` | focus right |
| `p` | switch to last-focused pane |
| `n` | new pane (default direction) |
| `d` | new pane down |
| `c` | new pane right † |
| `r` | rename pane † |
| `x` | close focused pane |
| `f` | toggle fullscreen |
| `z` | toggle pane frames |
| `w` | toggle floating panes |
| `e` | embed ↔ float the focused pane |

### Move — prefix `Ctrl h`
`Ctrl h` toggles Move. Relocates the focused pane within the layout.

| key | does |
| --- | --- |
| `n` / `Tab` | move pane to the next position |
| `p` | move pane backwards |
| `h` / `←` | move pane left |
| `j` / `↓` | move pane down |
| `k` / `↑` | move pane up |
| `l` / `→` | move pane right |

### Tab — prefix `Ctrl t`
`Ctrl t` toggles Tab.

| key | does |
| --- | --- |
| `r` | rename tab |
| `h` / `←` / `k` / `↑` | previous tab |
| `l` / `→` / `j` / `↓` | next tab |
| `n` | new tab |
| `x` | close tab |
| `s` | toggle sync (send input to all panes) |
| `b` | break pane into its own tab |
| `[` | break pane left |
| `]` | break pane right |
| `1`–`9` | go to tab 1–9 |
| `Tab` | toggle to the last tab |
| `f` | fuzzy tab switcher (room) † |

### Scroll — prefix `Ctrl s`
`Ctrl s` toggles Scroll.

| key | does |
| --- | --- |
| `e` | edit scrollback in `$EDITOR` |
| `s` | start a search |
| `Ctrl c` | jump to bottom → Normal |
| `j` / `↓` | scroll one line down |
| `k` / `↑` | scroll one line up |
| `Ctrl f` / `PgDn` / `→` / `l` | page down |
| `Ctrl b` / `PgUp` / `←` / `h` | page up |
| `d` | half page down |
| `u` | half page up |
| `Alt c` | copy the selection † |

### Search — entered from Scroll with `s`
You land here after typing a query in the search box.

| key | does |
| --- | --- |
| `Ctrl s` | leave Search → Normal |
| `Ctrl c` | jump to bottom → Normal |
| `j` / `↓` | scroll one line down |
| `k` / `↑` | scroll one line up |
| `Ctrl f` / `PgDn` / `→` / `l` | page down |
| `Ctrl b` / `PgUp` / `←` / `h` | page up |
| `d` | half page down |
| `u` | half page up |
| `n` | next match |
| `p` | previous match |
| `c` | toggle case sensitivity |
| `w` | toggle wrap |
| `o` | toggle whole-word |

### EnterSearch — the search input box
The prompt that appears when you press `s` in Scroll.

| key | does |
| --- | --- |
| `Enter` | run the search → Search |
| `Ctrl c` / `Esc` | cancel → Scroll |

### RenameTab
Reached from Tab mode `r`. Type the new name, then:

| key | does |
| --- | --- |
| `Ctrl c` | back to Normal |
| `Esc` | undo the rename → Tab |

### RenamePane
Reached from Pane mode `r`. Type the new name, then:

| key | does |
| --- | --- |
| `Ctrl c` | back to Normal |
| `Esc` | undo the rename → Pane |

### Session — prefix `Ctrl o`
`Ctrl o` toggles Session.

| key | does |
| --- | --- |
| `Ctrl s` | go to Scroll |
| `d` | detach the session |
| `w` | session manager (floating) |
| `p` | plugin manager (floating) † |

### Tmux — prefix `Ctrl a` †
A tmux-style layer: press `Ctrl a`, release, then a tmux chord. Matches stock tmux mode except the prefix (`Ctrl a`, stock `Ctrl b`) and the added `]`.

| key | does |
| --- | --- |
| `Ctrl a` | send a literal `Ctrl a` → Normal † |
| `[` | enter Scroll (copy-mode) |
| `]` | edit scrollback † |
| `"` | new pane down |
| `%` | new pane right |
| `z` | toggle fullscreen |
| `c` | new tab |
| `,` | rename tab |
| `p` | previous tab |
| `n` | next tab |
| `o` | focus next pane |
| `arrows` or `h j k l` | move focus |
| `d` | detach |
| `Space` | next swap layout |
| `x` | close focused pane |

### Global keys — work in every mode except Locked
These are available everywhere (including Normal); they don't require entering a mode first.

| key | does |
| --- | --- |
| `Ctrl g` | enter Locked |
| `Ctrl q` | quit zellij |
| `Ctrl y` | launch zellij_forgot cheatsheet † |
| `Alt n` | new pane |
| `Alt i` | move current tab left |
| `Alt o` | move current tab right |
| `Alt h` / `Alt ←` | focus left (jumps to prev tab at the edge) |
| `Alt l` / `Alt →` | focus right (jumps to next tab at the edge) |
| `Alt j` / `Alt ↓` | focus down |
| `Alt k` / `Alt ↑` | focus up |
| `Alt =` / `Alt +` | resize larger |
| `Alt -` | resize smaller |
| `Alt [` | previous swap layout |
| `Alt ]` | next swap layout |

> From any non-Normal, non-Locked mode, `Enter` or `Esc` also returns you to Normal.

---

*Regenerate this file from live sources: `zellij setup --dump-config` (stock defaults) merged with `config.kdl:7-216` (customizations).*
