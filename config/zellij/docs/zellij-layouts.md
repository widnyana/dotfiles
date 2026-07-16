# Zellij — Layouts

> **Source:**
> - <https://zellij.dev/documentation/layouts.html> (overview)
> - <https://zellij.dev/documentation/creating-a-layout.html> (authoring)
> - <https://zellij.dev/documentation/swap-layouts.html> (swap layouts)
>
> Snapshot (2026-07), Zellij 0.40.x. Zellij uses [KDL](https://kdl.dev) as its configuration language.

## Overview

Layouts are text files that define an arrangement of Zellij panes and tabs.

### Example

```kdl
// layout_file.kdl
layout {
    pane
    pane split_direction="vertical" {
        pane
        pane command="htop"
    }
}
```

### Applying a layout

At startup, or inside a running session (applies as one or more new tabs in the current session):

```sh
zellij --layout /path/to/layout_file.kdl
```

From a remote URL (commands are suspended behind a `Waiting to run <command>` banner for security):

```sh
zellij --layout https://example.com/layout_file.kdl
```

### Default directory

By default Zellij loads `default.kdl` from the `layouts` directory (`config/layouts`). If not found, it starts with one pane and one tab. Layouts in the default directory can be referenced by bare name:

```sh
zellij --layout [layout_name]
```

### Runtime override

Override a running tab's layout without restarting via `override-layout` (CLI) or `OverrideLayout` (keybind):

```sh
zellij action override-layout /path/to/new-layout.kdl
zellij action override-layout /path/to/layout.kdl --retain-existing-terminal-panes --apply-only-to-active-tab
```

---

## Creating a layout

Quickstart — dump a starter layout:

```sh
zellij setup --dump-layout default > /tmp/my-quickstart-layout-file.kdl
```

The layout structure nests under a global `layout` node. Possible node types:

- `pane` — basic building block; can be a shell, command, plugin, or a logical container for other `pane`s.
- `tab` — a navigational Zellij tab; can contain `pane`s.
- `pane_template` — define reusable nodes equivalent to `pane`s with extra attributes/parameters.
- `tab_template` — define reusable nodes equivalent to `tab`s with extra attributes/parameters.

### Panes

`pane` nodes are the basic building blocks. Standalone:

```kdl
layout {
    pane                                  // panes can be bare
    pane command="htop"                   // args on the same line
    pane {                                // args inside child-braces
        command "exa"
        cwd "/"
    }
    pane command="ls" {                   // mixture of same-line + child-braces
        cwd "/"
    }
}
```

Logical containers:

```kdl
layout {
    pane split_direction="vertical" {
        pane
        pane
    }
}
```

> If a `pane` is a logical container, **all** its arguments should be on its title line.

#### split_direction
Whether children are laid out vertically or horizontally. Values: `"vertical"` | `"horizontal"`. Default if omitted: `"horizontal"`.

```kdl
layout {
    pane split_direction="vertical" {
        pane
        pane
    }
    pane {                                // omitted → horizontal
        pane
        pane
    }
}
```

> The `layout` node itself defaults to `"horizontal"`. Change it by wrapping children in a logical pane container.

#### size
Fixed or percentage space inside the container. Values: quoted percentages (`"50%"`) | fixed (`1`).

> Fixed values on non-`unselectable` plugins are **currently unstable** and may misbehave when resizing/closing panes.

```kdl
layout {
    pane size=5
    pane split_direction="vertical" {
        pane size="80%"
        pane size="20%"
    }
    pane size=4
}
```

#### borderless
Whether the pane has a frame. Values: `true` | `false`. Default: `false`.

#### focus
Whether the pane has focus on startup. Values: `true` | `false`. Default: `false`. (Multiple focused panes → the first is focused.)

#### name
Change the default pane title. Value: a quoted string.

#### cwd
Current working directory. Values: absolute (`"/path"`) or relative (`"relative/path"`). Relative `cwd` is appended to its container's `cwd` (see [cwd composition](#cwd-composition)).

```kdl
layout {
    pane cwd="/"
    pane {
        command "git"
        args "diff"
        cwd "/path/to/some/folder"
    }
}
```

#### command
Path/name of an executable to run instead of the default shell. Values: `"/path/to/executable"` | `"executable"` (must be on `PATH`).

##### args
One or more quoted strings passed to the command. **Must** be inside the pane's child-braces (not on the title line).

```kdl
layout {
    pane command="tail" {
        args "-f" "/path/to/my/logfile"
    }
    // include "quoted" shell args as a single argument:
    pane command="bash" {
        args "-c" "tail -f /path/to/my/logfile"
    }
}
```

##### close_on_exit
When `true`, the pane closes immediately when its command exits (instead of lingering to show exit status / allow re-run). Values: `true` | `false`.

##### start_suspended
When `true`, the command doesn't run on startup; the pane shows a message inviting `<ENTER>` to start it. Useful for layouts with many commands. Values: `true` | `false`.

#### edit
Path to a file opened with `$EDITOR`/`$VISUAL` (or `scrollback_editor`). Relative paths append to the container's `cwd`.

```kdl
layout {
    pane split_direction="vertical" {
        pane edit="./git_diff_side_a"
        pane edit="./git_diff_side_b"
    }
}
```

#### plugin
Load a Zellij plugin. **Must** be inside the pane's child-braces with a `location` string. Values: `zellij:internal-plugin` | `file:/path/to/plugin.wasm`.

```kdl
layout {
    pane {
        plugin location="zellij:status-bar"
    }
}
```

#### default_fg / default_bg
Default foreground/background color for the pane. Values: `"#rrggbb"` | `"rgb:rr/gg/bb"`. Also settable at runtime via `SetPaneColor` (keybind) or `zellij action set-pane-color` (CLI).

#### stacked
When `true`, this pane's children are arranged in a stack — all but the focused pane collapse to a single title line (plus scroll/exit-code when relevant).

#### expanded
Inside a `stacked` pane, an `expanded=true` child is the one expanded (instead of the default lowest pane).

### Floating panes

A `floating_panes` node may appear at the layout root or inside a `tab`. Panes inside it are floating and accept `x`, `y`, `width`, `height`.

```kdl
layout {
    floating_panes {
        pane
        pane command="ls"
        pane {
            x 1
            y "10%"
            width 200
            height "50%"
        }
    }
}
```

Floating `pane`s take all regular pane properties **except** children nodes and irrelevant ones (e.g. `split_direction`). `pane_template`s for floating panes must omit these too.

#### x / y / width / height
Fixed number (characters from the screen edge) or percentage (recommended when the terminal size is unknown).

### Tabs

`tab` nodes optionally start a layout with several tabs.

> All tab arguments go on its title line; child-braces are reserved for child panes.

```kdl
layout {
    tab                                    // single-pane tab
    tab {                                  // three horizontal panes
        pane
        pane
        pane
    }
    tab name="my third tab" split_direction="vertical" {
        pane
        pane
    }
}
```

Tab attributes mirror panes: `split_direction` (default `"horizontal"`), `focus` (only one tab may be focused), `name`, `cwd`.

#### cwd (tab)
All panes in the tab get this `cwd` prefixed to their own, or start in it if they have none. Absolute child paths override.

```kdl
layout {
    tab name="my amazing tab" cwd="/tmp" {
        pane cwd="foo"          // /tmp/foo
        pane cwd="/home/foo"    // absolute override
    }
}
```

#### hide_floating_panes
If set, floating panes defined in this tab start hidden.

### Templates

Templates avoid repetition. Each template's name is used directly as a node name instead of `pane`/`tab`.

#### Pane templates

```kdl
layout {
    pane_template name="htop" {
        command "htop"
    }
    pane_template name="htop-tree" {
        command "htop"
        args "--tree"
        borderless true
    }
    htop
    htop-tree
    htop-tree
    htop
}
```

Pane templates with a `command` can take `args`/`cwd` from their consumers (direct consumers only — not other templates):

```kdl
layout {
    pane_template name="follow-log" command="tail"
    follow-log { args "-f" "/tmp/my-first-log" }
    follow-log {
        args "-f" "my-second-log"
        cwd "/tmp"
    }
}
```

A `children` node marks where child panes insert when the template is used as a logical container. (`children` may nest inside `pane`s but **not** inside other `pane_template`s.)

```kdl
layout {
    pane_template name="vertical-sandwich" split_direction="vertical" {
        pane
        children
        pane
    }
    vertical-sandwich {
        pane command="htop"
    }
}
```

Pane templates can include other pane templates. `children` is a placeholder for the pane using the template.

#### Tab templates

Like pane templates, with a `children` block for child panes.

> For clarity, arguments passed to `tab_template`s can only be on the title line.

```kdl
layout {
    tab_template name="ranger-on-the-side" {
        pane size=1 borderless=true {
            plugin location="zellij:compact-bar"
        }
        pane split_direction="vertical" {
            pane command="ranger" size="20%"
            children
        }
    }
    ranger-on-the-side name="my first tab" split_direction="horizontal" { pane; pane }
    ranger-on-the-side name="my second tab" split_direction="vertical" { pane; pane }
}
```

##### Default tab template

`default_tab_template` applies to all `tab`s in the layout **and** to all new tabs opened in the session. It does **not** apply to tabs using other `tab_template`s. If no `tab`s are specified, the whole layout is treated as a `default_tab_template`.

```kdl
layout {
    default_tab_template {
        pane size=1 borderless=true {
            plugin location="zellij:tab-bar"
        }
        children
        pane size=2 borderless=true {
            plugin location="zellij:status-bar"
        }
    }
    tab
    tab name="second tab"
    tab split_direction="vertical" { pane; pane; pane }
}
```

### new_tab_template

A logical tab-like node used only as a blueprint for opening new tabs — useful when you want a few initial tabs but a different template for new ones.

### cwd composition

A relative `cwd` is appended to its container's `cwd` in this order:

1. `pane`
2. `tab`
3. global `cwd`
4. the `cwd` where the command was executed

```kdl
layout {
    cwd "/hi"
    tab cwd="there" {
        pane cwd="friend"                 // /hi/there/friend
    }
}
```

### Global cwd

`cwd` on the `layout` node sets a base for all panes (overridden by absolute paths):

```kdl
layout {
    cwd "/home/aram/code/my-project"
    pane cwd="src"          // /home/aram/code/my-project/src
    pane cwd="/tmp"         // absolute override
    pane command="cargo" {  // /home/aram/code/my-project
        args "test"
    }
}
```

---

## Swap layouts

Swap layouts extend layouts: open new panes in predefined locations and rearrange currently open panes in a tab. They split into `swap_tiled_layout` (regular tiled panes) and `swap_floating_layout` (floating panes).

### Quickstart

```sh
zellij setup --dump-swap-layout default > /tmp/my-quickstart-swap-layout-file.swap.kdl
```

### Loading

Swap layouts are included directly inside the `layout` node **or** in a separate `.swap.kdl` file in the same folder (see [Swap layout files](#swap-layout-files-layout-nameswapkdl)).

### Progression and constraints

```kdl
layout {
    swap_tiled_layout name="h2v" {
        tab max_panes=2 {
            pane
            pane
        }
        tab {
            pane split_direction="vertical" {
                pane
                pane
                pane
            }
        }
    }
}
```

The first two panes open horizontally; the next pane (`Alt n`) snaps to three vertical panes; closing one snaps back. Panes beyond the third lay out in an unspecified way.

Floating example:

```kdl
layout {
    swap_floating_layout {
        floating_panes max_panes=1 { pane }
        floating_panes max_panes=2 {
            pane x=0
            pane x="50%"
        }
        floating_panes max_panes=3 {
            pane x=0 width="25%"
            pane x="25%" width="25%"
            pane x="50%"
        }
    }
}
```

### swap_tiled_layout

Includes one or more `tab` nodes (or `tab_template`s). An optional `name` shows in the Zellij UI to indicate the selected layout.

### swap_floating_layout

Includes one or more `floating_panes` nodes (or `tab_template`s). Optional `name` as above.

### Constraints

Each swap `tab`/`floating_panes` node may have exactly one of: `max_panes`, `min_panes`, or `exact_panes`.

```kdl
floating_panes exact_panes=2 {
    pane x=1 y=1
    pane x=10 y=10
}
tab max_panes=2 {
    pane split_direction="vertical" { pane; pane }
}
```

### Pane commands and plugins in swap layouts

`pane` nodes in swap layouts may include `command`/`plugin`, but these are **not** newly opened/closed by their absence — they're expected to already be on screen from the base layout. Otherwise behavior is unspecified.

### Multiple swap layout nodes

Multiple `swap_tiled_layout`/`swap_floating_layout` nodes can coexist. Switch manually (by default `Alt [`/`Alt ]`), or auto-switch when the current node no longer meets its constraint on pane open/close.

### Base

The initially loaded layout is the `Base` layout, switchable like any other. It has an implicit `exact_panes` constraint of its total pane count (both tiled and floating).

- Swap nodes with **more** panes than on screen place extras breadth-first.
- Swap nodes with **fewer** panes apply theirs first; the rest lay out in an unspecified manner.

### Swap layout files (layout-name.swap.kdl)

Because swap layouts get verbose, put them in a sidecar file in the same folder with a `.swap.kdl` suffix. It omits the `layout` node and contains `swap_tiled_layout`/`swap_floating_layout` nodes directly.

```
my-layout.kdl
my-layout.swap.kdl
```
