local wezterm = require("wezterm")
local act = wezterm.action

-- NOTE:
-- `wezterm.lua` 側で HUD（時刻/host/cwd/leader/key-table）を描画しているため、
-- ここで set_right_status すると競合して上書きになります。
-- “デザインを変えない” ため、ステータス描画は wezterm.lua に一本化します。

return {
  keys = {
    {
      -- workspaceの切り替え
      key = "w",
      mods = "LEADER",
      action = act.ShowLauncherArgs({ flags = "WORKSPACES", title = "Select workspace" }),
    },
    {
      --workspaceの名前変更
      key = "$",
      mods = "LEADER",
      action = act.PromptInputLine({
        description = "(wezterm) Set workspace title:",
        action = wezterm.action_callback(function(win, pane, line)
          if line then
            wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
          end
        end),
      }),
    },
    {
      key = "W",
      mods = "LEADER|SHIFT",
      action = act.PromptInputLine({
        description = "(wezterm) Create new workspace:",
        action = wezterm.action_callback(function(window, pane, line)
          if line then
            window:perform_action(
              act.SwitchToWorkspace({
                name = line,
              }),
              pane
            )
          end
        end),
      }),
    },
    -- コマンドパレット表示
    { key = "p", mods = "SUPER", action = act.ActivateCommandPalette },
    -- Tab移動
    { key = "Tab", mods = "CTRL", action = act.ActivateTabRelative(1) },
    { key = "Tab", mods = "SHIFT|CTRL", action = act.ActivateTabRelative(-1) },
    -- Tab入れ替え
    { key = "{", mods = "LEADER", action = act({ MoveTabRelative = -1 }) },
    -- Tab新規作成
    { key = "t", mods = "SUPER", action = act({ SpawnTab = "CurrentPaneDomain" }) },
    -- Tabを閉じる
    { key = "w", mods = "SUPER", action = act({ CloseCurrentTab = { confirm = true } }) },
    { key = "}", mods = "LEADER", action = act({ MoveTabRelative = 1 }) },

    -- 画面フルスクリーン切り替え
    { key = "Enter", mods = "ALT", action = act.ToggleFullScreen },

    -- コピーモード
    -- { key = 'X', mods = 'LEADER', action = act.ActivateKeyTable{ name = 'copy_mode', one_shot =false }, },
    { key = "[", mods = "LEADER", action = act.ActivateCopyMode },
    -- 検索（スクロールバック）
    { key = "f", mods = "LEADER", action = act.Search({ CaseInSensitiveString = "" }) },
    -- URL/パス等を一発選択（あとで Enter でコピーできる）
    { key = "u", mods = "LEADER", action = act.QuickSelect },
    -- コピー
    { key = "c", mods = "SUPER", action = act.CopyTo("Clipboard") },
    -- 貼り付け
    { key = "v", mods = "SUPER", action = act.PasteFrom("Clipboard") },

    -- Pane作成 leader + r or d
    { key = "d", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "r", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    -- Paneを閉じる leader + x
    { key = "x", mods = "LEADER", action = act({ CloseCurrentPane = { confirm = true } }) },
    -- Pane移動 leader + hlkj
    { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
    { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
    { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
    { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
    -- Pane選択
    { key = "[", mods = "CTRL|SHIFT", action = act.PaneSelect },
    -- 選択中のPaneのみ表示
    { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },

    -- フォントサイズ切替
    { key = "+", mods = "CTRL", action = act.IncreaseFontSize },
    { key = "-", mods = "CTRL", action = act.DecreaseFontSize },
    -- フォントサイズのリセット
    { key = "0", mods = "CTRL", action = act.ResetFontSize },

    -- タブ切替 Cmd + 数字
    { key = "1", mods = "SUPER", action = act.ActivateTab(0) },
    { key = "2", mods = "SUPER", action = act.ActivateTab(1) },
    { key = "3", mods = "SUPER", action = act.ActivateTab(2) },
    { key = "4", mods = "SUPER", action = act.ActivateTab(3) },
    { key = "5", mods = "SUPER", action = act.ActivateTab(4) },
    { key = "6", mods = "SUPER", action = act.ActivateTab(5) },
    { key = "7", mods = "SUPER", action = act.ActivateTab(6) },
    { key = "8", mods = "SUPER", action = act.ActivateTab(7) },
    { key = "9", mods = "SUPER", action = act.ActivateTab(-1) },

    -- コマンドパレット
    { key = "p", mods = "SHIFT|CTRL", action = act.ActivateCommandPalette },
    -- 設定再読み込み
    { key = "r", mods = "SHIFT|CTRL", action = act.ReloadConfiguration },
    -- キーテーブル用
    { key = "s", mods = "LEADER", action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },
    {
      key = "a",
      mods = "LEADER",
      action = act.ActivateKeyTable({ name = "activate_pane", timeout_milliseconds = 1000 }),
    },
  },
  -- キーテーブル
  -- https://wezfurlong.org/wezterm/config/key-tables.html
  key_tables = {
    -- Paneサイズ調整 leader + s
    resize_pane = {
      { key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
      { key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
      { key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
      { key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },

      -- Cancel the mode by pressing escape
      { key = "Enter", action = "PopKeyTable" },
    },
    activate_pane = {
      { key = "h", action = act.ActivatePaneDirection("Left") },
      { key = "l", action = act.ActivatePaneDirection("Right") },
      { key = "k", action = act.ActivatePaneDirection("Up") },
      { key = "j", action = act.ActivatePaneDirection("Down") },
    },
    -- copyモード leader + [
    copy_mode = {
      -- 移動
      { key = "h", mods = "NONE", action = act.CopyMode("MoveLeft") },
      { key = "j", mods = "NONE", action = act.CopyMode("MoveDown") },
      { key = "k", mods = "NONE", action = act.CopyMode("MoveUp") },
      { key = "l", mods = "NONE", action = act.CopyMode("MoveRight") },
      -- 最初と最後に移動
      { key = "^", mods = "NONE", action = act.CopyMode("MoveToStartOfLineContent") },
      { key = "$", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
      -- 左端に移動
      { key = "0", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
      { key = "o", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEnd") },
      { key = "O", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
      --
      { key = ";", mods = "NONE", action = act.CopyMode("JumpAgain") },
      -- 単語ごと移動
      { key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
      { key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
      { key = "e", mods = "NONE", action = act.CopyMode("MoveForwardWordEnd") },
      -- ジャンプ機能 t f
      { key = "t", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = true } }) },
      { key = "f", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = false } }) },
      { key = "T", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
      { key = "F", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
      -- 一番下へ
      { key = "G", mods = "NONE", action = act.CopyMode("MoveToScrollbackBottom") },
      -- 一番上へ
      { key = "g", mods = "NONE", action = act.CopyMode("MoveToScrollbackTop") },
      -- viweport
      { key = "H", mods = "NONE", action = act.CopyMode("MoveToViewportTop") },
      { key = "L", mods = "NONE", action = act.CopyMode("MoveToViewportBottom") },
      { key = "M", mods = "NONE", action = act.CopyMode("MoveToViewportMiddle") },
      -- スクロール
      { key = "b", mods = "CTRL", action = act.CopyMode("PageUp") },
      { key = "f", mods = "CTRL", action = act.CopyMode("PageDown") },
      { key = "d", mods = "CTRL", action = act.CopyMode({ MoveByPage = 0.5 }) },
      { key = "u", mods = "CTRL", action = act.CopyMode({ MoveByPage = -0.5 }) },
      -- 範囲選択モード
      { key = "v", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
      { key = "v", mods = "CTRL", action = act.CopyMode({ SetSelectionMode = "Block" }) },
      { key = "V", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Line" }) },
      -- コピー
      { key = "y", mods = "NONE", action = act.CopyTo("Clipboard") },

      -- コピーモードを終了
      {
        key = "Enter",
        mods = "NONE",
        action = act.Multiple({ { CopyTo = "ClipboardAndPrimarySelection" }, { CopyMode = "Close" } }),
      },
      { key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
      { key = "c", mods = "CTRL", action = act.CopyMode("Close") },
      { key = "q", mods = "NONE", action = act.CopyMode("Close") },
    },
  },
}


----------------------------------------------------------------------
-- Key Bindings Cheat Sheet (macOS)
--
-- 修飾キー対応：
--   SUPER = ⌘ Command
--   CTRL  = ⌃ Control
--   ALT   = ⌥ Option
--   SHIFT = ⇧ Shift
--
-- LEADER KEY:
--   ⌃Q  (Control + Q)
----------------------------------------------------------------------

----------------------------------------------------------------------
-- Workspace (Session)
----------------------------------------------------------------------
-- ⌃Q → W        : ワークスペース一覧表示
-- ⌃Q → $        : ワークスペース名変更
-- ⌃Q → ⇧W       : 新規ワークスペース作成

----------------------------------------------------------------------
-- Command Palette
----------------------------------------------------------------------
-- ⌘P            : コマンドパレット
-- ⌃⇧P           : コマンドパレット（代替）

----------------------------------------------------------------------
-- Tabs
----------------------------------------------------------------------
-- ⌘T            : 新規タブ作成
-- ⌘W            : タブを閉じる（確認あり）
--
-- ⌃Tab          : 次のタブ
-- ⌃⇧Tab         : 前のタブ
--
-- ⌃Q → {        : タブを左へ移動
-- ⌃Q → }        : タブを右へ移動
--
-- ⌘1〜⌘8        : タブ1〜8を直接選択
-- ⌘9            : 最後のタブを選択

----------------------------------------------------------------------
-- Window
----------------------------------------------------------------------
-- ⌥Enter        : フルスクリーン切替

----------------------------------------------------------------------
-- Copy / Paste
----------------------------------------------------------------------
-- ⌘C            : コピー
-- ⌘V            : ペースト
-- ⌃Q → [        : コピーモード開始
--
-- NOTE:
--   Ctrl+C は SIGINT（プロセス中断）
--   Cmd+C は コピー専用

----------------------------------------------------------------------
-- Panes (Split / Move)
----------------------------------------------------------------------
-- ⌃Q → D        : 縦分割（左右）
-- ⌃Q → R        : 横分割（上下）
-- ⌃Q → X        : ペインを閉じる
--
-- ⌃Q → H        : 左のペインへ移動
-- ⌃Q → J        : 下のペインへ移動
-- ⌃Q → K        : 上のペインへ移動
-- ⌃Q → L        : 右のペインへ移動
--
-- ⌃⇧[           : ペイン選択UI
-- ⌃Q → Z        : ペインズーム（最大化 / 戻す）

----------------------------------------------------------------------
-- Pane Resize Mode
----------------------------------------------------------------------
-- ⌃Q → S        : ペインサイズ調整モード
--
-- (Resize mode 中)
--   H            : 左へ
--   L            : 右へ
--   K            : 上へ
--   J            : 下へ
--   Enter        : サイズ調整モード終了

----------------------------------------------------------------------
-- Pane Activate Mode (Temporary)
----------------------------------------------------------------------
-- ⌃Q → A        : ペイン移動モード（1秒）
--
-- (Mode 中)
--   H / J / K / L : ペイン移動

----------------------------------------------------------------------
-- Copy Mode (vi-like)
----------------------------------------------------------------------
-- 移動:
--   H / J / K / L : カーソル移動
--   0             : 行頭
--   ^             : 行頭（内容）
--   $             : 行末
--
-- 単語移動:
--   W / B / E
--
-- ジャンプ:
--   F / T         : 前方ジャンプ
--   ⇧F / ⇧T       : 後方ジャンプ
--   ;             : 再ジャンプ
--
-- スクロール:
--   ⌃B            : 1ページ上
--   ⌃F            : 1ページ下
--   ⌃U            : 半ページ上
--   ⌃D            : 半ページ下
--
-- 選択:
--   V             : セル選択
--   ⌃V            : ブロック選択
--   ⇧V            : 行選択
--
-- コピー:
--   Y             : コピー
--
-- 終了:
--   Enter         : コピーして終了
--   Esc / Q / ⌃C  : 終了

----------------------------------------------------------------------
-- Font Size
----------------------------------------------------------------------
-- ⌃+            : フォントサイズ拡大
-- ⌃-            : フォントサイズ縮小
-- ⌃0            : フォントサイズリセット

----------------------------------------------------------------------
-- Config
----------------------------------------------------------------------
-- ⌃⇧R           : 設定再読み込み
----------------------------------------------------------------------


