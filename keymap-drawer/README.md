# keymap-drawer artifacts

This folder contains SVG and YAML files auto-generated from `../config/adv360.keymap` using [keymap-drawer](https://github.com/caksoylar/keymap-drawer).

## Files

- `adv360.svg` — Visual keymap rendered from the keymap definition
- `adv360.yaml` — Intermediate parsed representation

## Generation pipeline

[`.github/workflows/draw-keymaps.yml`](../.github/workflows/draw-keymaps.yml) calls the upstream reusable workflow `caksoylar/keymap-drawer/.github/workflows/draw-zmk.yml@main` on every push that touches any of:

- `config/adv360.keymap`
- `config/adv360.json`
- `config/macros.dtsi`
- `keymap_drawer.config.yaml`
- `.github/workflows/draw-keymaps.yml`

The workflow renders the SVG, then commits and pushes it back to the branch automatically.

## Configuration

- [`../keymap_drawer.config.yaml`](../keymap_drawer.config.yaml) — Drawing config (label font size, halo stroke width, shrink threshold for long legends)
- [`../config/adv360.json`](../config/adv360.json) — Local physical layout override (upstream `extra_layouts/adv360.json` scaled 1.5x so long keycode names like `INTERNATIONAL` and `&td_home_pgup` fit inside key cells)

## Manual regeneration

Trigger from the Actions tab via `workflow_dispatch`, or push any change to one of the trigger paths above.

## Editing the keymap

Edit `../config/adv360.keymap`. Do not edit `adv360.svg` directly — it is overwritten on every regeneration.
