# config フォルダ内ファイルの説明

このフォルダには、現役のファイルと、上流追従のために残している旧ファイルが混在している。

## 現役で使うファイル

ファームウェアビルドと keymap-drawer の SVG 生成で読まれる。

- `adv360.keymap` — メインのキーマップ（左右共通の論理定義）
- `adv360_left.keymap` / `adv360_right.keymap` — 左右別ビルドが読む派生
- `macros.dtsi` — マクロ定義
- `version.dtsi` — バージョン情報
- `west.yml` — west の依存定義
- `boards/arm/adv360/` — Adv360 のボード定義一式
- `adv360.json` — keymap-drawer 用の物理レイアウト（上流の `extra_layouts/adv360.json` を 1.5x スケールしたもの）

## 旧 Adv360-Pro-GUI 用に残しているだけのファイル

以下は廃止済みの Adv360-Pro-GUI（旧 Web キーマップエディタ）が読んでいた設定。

- `info.json` — 物理レイアウト定義（独自拡張の QMK 形式、`mod1`〜`mod8` ラベル等）
- `keymap.json` — キーマップ
- `cust_behaviors.json` — カスタム behavior 定義
- `cust_keycodes.json` — カスタム keycode 定義

### 現在の使用状況

これらは現在のビルド経路でも、keymap-drawer の SVG 生成でも読まれていない。

- Adv360-Pro-GUI は 2025 年に廃止された
- 後継は Clique（ZMK Studio ベース、ランタイム書き換え型）
- この fork では Clique を使わず、`adv360.keymap` の直接編集 + GitHub Actions ビルドで運用

### なぜ削除しないか

Kinesis 上流（[`KinesisCorporation/Adv360-Pro-ZMK`](https://github.com/KinesisCorporation/Adv360-Pro-ZMK)）に依然として残っているため。

ここで先回りして削除すると、上流からの merge 時にコンフリクトの種になる。実害もないので、上流に追従して残す。

将来 Kinesis 公式が削除したら、こちらも追随して消す。
