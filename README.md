# winv — Win+V clipboard history for Linux

Press **Super+V** (the Windows key + V) and get the Windows clipboard history
panel: the last 25 things you copied, text and images, newest first. Click one
(or pick it with the arrow keys and Enter) and it is pasted into the window you
were working in.

## Install

Debian / Ubuntu / Mint / Pop!_OS:

    sudo apt install ./winv_1.0.0_all.deb

Any other distro (Fedora, Arch, openSUSE, ...):

    sudo ./install.sh

Then log out and back in (winv starts with your session), or start it right
away with `winv &`. To build the `.deb` yourself run `./build-deb.sh` on a
Debian-based system.

## Using it

| Action | How |
| --- | --- |
| Open / close the panel | Super+V, Esc, or click elsewhere |
| Paste an entry | click it, or Up/Down then Enter |
| Pin an entry (kept across restarts and "Clear all") | pin button on the entry |
| Delete an entry | "…" on the entry, then the trash button; or the Delete key |
| Remove everything that is not pinned | "…" on any entry, then "Clear all" |

Like on Windows: 25 entries, 4 MB per text entry, copying something twice
moves it to the top instead of duplicating it, copied files are not recorded,
and the history is forgotten when you log out except for pinned entries.
Entries marked as secret by password managers are not recorded.

## The Super+V shortcut

- **GNOME, Ubuntu, Budgie, Pop!_OS**: set up automatically the first time winv
  starts. GNOME uses Super+V for the notification list by default; winv takes
  it over and the notification list stays on Super+M. `winv --remove-hotkey`
  undoes this.
- **Xfce, Cinnamon, MATE, LXQt, i3, Openbox and other X11 desktops**: winv
  grabs Super+V by itself, nothing to configure.
- **KDE Plasma**: Meta+V already opens Plasma's own clipboard history. To use
  winv instead, remove that shortcut in System Settings > Shortcuts and add a
  custom one that runs `winv --toggle`.
- **Sway / Hyprland / other Wayland compositors**: bind the command yourself,
  for example `bindsym Mod4+v exec winv --toggle`.

## Differences from Windows

- The panel opens at the mouse pointer (centre of the screen on Wayland), not
  at the text cursor.
- No emoji / GIF / symbols tabs and no sync between devices.
- **Wayland auto-paste**: Wayland does not let programs send keystrokes
  freely. winv uses `wtype` (Sway, Hyprland, KDE) or `ydotool` (GNOME; needs
  the `ydotoold` service running) when installed. Without them the chosen
  entry is still put on the clipboard and you press Ctrl+V yourself. On X11
  sessions pasting is automatic, including Ctrl+Shift+V for terminals.

## Settings

Optional file `~/.config/winv/config.json`:

    {
      "max_items": 25,
      "persist_history": false,
      "auto_paste": true,
      "theme": "auto"
    }

`theme` is `auto` (follow the desktop), `dark` or `light`.
`persist_history: true` keeps the whole history across restarts, not only the
pinned entries. Restart winv (`winv --quit; winv &`) after changing it.

## Commands

    winv                  start the background service
    winv --toggle         show / hide the panel
    winv --clear          remove everything that is not pinned
    winv --quit           stop the service
    winv --setup-hotkey   bind Super+V on GNOME-based desktops
    winv --remove-hotkey  undo that

Pinned entries are stored in `~/.local/share/winv/`, readable only by you.
