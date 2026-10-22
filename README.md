# Media player for Omarchy

See [CHANGELOG.md](CHANGELOG.md) for the reason behind the restoration of the
original interface.

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

## Marketplace status / Estado del marketplace

### Español

El plugin fue enviado al marketplace de Omarchy y está pendiente de revisión.
Mientras espera la aprobación, puede instalarse directamente desde GitHub:

```bash
omarchy plugin add https://github.com/ciprianotoor/omarchy-media-plugin.git --enable
```

Para actualizarlo o eliminarlo:

```bash
omarchy plugin update io.github.ciprianotoor.omarchy-media
omarchy plugin remove io.github.ciprianotoor.omarchy-media
```

### English

This plugin has been submitted to the Omarchy marketplace and is awaiting
review. While approval is pending, install it directly from GitHub:

```bash
omarchy plugin add https://github.com/ciprianotoor/omarchy-media-plugin.git --enable
```

Update or remove it with:

```bash
omarchy plugin update io.github.ciprianotoor.omarchy-media
omarchy plugin remove io.github.ciprianotoor.omarchy-media
```

### Português

Este plugin foi enviado ao marketplace do Omarchy e está aguardando revisão.
Enquanto a aprovação estiver pendente, instale-o diretamente pelo GitHub:

```bash
omarchy plugin add https://github.com/ciprianotoor/omarchy-media-plugin.git --enable
```

Para atualizar ou remover:

```bash
omarchy plugin update io.github.ciprianotoor.omarchy-media
omarchy plugin remove io.github.ciprianotoor.omarchy-media
```

### Français

Ce plugin a été soumis au marketplace d’Omarchy et est en attente de
validation. En attendant, installez-le directement depuis GitHub :

```bash
omarchy plugin add https://github.com/ciprianotoor/omarchy-media-plugin.git --enable
```

Pour le mettre à jour ou le supprimer :

```bash
omarchy plugin update io.github.ciprianotoor.omarchy-media
omarchy plugin remove io.github.ciprianotoor.omarchy-media
```

To remove this plugin completely:

```bash
omarchy plugin remove io.github.ciprianotoor.omarchy-media
```

## Controls

- Left click: play or pause.
- Middle click: next track.
- Right click: open or close the media panel.
- Mouse wheel: previous or next track.
- Panel buttons: previous, play/pause, and next.
- Cava visualizer: use the `CAVA VISUALIZER` control in the panel to enable or
  disable the visualizer without disabling media controls.

The service exposes the following shell IPC actions:
`status`, `playPause`, `play`, `pause`, `next`, `previous`, `sourceNext`,
`sourcePrevious`, `sourceSwitch`, `sourceSwitchPrevious`, and `ping`.

## Bluetooth Media companion

This repository also includes `bluetooth-media/`, a separate bar widget for
controlling a connected Bluetooth phone or player through BlueZ AVRCP. It is
intentionally separate from `cipriano.media`: the blue headphones icon is for
media control, while Omarchy's Bluetooth icon remains responsible for pairing
and connection management.

The companion widget is always visible. Open it with left click. It reports
the connected device and shows one of these states:

- `Comprobando compatibilidad multimedia…`
- `Control multimedia disponible`
- `Dispositivo no compatible con control multimedia`

The playback buttons are enabled only when BlueZ exposes an AVRCP
`org.bluez.MediaPlayer1` object. A device can stream audio through A2DP while
not exposing AVRCP; in that case the red compatibility message is expected.

### Install the companion widget

Copy the `bluetooth-media` directory into the local Omarchy plugin directory:

```bash
mkdir -p ~/.config/omarchy/plugins
cp -r bluetooth-media ~/.config/omarchy/plugins/cipriano.bluetooth-media
```

Add it to the right side of `~/.config/omarchy/shell.json`, after
`omarchy.bluetooth`:

```json
{ "id": "cipriano.bluetooth-media" }
```

Then reload the shell:

```bash
omarchy restart shell
```

Left click opens the media controls. Right click, or the yellow
`Administrar conexión` button, opens Omarchy's Bluetooth connection panel.

## Validate locally

From the repository root:

```bash
omarchy plugin validate .
```

## Update script

If you cloned this repository locally, you can check for updates and apply
them only after confirmation:

```bash
./update.sh
```

The script verifies the repository and remote, refuses to overwrite local
changes, shows the pending commits, performs a fast-forward-only update, and
validates the plugin afterward. To approve an update non-interactively:

```bash
./update.sh --yes
```

For a plugin installed through Omarchy, use the plugin manager instead:

```bash
omarchy plugin update io.github.ciprianotoor.omarchy-media
```

## License

MIT. See [LICENSE](LICENSE).
