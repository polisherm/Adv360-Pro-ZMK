# Adv360-Pro-ZMK — エージェント向けの道しるべ

Kinesis Advantage 360 Pro 用の ZMK 設定リポジトリの、個人 fork。
上流は [KinesisCorporation/Adv360-Pro-ZMK](https://github.com/KinesisCorporation/Adv360-Pro-ZMK)。

## ブランチ

- メインブランチは `MyDvorakKeymap_BasedV3.0-Japanese`。実際に使っているキーマップはここにある。
- メインブランチへは PR を挟まず直接コミットする。
- `upstream/V3.0` と `upstream/V3.0-Japanese` は Kinesis 上流のブランチ。
- 上流のブランチのキーマップは Kinesis の初期状態で、Dvorak 配列も独自の behavior（`SandS`、`hm_l`、`hm_r` など）も入っていない。
- 上流のブランチから切ったブランチ（例: `upgrade-github-actions-node24-japanese`）も、同じ古いキーマップを持つ。

### キーマップを読む・編集する前に

- 現在のブランチがメインブランチの系統かを `git log --oneline --graph --all` で確かめる。
- メインブランチの系統でなければ、そのブランチのキーマップを実物として扱わない。
- 内容は `git show MyDvorakKeymap_BasedV3.0-Japanese:config/adv360.keymap` で読む。
- 編集は、メインブランチの上か、メインブランチから切ったブランチで行う。

## ビルド

- 通常のビルドは GitHub Actions（`.github/workflows/build.yml`）。push で走る。
- 成果物は 2 種類の uf2（`firmware-no-clique` と `firmware-clique`）で、Actions の artifact に出る。
- ローカルでビルドするなら `make`（左右両方）か `make left`（左だけ）。Docker か Podman が要る。Windows では WSL2 から実行する。
- ローカルの成果物は `firmware/` に出る。
- テストは無い。変更の確認はビルドが通るかと、実機に書き込んでの動作確認で行う。
- `config/version.dtsi` はビルド中にバージョン文字列で書き換わる。この変更はコミットしない。

## 書き込み

- ユーザーに「焼いて」と頼まれたら `bin/flash.sh` を実行する。
- メインブランチで最後に成功した Build の artifact を落とし、ブートローダーのドライブへ uf2 をコピーする。
- 書き込む半分をブートローダーに入れるのはユーザーの操作（左は Mod+macro1、右は Mod+macro3）。スクリプトはドライブが出るまで最大 60 秒待つ。
- 引数は `left`（既定）か `right`。どちらの半分がつながっているかはスクリプトから判別できないため、ユーザーの指示どおりに渡す。
- 既定の artifact は `firmware-clique`。`--variant no-clique` で切り替える。
- `--dry-run` はダウンロードとドライブの検出だけ行い、コピーしない。
- 左右の uf2 は、それぞれの半分のドライブに書き込む。右の uf2 を左のドライブに入れない。

## キーマップの構成

- 編集するのは `config/adv360.keymap`。
- `config/adv360_left.keymap` と `config/adv360_right.keymap` は、左右別ビルドのために `adv360.keymap` を `#include` しているだけ。
- マクロは `config/macros.dtsi` にある。`adv360.keymap` の `behaviors` の中で `#include` している。
- キー位置の番号は `assets/key-positions.md` にある。`hold-trigger-key-positions` や combo で使う。
- `adv360.keymap` 冒頭の `KEYS_LEFT`・`KEYS_RIGHT`・`THUMBS` は、この番号をまとめたマクロ。
- Dvorak 配列はファームウェア側で組んでいる。OS 側のキーボード設定は JIS 配列。
- そのため、記号の keycode は ZMK の名前どおりの文字を出さない。対応表は `adv360.keymap` のコメントにある。
- ZMK 本体は Kinesis のカスタム fork を使う（`config/west.yml`）。本家 ZMK にある新しい機能や keycode が、まだ入っていないことがある。

## 自動生成されるファイル

- `keymap-drawer/` の SVG と YAML は、`.github/workflows/draw-keymaps.yml` が生成する。
- 生成物は `keymap-drawer render` というコミットで、CI が自動で push する。手で編集しない。
- このため、キーマップを push した後はローカルが origin より 1 コミット遅れる。次の作業の前に `git pull --ff-only` で追いつく。
- パイプラインの詳細は `keymap-drawer/README.md` にある。

## 編集しないファイル

- `config/keymap.json`・`config/info.json`・`config/cust_behaviors.json`・`config/cust_keycodes.json` は、廃止済みの Adv360-Pro-GUI 用。ビルドでは読まれない。
- 上流に残っているので、merge 時の衝突を避けるために消さずに置いている。詳細は `config/README.md` にある。
