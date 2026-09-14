# Media player for Omarchy

An Omarchy 4 shell plugin that adds an MPRIS media control widget to the
Quickshell bar. It supports play/pause, previous/next track, album art,
source selection, desktop notifications, and a Cava visualizer in the popup.

## Requirements

- Omarchy 4
- A Quickshell session with MPRIS support
- `cava` for the visualizer

Install Cava if it is not already available:

```bash
omarchy pkg add cava
```

## Install

Install directly from GitHub:

```bash
omarchy plugin add https://github.com/ciprianotoor/omarchy-media-plugin.git \
  --enable
```

The plugin manager can also install the repository by its Git URL. To place
the widget in a specific bar section, enable it with the Omarchy plugin
manager after installation.

If the built-in `omarchy.media` widget is enabled, disable it first to avoid
having two media widgets:

```bash
omarchy plugin disable omarchy.media
```

## Controls

- Left click: play or pause.
- Middle click: next track.
- Right click: open or close the media panel.
- Mouse wheel: previous or next track.
- Panel buttons: previous, play/pause, and next.

The service exposes the following shell IPC actions:
`status`, `playPause`, `play`, `pause`, `next`, `previous`, `sourceNext`,
`sourcePrevious`, `sourceSwitch`, `sourceSwitchPrevious`, and `ping`.

## Validate locally

From the repository root:

```bash
omarchy plugin validate .
```

## License

MIT. See [LICENSE](LICENSE).
