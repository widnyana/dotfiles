# Hyprland config

Linux-only. `bin/install-dotfiles.sh` links `config/hypr` → `~/.config/hypr`
**only on Linux** (it would be a dead symlink on macOS).

Based on JaKooLit's Hyprland-Dots. `hyprland.conf` is the entrypoint; it sources
`Keybinds.conf`, `UserConfigs/*.conf`, `monitors.conf`, `workspaces.conf`.

## hyprlock: 2K vs 1080p

`hyprlock` reads `~/.config/hypr/hyprlock.conf`. There is **no auto-switch** by
resolution — `hyprlock.conf` is tuned for a 2K display, `hyprlock-1080p.conf`
for 1080p (smaller font sizes / positions). To use the 1080p variant on a given
machine, copy it over the default:

```sh
cp ~/.config/hypr/hyprlock-1080p.conf ~/.config/hypr/hyprlock.conf
```

(That edits the repo file via the dir symlink; `git checkout config/hypr/hyprlock.conf`
to restore.)
