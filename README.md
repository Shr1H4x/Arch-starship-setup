# Arch Starship Setup

A compact, boxed two-line Starship prompt for Arch Linux with the Omarchy
shell. Every section is its own bracketed chip and colors reflect the live
system state (power profile, battery level, network link).

```
╭─[ shr1h4x ] [ …/Universal_Downloader ] [ main ] ⇡3 [  v26.7.0 ] [  v3.14.7 ] [ 80% ] [ 󰌪 ] [ 󰈀 ] [ 17:42 ] ➤
╰─❯
```

![Screenshot](/starship.png)

## Features

| Chip | What it shows | Color logic |
|------|---------------|-------------|
| `[ shr1h4x ]` | Current username (always) | blue, red for root |
| `[ …/path ]` | Truncated current directory | cyan |
| `[ main ]` | Git branch | purple italic |
| `⇡3` `?` `✱` | Git ahead/untracked/modified status (only when non-empty) | red |
| `[  v26.7.0 ]` | Node version (js/ts projects) + icon | green |
| `[  v3.14.7 ]` | Python version (py projects) + icon | yellow |
| `[ 80% ]` | Battery percentage | red <20%, yellow 20–50%, green ≥50% |
| `[ 󰌪 ]` | Power profile icon (live) | green power-saver / blue balanced / red performance |
| `[ 󰈀 ]` | Network type (wifi / ethernet / offline) | blue |
| `[ 17:42 ]` | Current time HH:MM | magenta |

## Power profile icons

Single glyphs matching the Omarchy power panel and the `SUPER+B` OSD:

| Profile | Icon | Color |
|---------|------|-------|
| power-saver | `󰌪` | green |
| balanced | `󰊚` | blue |
| performance | `󰓅` | red |

## Network icons

Matching the Omarchy network panel:

| State | Icon |
|-------|------|
| ethernet | `󰈀` |
| wifi (signal strength 0–100) | `󰤯` → `󰤨` (5 levels) |
| offline | `󰤮` |

## Prerequisites

- [Starship](https://starship.rs/) (tested with 1.26+)
- A Nerd Font in the terminal (for the `󰤯`, `󰓅`, `` etc. glyphs)
- `powerprofilesctl` (power-profiles-daemon) — for the power chip
- `nmcli` (NetworkManager) — for the network chip

## Install

```bash
# 1. Copy the whole starship/ folder (config + helper script) into place
mkdir -p ~/.config/starship
cp starship/starship.toml ~/.config/starship.toml
cp starship/nettype.sh ~/.config/starship/nettype.sh
chmod +x ~/.config/starship/nettype.sh

# 2. Ensure starship is initialized in your shell
# bash:  eval "$(starship init bash)"
# zsh:   eval "$(starship init zsh)"
# fish:  starship init fish | source
```

## How it works

- **Boxed layout**: top-level `format` draws `╭─ … ➤` / `╰─❯` (rounded
  corners, right edge arrow in bold white) with the input symbol on its own
  line.
- **Chips**: each module renders `[ content ]` using
  `'[\[](dimmed) <content> [\]](dimmed) '` — single-quoted TOML because
  `\[`/`\]` aren't valid escapes in double-quoted strings.
- **Live power color**: `custom.power` runs `powerprofilesctl get` and prints
  the icon wrapped in ANSI bold color codes; `unsafe_no_escape = true` lets
  starship pass the escapes through.
- **Ethernet/wifi detection**: the helper script `starship/nettype.sh`
  (referenced by the `custom.net` chip) reads `nmcli -t device status`
  (`DEVICE:TYPE:STATE:CONN` → type is field 2) and picks the wifi strength
  icon with `floor(signal / 20)`.

## Gotchas (learned the hard way)

- Custom module names with a dot MUST be referenced as `${custom.power}` in
  the top-level format — plain `$custom.power` prints a literal `.power`
  suffix after all custom modules.
- `[custom.power] shell` must be a plain string (`"bash"`), not a list —
  the list form silently skips the command on starship 1.26.
- `git_status` has no brackets on purpose: any static text (brackets or
  spaces) in its format makes it render even when the repo is clean. A pure
  variable format `'[$all_status$ahead_behind]($style)'` hides it entirely;
  its trailing spaces live inside each status symbol (`"? "`, `"✱ "`).

## License

ISC — do whatever, it's a prompt.
