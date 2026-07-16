# Zellij — Configuration Options

> **Source:** <https://zellij.dev/documentation/options.html> — snapshot (2026-07), Zellij 0.40.x
> Configuration options are set directly at the **root** of `config.kdl`.

## Option index

`on_force_close` · `simplified_ui` · `default_shell` · `pane_frames` · `theme` · `theme_dark` · `theme_light` · `default_layout` · `default_mode` · `mouse_mode` · `scroll_buffer_size` · `copy_command` · `copy_clipboard` · `copy_on_select` · `scrollback_editor` · `mirror_session` · `layout_dir` · `theme_dir` · `env` · `rounded_corners` · `hide_session_name` · `auto_layout` · `styled_underlines` · `session_serialization` · `pane_viewport_serialization` · `scrollback_lines_to_serialize` · `serialization_interval` · `disable_session_metadata` · `stacked_resize` · `show_startup_tips` · `show_release_notes` · `post_command_discovery_hook` · `web_server` · `web_server_ip` · `web_server_port` · `web_server_cert` · `web_server_key` · `enforce_https_on_localhost` · `base_url` · `web_client` · `advanced_mouse_actions` · `default_cwd` · `osc8_hyperlinks` · `session_name` · `attach_to_session` · `support_kitty_keyboard_protocol` · `web_sharing` · `mouse_hover_effects` · `visual_bell` · `focus_follows_mouse` · `mouse_click_through`

---

### on_force_close
What to do when zellij receives SIGTERM/SIGINT/SIGQUIT/SIGHUP (e.g. the terminal window with an active session is closed).
- Options: `detach` (default) · `quit`
```kdl
on_force_close "quit"
```

### simplified_ui
Request a simplified UI (no arrow fonts) from plugins.
- Options: `true` · `false` (default)
```kdl
simplified_ui true
```

### default_shell
Path to the default shell for opening new panes. Default: `$SHELL`.
```kdl
default_shell "fish"
```

### pane_frames
Toggle pane frames. Options: `true` (default) · `false`.
```kdl
pane_frames true
```

### theme
Zellij color theme. Must be defined in the `themes` section or loaded from the themes folder. Default: `default`.
```kdl
theme "default"
```

### theme_dark
Theme used as the "dark" theme. Applied by `SetDarkTheme`/`ToggleTheme`, and automatically when the host terminal reports dark mode (CSI 2031 / DSR 997).
```kdl
theme_dark "catppuccin-mocha"
```

### theme_light
Theme used as the "light" theme. Same triggers as `theme_dark` (light mode).
```kdl
theme_light "catppuccin-latte"
```

### default_layout
Name of the layout to load on startup (must be in the layouts folder). Default: `default`.
```kdl
default_layout "compact"
```

### default_mode
Mode zellij starts in. Default: `normal`.
```kdl
default_mode "locked"
```

### mouse_mode
Toggle mouse mode (can interfere with copying text on some terminals). Options: `true` (default) · `false`.
```kdl
mouse_mode false
```

### scroll_buffer_size
Lines zellij stores per pane in the scrollback buffer; excess discarded FIFO. Default: `10000`.
```kdl
scroll_buffer_size 10000
```

### copy_command
Command to execute when copying text; the text is piped to its stdin. Used for terminals that don't support OSC 52 (the default when unset).
```kdl
copy_command "xclip -selection clipboard" // x11
copy_command "wl-copy"                    // wayland
copy_command "pbcopy"                     // osx
```

### copy_clipboard
Destination for copied text. Lets you use the X11/Wayland primary selection instead of the system clipboard. Ignored when `copy_command` is set.
- Options: `system` (default) · `primary`
```kdl
copy_clipboard "primary"
```

### copy_on_select
Auto-copy the selection on mouse release. Default: `true`.
```kdl
copy_on_select false
```

### scrollback_editor
Default editor for editing pane scrollback and the CLI/layout `edit` commands. Default: `$EDITOR` or `$VISUAL`.
```kdl
scrollback_editor "/usr/bin/vim"
```

### mirror_session
When attaching to an existing session with other users, mirror the session (`true`) or give each user their own cursor (`false`). Default: `false`.
```kdl
mirror_session true
```

### layout_dir
Folder where Zellij looks for layouts.
```kdl
layout_dir "/path/to/my/layout_dir"
```

### theme_dir
Folder where Zellij looks for themes.
```kdl
theme_dir "/path/to/my/theme_dir"
```

### env
Key→value map of environment variables set for each terminal pane zellij starts.
```kdl
env {
    RUST_BACKTRACE 1
    FOO "bar"
}
```

### rounded_corners
Whether pane frames (if visible) have rounded corners. **Note:** set inside a `ui` block.
```kdl
ui {
    pane_frames {
        rounded_corners true
    }
}
```

### hide_session_name
Hide the session name (random or otherwise) from the UI.
```kdl
ui {
    pane_frames {
        hide_session_name true
    }
}
```

### auto_layout
Have Zellij lay out panes by a predefined set of layouts when possible. Options: `true` (default) · `false`.
```kdl
auto_layout true
```

