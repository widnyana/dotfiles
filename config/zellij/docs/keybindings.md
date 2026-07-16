# Zellij — Full Effective Keybindings

> **Scope:** the *effective* keymap for this machine — zellij **0.40.1** stock defaults merged with the customizations in `config.kdl` (`keybinds {}` is defined **without** `clear-defaults=true`, so stock defaults stay active and your binds overlay them; the `tmux` mode alone uses `clear-defaults=true`).
> **Sources:** `zellij setup --dump-config` (stock 0.40.1) + `config.kdl:6-206`. Snapshot 2026-07.
> **Legend:** `(custom)` = this bind differs from / is added beyond the stock default.

## How modes work

- **Normal** is the default mode — keystrokes pass through to the shell.
- **Locked** (`Ctrl g` toggles) passes everything through, including the mode-entry keys below.
- Each non-normal mode is entered with a **mode-entry key** (listed in [Global & mode-entry](#global--mode-entry-bindings)) and exited with `Esc`/`Enter` (back to Normal) or its own `Ctrl <key>`.
- Modes: Normal · Locked · Resize · Pane · Move · Tab · Scroll · Search · EnterSearch · RenameTab · RenamePane · Session · Tmux.

---

## Normal
Shell passthrough — no zellij binds. (Default mode on startup.)

## Locked
| Key     | Action                  |
| ------- | ----------------------- |
| `Ctrl g`| Exit Locked → Normal    |

## Resize
| Key         | Action                  |
| ----------- | ----------------------- |
| `Ctrl n`    | Exit → Normal           |
| `h` / `Left`| Resize Increase Left    |
| `j` / `Down`| Resize Increase Down    |
| `k` / `Up`  | Resize Increase Up      |
| `l` / `Right`| Resize Increase Right  |
| `H`         | Resize Decrease Left    |
| `J`         | Resize Decrease Down    |
| `K`         | Resize Decrease Up      |
| `L`         | Resize Decrease Right   |
| `=` / `+`   | Resize Increase         |
| `-`         | Resize Decrease         |

## Pane
| Key           | Action                              |
| ------------- | ----------------------------------- |
| `Ctrl p`      | Exit → Normal                       |
| `h` / `Left`  | MoveFocus Left                      |
| `l` / `Right` | MoveFocus Right                     |
| `j` / `Down`  | MoveFocus Down                      |
| `k` / `Up`    | MoveFocus Up                        |
| `p`           | SwitchFocus                         |
| `n`           | NewPane → Normal                    |
| `d`           | NewPane Down → Normal               |
| `c`           | NewPane Right → Normal *(custom — stock: RenamePane)* |
| `r`           | RenamePane (PaneNameInput) *(custom — stock: NewPane Right)* |
| `x`           | CloseFocus → Normal                 |
| `f`           | ToggleFocusFullscreen → Normal      |
| `z`           | TogglePaneFrames → Normal           |
| `w`           | ToggleFloatingPanes → Normal        |
| `e`           | TogglePaneEmbedOrFloating → Normal  |

## Move
| Key           | Action            |
| ------------- | ----------------- |
| `Ctrl h`      | Exit → Normal     |
| `n` / `Tab`   | MovePane          |
| `p`           | MovePaneBackwards |
| `h` / `Left`  | MovePane Left     |
| `j` / `Down`  | MovePane Down     |
| `k` / `Up`    | MovePane Up       |
| `l` / `Right` | MovePane Right    |

## Tab
| Key                    | Action                              |
| ---------------------- | ----------------------------------- |
| `Ctrl t`               | Exit → Normal                       |
| `r`                    | RenameTab (TabNameInput)            |
| `h` / `Left` / `Up` / `k` | GoToPreviousTab                  |
| `l` / `Right` / `Down` / `j` | GoToNextTab                   |
| `n`                    | NewTab → Normal                     |
| `x`                    | CloseTab → Normal                   |
| `s`                    | ToggleActiveSyncTab → Normal        |
| `b`                    | BreakPane → Normal                  |
| `]`                    | BreakPaneRight → Normal             |
| `[`                    | BreakPaneLeft → Normal              |
| `1`–`9`                | GoToTab N → Normal                  |
| `Tab`                  | ToggleTab                           |
| `f`                    | Launch **room** (fuzzy tab switcher, floating) → Normal *(custom)* |

## Scroll
| Key                              | Action                |
| -------------------------------- | --------------------- |
| `Ctrl s`                         | Exit → Normal         |
| `e`                              | EditScrollback → Normal |
| `s`                              | EnterSearch (SearchInput) |
| `Ctrl c`                         | ScrollToBottom → Normal |
| `j` / `Down`                     | ScrollDown            |
| `k` / `Up`                       | ScrollUp              |
| `Ctrl f` / `PageDown` / `Right` / `l` | PageScrollDown   |
| `Ctrl b` / `PageUp` / `Left` / `h`   | PageScrollUp     |
| `d`                              | HalfPageScrollDown    |
| `u`                              | HalfPageScrollUp      |
| `Alt c`                          | Copy *(custom — stock: commented out)* |

## Search
| Key                              | Action                |
| -------------------------------- | --------------------- |
| `Ctrl s`                         | Exit → Normal         |
| `Ctrl c`                         | ScrollToBottom → Normal |
| `j` / `Down`                     | ScrollDown            |
| `k` / `Up`                       | ScrollUp              |
| `Ctrl f` / `PageDown` / `Right` / `l` | PageScrollDown   |
| `Ctrl b` / `PageUp` / `Left` / `h`   | PageScrollUp     |
| `d`                              | HalfPageScrollDown    |
| `u`                              | HalfPageScrollUp      |
| `n`                              | Search down           |
| `p`                              | Search up             |
| `c`                              | Toggle CaseSensitivity |
| `w`                              | Toggle Wrap           |
| `o`                              | Toggle WholeWord      |

## EnterSearch
| Key             | Action          |
| --------------- | --------------- |
| `Ctrl c` / `Esc`| → Scroll        |
| `Enter`         | → Search        |

## RenameTab
| Key      | Action                  |
| -------- | ----------------------- |
| `Ctrl c` | → Normal                |
| `Esc`    | UndoRenameTab → Tab     |

## RenamePane
| Key      | Action                  |
| -------- | ----------------------- |
| `Ctrl c` | → Normal                |
| `Esc`    | UndoRenamePane → Pane   |

## Session
| Key       | Action                                  |
| --------- | --------------------------------------- |
| `Ctrl o`  | Exit → Normal                           |
| `Ctrl s`  | → Scroll                                |
| `d`       | Detach                                  |
| `w`       | Launch **session-manager** (floating) → Normal |
| `p`       | Launch **plugin-manager** (floating) → Normal *(custom)* |

## Tmux
> Entered with **`Ctrl a`** (stock uses `Ctrl b`). This mode is defined with `clear-defaults=true`, so it is a full redefinition — but every bind below matches stock tmux **except** the prefix (`Ctrl a`) and the added `]`.

| Key       | Action                          |
| --------- | ------------------------------- |
| `Ctrl a`  | Write `Ctrl a` → Normal *(custom — stock: `Ctrl b`)* |
| `[`       | → Scroll                        |
| `]`       | EditScrollback → Normal *(custom — added)* |
| `"`       | NewPane Down → Normal           |
| `%`       | NewPane Right → Normal          |
| `z`       | ToggleFocusFullscreen → Normal  |
| `c`       | NewTab → Normal                 |
| `,`       | → RenameTab                     |
| `p`       | GoToPreviousTab → Normal        |
| `n`       | GoToNextTab → Normal            |
| `Left`    | MoveFocus Left → Normal         |
| `Right`   | MoveFocus Right → Normal        |
| `Down`    | MoveFocus Down → Normal         |
| `Up`      | MoveFocus Up → Normal           |
| `h`       | MoveFocus Left → Normal         |
| `l`       | MoveFocus Right → Normal        |
| `j`       | MoveFocus Down → Normal         |
| `k`       | MoveFocus Up → Normal           |
| `o`       | FocusNextPane                   |
| `d`       | Detach                          |
| `Space`   | NextSwapLayout                  |
| `x`       | CloseFocus → Normal             |

---

## Global & mode-entry bindings

### Global (`shared_except "locked"` — active in every mode except Locked)
| Key             | Action                          |
| --------------- | ------------------------------- |
| `Ctrl g`        | → Locked                        |
| `Ctrl q`        | Quit                            |
| `Ctrl y`        | Launch **zellij_forgot** (floating) *(custom)* |
| `Alt n`         | NewPane                         |
| `Alt i`         | MoveTab Left                    |
| `Alt o`         | MoveTab Right                   |
| `Alt h` / `Alt Left`   | MoveFocusOrTab Left     |
| `Alt l` / `Alt Right`  | MoveFocusOrTab Right    |
| `Alt j` / `Alt Down`   | MoveFocus Down          |
| `Alt k` / `Alt Up`     | MoveFocus Up            |
| `Alt =` / `Alt +`      | Resize Increase         |
| `Alt -`                | Resize Decrease         |
| `Alt [`                | PreviousSwapLayout      |
| `Alt ]`                | NextSwapLayout          |

### Mode-entry keys
| Key      | Enters mode | Note                         |
| -------- | ----------- | ---------------------------- |
| `Ctrl p` | Pane        | (except Pane/Locked)         |
| `Ctrl n` | Resize      | (except Resize/Locked)       |
| `Ctrl s` | Scroll      | (except Scroll/Locked)       |
| `Ctrl o` | Session     | (except Session/Locked)      |
| `Ctrl t` | Tab         | (except Tab/Locked)          |
| `Ctrl h` | Move        | (except Move/Locked)         |
| `Ctrl a` | Tmux        | *(custom — stock: `Ctrl b`)* |
| `Enter` / `Esc` | Normal | (except Normal/Locked)  |

---

## Customizations vs stock defaults

Everything not listed here is the unmodified zellij 0.40.1 default.

1. **Tmux mode** (`clear-defaults=true`, full redefinition): prefix is **`Ctrl a`** (stock: `Ctrl b`); added **`]`** = EditScrollback. All other tmux binds match stock.
2. **Pane `c` / `r` swap:** `c` = NewPane Right, `r` = RenamePane (stock: `c` = RenamePane, `r` = NewPane Right).
3. **Tab `f`:** launches **room** (fuzzy tab switcher).
4. **Scroll `Alt c`:** Copy (stock leaves it commented out).
5. **Session `p`:** launches **plugin-manager**.
6. **Global `Ctrl y`:** launches **zellij_forgot**.

> Regenerate this file from live sources: `zellij setup --dump-config` (defaults) merged with `config.kdl` (customizations).
