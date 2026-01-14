# WezTerm 設定（`~/.config/wezterm`）

このディレクトリは WezTerm の設定一式です。

- **メイン設定**: `wezterm.lua`
- **キーバインド**: `keybinds.lua`
- **起動時ロゴ**: `assets/zeus.txt`, `assets/wezterm_logo.txt`

## 特徴

- **描画**: `front_end = "WebGpu"`（スクロール等の体感改善）
- **見た目**: 透過 + blur、背景レイヤ（HUD/グリッド/ノイズ/スキャンライン等）
- **HUD**: 右上/左上に時刻・HOST・CWD・workspace・key-table・leader状態を表示
- **起動演出**: 起動時にロゴを中央表示し `Press Enter to start...` → Enter で通常シェルへ
- **キー設計**: デフォルトキーを無効化し、`keybinds.lua` に集中管理

## キー操作（抜粋）

Leader は **`Ctrl+Q`** です（`timeout_milliseconds = 2000`）。

- **設定再読み込み**: `Ctrl+Shift+R`
- **コマンドパレット**: `Cmd+P`（代替 `Ctrl+Shift+P`）
- **フルスクリーン切替**: `Option+Enter`
- **分割**:
  - `Ctrl+Q` → `d`: 縦分割
  - `Ctrl+Q` → `r`: 横分割
- **ペイン移動**: `Ctrl+Q` → `h/j/k/l`
- **コピーモード**: `Ctrl+Q` → `[`（検索は `Ctrl+Q` → `f`）

詳細は `keybinds.lua` 末尾のチートシートコメントを参照してください。

## 起動時ロゴについて

`wezterm.lua` の `gui-startup` で `/bin/sh -lc` のスクリプトを実行して、ロゴを描画しています。

- ロゴの **表示幅（全角/合成文字）** を Python で計算し、行ごとにセンタリングしています
- 端末サイズは `get_size()` で取得します（ロゴが収まるサイズで安定するまで短時間待つ）

### 依存コマンド

- **必須に近い**: `stty`, `tput`
- **あると高精度**: `python3`（表示幅計算・行ごとのセンタリング）
- **python3 が無い場合の保険**: `perl`

> NOTE: 端末サイズ取得は **`stty size </dev/tty` を優先**します。  
> `$(...)`（コマンド置換）内でサイズを取る都合、stdin/stdout が TTY でないケースを避けるためです。

### よくある不具合

- **ロゴが左寄せになる**: 端末の列数がロゴ幅（`logo_max` / `box_width`）より小さいと `hpad=0` になり左寄せになります。ウィンドウを広げるか、ロゴ自体の幅を小さくしてください。
- **ロゴ表示が遅い**: 端末サイズが安定しないと待ちループが回ります。多くは起動直後のフルスクリーン化やリサイズが原因です。

## `OSError: [Errno 25] Inappropriate ioctl for device` について

これは「TTY ではない fd に対して ioctl（端末サイズ取得など）を実行した」時に出ます。  
この設定では、起動スクリプトが端末サイズを取る経路があるため、**stdin/stdout が TTY でない状況**に強い実装（`/dev/tty` 優先）にしています。

## WezTermで Markdown を “レンダリング表示” したい

WezTerm 自体は Markdown を HTML のようにレンダリングする機能を持ちません。  
その代わり、**表示に使うコマンド**を Markdown 対応にします。

## WezTermで「左で編集 / 右でリアルタイムプレビュー」したい

このディレクトリに `md-preview.sh` を用意しています。WezTerm 内で実行すると、

- **右ペイン**: Markdown をレンダリング表示（watchがあれば自動更新）
- **左ペイン**: エディタ（`$EDITOR`、未設定なら `nvim`）

を立ち上げます。

準備（macOS）:

```bash
brew install glow
brew install watchexec # (または entr)
chmod +x ~/.config/wezterm/md-preview.sh
```

使い方:

```bash
~/.config/wezterm/md-preview.sh path/to/file.md
```

### おすすめ: `glow`

インストール（macOS）:

```bash
brew install glow
```

表示:

```bash
glow -p README.md
```

### 代替: `bat`

```bash
brew install bat
bat -l md README.md
```


