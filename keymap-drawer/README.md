# keymap-drawer artifacts

This folder contains SVG and YAML files auto-generated from `../config/adv360.keymap` using [keymap-drawer](https://github.com/caksoylar/keymap-drawer).

## Files

- `adv360-light.svg` — Visual keymap for light theme (dark text on white cells)
- `adv360-dark.svg` — Visual keymap for dark theme (white text on white cells)
- `adv360.yaml` — Intermediate parsed representation, shared between the two variants
- `keymap_drawer.config.yaml` — Drawing config for the light variant
- `keymap_drawer.config.dark.yaml` — Drawing config for the dark variant (same as light, but with white label fill)

## Generation pipeline

[`.github/workflows/draw-keymaps.yml`](../.github/workflows/draw-keymaps.yml) installs keymap-drawer via pip, parses the keymap once, draws two SVG variants (light/dark), and commits them. It runs on every push that touches any of:

- `config/adv360.keymap`
- `config/adv360.json`
- `config/macros.dtsi`
- `keymap-drawer/keymap_drawer.config.yaml`
- `keymap-drawer/keymap_drawer.config.dark.yaml`
- `.github/workflows/draw-keymaps.yml`

## Configuration

- [`keymap_drawer.config.yaml`](keymap_drawer.config.yaml) — Drawing config for the light variant
- [`keymap_drawer.config.dark.yaml`](keymap_drawer.config.dark.yaml) — Drawing config for the dark variant (white label fill)
- [`../config/adv360.json`](../config/adv360.json) — Local physical layout override (upstream `extra_layouts/adv360.json` scaled 1.5x so long keycode names like `INTERNATIONAL` and `&td_home_pgup` fit inside key cells)

## Manual regeneration

Trigger from the Actions tab via `workflow_dispatch`, or push any change to one of the trigger paths above.

## Editing the keymap

Edit `../config/adv360.keymap`. Do not edit `adv360-light.svg` or `adv360-dark.svg` directly — they are overwritten on every regeneration.

## License & Attribution

This rendering pipeline depends on [keymap-drawer](https://github.com/caksoylar/keymap-drawer) by Cem Aksoylar, distributed under the MIT License. The full license text is included in [`LICENSE-keymap-drawer.txt`](LICENSE-keymap-drawer.txt).

[`../config/adv360.json`](../config/adv360.json) is derived from keymap-drawer's [`resources/extra_layouts/adv360.json`](https://github.com/caksoylar/keymap-drawer/blob/main/resources/extra_layouts/adv360.json). All numeric layout properties (`x`, `y`, `w`, `h`, `rx`, `ry`) are scaled by 1.5x so long keycode legends fit inside cells. The original MIT License terms continue to apply to this derivative.