### styled_underlines
Support the extended "styled_underlines" ANSI protocol (can cause issues on unsupported terminals). Options: `true` (default) · `false`.
```kdl
styled_underlines true
```

### session_serialization
If enabled, sessions are serialized to the cache folder (and thus become resurrectable between reboots or on exit). Options: `true` (default) · `false`.
```kdl
session_serialization true
```

### pane_viewport_serialization
If enabled along with `session_serialization`, the pane viewport (visible terminal excluding scrollback) is serialized and resurrectable too. Options: `true` · `false` (default).
```kdl
pane_viewport_serialization true
```

### scrollback_lines_to_serialize
When `pane_viewport_serialization` is on: `0` = serialize all scrollback; any other int = serialize up to that many lines (max is the scrollback limit).
```kdl
scrollback_lines_to_serialize 100
```

### serialization_interval
How often (seconds) sessions are serialized to disk (if `session_serialization` is on).
```kdl
serialization_interval 60
```

### disable_session_metadata
Enable/disable writing session metadata to disk. If disabled, features like the session-manager and session listing may not work properly. Options: `true` · `false` (default).
```kdl
disable_session_metadata true
```

### stacked_resize
Attempt to stack panes with their neighbors when resizing non-directionally (by default `Alt +/-`). Options: `true` (default) · `false`.
```kdl
stacked_resize true
```

### show_startup_tips
Show usage tips on startup (also browsable via `Ctrl o` + `a` then `?`). Options: `true` (default) · `false`.
```kdl
show_startup_tips true
```

### show_release_notes
Show release notes on first run of a new version (also browsable via `Ctrl o` + `a`). Options: `true` (default) · `false`.
```kdl
show_release_notes true
```

### post_command_discovery_hook
When Zellij's command discovery is inaccurate (e.g. commands run inside a wrapper), define a hook that runs in the default shell, receives `$RESURRECT_COMMAND`, and whose STDOUT is serialized in its place.
```kdl
post_command_discovery_hook "echo \"$RESURRECT_COMMAND\" | sed 's/^sudo\\s\\+//'" // strip sudo
```

### web_server
Start the Zellij web-server on startup. Options: `true` · `false` (default).

### web_server_ip
IP for the web-server to listen on when started. Default: `127.0.0.1`.

### web_server_port
Port for the web-server to listen on when started. Default: `8082`.

### web_server_cert
Path to the SSL cert for the web-server. `web_server_key` must also be present to serve HTTPS.

### web_server_key
Path to the SSL private key for the web-server. `web_server_cert` must also be present to serve HTTPS.

### enforce_https_on_localhost
Enforce HTTPS on localhost for the web-server. Always enforced on non-localhost addresses.

### base_url
Base URL path the web-server serves under (useful behind a reverse proxy serving Zellij under a subpath). Default: none (served at root `/`).
```kdl
web_client {
    base_url "/zellij"
}
```

### web_client
Configuration for the in-browser terminal of the web client (colors, font). Options: `true` · `false` (default).

### advanced_mouse_actions
Enable mouse hover effects, multi-select (pane grouping), and mouse-based pane resizing:
- **Drag tiled pane borders** to resize.
- **Ctrl+Drag floating pane borders** to resize.
- **Ctrl+ScrollWheel** to resize the focused pane (~5 cells).
Options: `true` (default) · `false`.

### default_cwd
Default current working directory for new panes (used unless otherwise specified).
```kdl
default_cwd "/home/user/projects"
```

### osc8_hyperlinks
Enable clickable OSC8 hyperlink output. Programs emitting OSC8 sequences produce clickable links. Options: `true` · `false` (default).
```kdl
osc8_hyperlinks true
```

### session_name
Name of the session to create on startup. If unset, a random name is generated.
```kdl
session_name "my-session"
```

### attach_to_session
If a session named via `session_name` already exists, attach to it instead of creating a new one. Options: `true` · `false` (default).
```kdl
attach_to_session true
```

### support_kitty_keyboard_protocol
Enable the Kitty keyboard protocol (more detailed key reporting). Defaults to `true` if the terminal supports it. Options: `true` (default if supported) · `false`.
```kdl
support_kitty_keyboard_protocol true
```

### web_sharing
Whether new sessions are shared through the local web server (separate from `web_server`, which controls whether the server starts).
- Options: `"on"` (shared by default) · `"off"` (not shared; default) · `"disabled"` (sharing completely disabled)
```kdl
web_sharing "on"
```

### mouse_hover_effects
Enable hover visual effects (pane frame highlight, help text). Options: `true` (default) · `false`.
```kdl
mouse_hover_effects false
```

### visual_bell
Show visual bell indicators (brief pane/tab frame flash + `[!]` suffix on the tab name). Options: `true` (default) · `false`.
```kdl
visual_bell false
```

### focus_follows_mouse
Auto-focus panes on hover. Options: `true` · `false` (default).
```kdl
focus_follows_mouse true
```

### mouse_click_through
Whether clicking to focus a pane also sends the click to the running program. When `false`, the first click only focuses and is consumed by Zellij. Options: `true` · `false` (default).
```kdl
mouse_click_through true
```
