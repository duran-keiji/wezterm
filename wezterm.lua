local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- WezTerm config
-- (値/ロジックは変えずに、セクション分けと余白で読みやすく保つ)

config.automatically_reload_config = true

-- 描画性能（Neovimスクロールが滑らか）
config.front_end = "WebGpu"

-- ====================================================
-- Tunables
-- ====================================================
local OPACITY = 0.85
local BLUR = 18

-- ====================================================
-- Font (警告が出にくい/確実に描けるフォールバック)
-- ====================================================
config.font = wezterm.font_with_fallback({
  { family = "JetBrainsMono Nerd Font" },
  -- Nerd Font 系が入っているならここが拾われ、アイコンが綺麗に出ます
  { family = "Symbols Nerd Font Mono" },
  { family = "Noto Color Emoji" },
})
config.font_size = 12.0
config.line_height = 1.12
config.use_ime = true

-- ====================================================
-- Window / Transparency
-- ====================================================
config.window_background_opacity = OPACITY
config.text_background_opacity = OPACITY

config.macos_window_background_blur = BLUR

config.window_padding = {
  left = 12,
  right = 12,
  top = 10,
  bottom = 8,
}

config.hide_mouse_cursor_when_typing = true
config.enable_scroll_bar = false
config.adjust_window_size_when_changing_font_size = false

-- ====================================================
-- Tab / Frame
-- ====================================================
config.window_decorations = "RESIZE"
config.show_tabs_in_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false

-- "none" ではなく rgba(0,0,0,0) にして確実に透過扱いに寄せる
config.window_frame = {
  inactive_titlebar_bg = "rgba(0,0,0,0)",
  active_titlebar_bg = "rgba(0,0,0,0)",
}

-- ====================================================
-- Background layers（CRT/HUD/グリッド/ノイズ/スキャンライン/周辺減光）
-- ====================================================
config.background = {
  -- Base (少しだけ黒を残して読みやすさ確保。完全黒ベタにしない)
  {
    -- 黒を“緑黒”に寄せて、黒部分にもわずかに緑を含ませる
    source = { Color = "#000503" },
    width = "100%",
    height = "100%",
    opacity = 0.86,
  },

  -- Deep green diagonal wash
  {
    source = {
      Gradient = {
        -- もう少し暗い緑に寄せる（全体の黒みを増やしつつ緑の気配は残す）
        colors = { "#010503", "#000402", "#000a04" },
        orientation = { Linear = { angle = -45.0 } },
        interpolation = "CatmullRom",
        blend = "Oklab",
        noise = 96,
      },
    },
    width = "100%",
    height = "100%",
    opacity = 0.38,
  },

  -- HUD grid: vertical lines
  {
    source = {
      Gradient = {
        colors = {
          "rgba(0,200,80,0.00)",
          "rgba(0,200,80,0.10)",
          "rgba(0,200,80,0.00)",
        },
        orientation = "Horizontal",
        segment_size = 140,
        segment_smoothness = 0.0,
        noise = 0,
        blend = "Rgb",
        interpolation = "Linear",
      },
    },
    width = "100%",
    height = "100%",
    opacity = 0.14,
  },

  -- HUD grid: horizontal lines
  {
    source = {
      Gradient = {
        colors = {
          "rgba(0,200,80,0.00)",
          "rgba(0,200,80,0.08)",
          "rgba(0,200,80,0.00)",
        },
        orientation = "Vertical",
        segment_size = 64,
        segment_smoothness = 0.0,
        noise = 0,
        blend = "Rgb",
        interpolation = "Linear",
      },
    },
    width = "100%",
    height = "100%",
    opacity = 0.12,
  },

  -- Subtle noise
  {
    source = {
      Gradient = {
        colors = {
          "rgba(255,255,255,0.035)",
          "rgba(0,0,0,0.00)",
        },
        orientation = "Vertical",
        interpolation = "Linear",
        blend = "Rgb",
        noise = 220,
      },
    },
    width = "100%",
    height = "100%",
    opacity = 0.14,
  },

  -- Scanlines
  {
    source = {
      Gradient = {
        colors = {
          "rgba(0,0,0,0.00)",
          "rgba(0,0,0,0.32)",
          "rgba(0,0,0,0.00)",
        },
        orientation = "Vertical",
        segment_size = 220,
        segment_smoothness = 0.0,
        noise = 10,
        blend = "Rgb",
        interpolation = "Linear",
      },
    },
    width = "100%",
    height = "100%",
    opacity = 0.28,
  },

  -- Vignette
  {
    source = {
      Gradient = {
        colors = {
          "rgba(0,0,0,0.00)",
          "rgba(0,0,0,0.92)",
        },
        orientation = { Radial = { cx = 0.5, cy = 0.5, radius = 1.22 } },
        blend = "Rgb",
        interpolation = "Linear",
      },
    },
    width = "100%",
    height = "100%",
    opacity = 1.0,
  },

  -- Corner glow (top-left)
  {
    source = {
      Gradient = {
        colors = {
          "rgba(0,200,80,0.18)",
          "rgba(0,0,0,0.00)",
        },
        orientation = { Radial = { cx = 0.12, cy = 0.10, radius = 0.90 } },
        blend = "Rgb",
        interpolation = "Linear",
      },
    },
    width = "100%",
    height = "100%",
    opacity = 0.95,
  },

  -- Corner glow (bottom-right)
  {
    source = {
      Gradient = {
        colors = {
          "rgba(0,255,213,0.12)",
          "rgba(0,0,0,0.00)",
        },
        orientation = { Radial = { cx = 0.88, cy = 0.90, radius = 0.95 } },
        blend = "Rgb",
        interpolation = "Linear",
      },
    },
    width = "100%",
    height = "100%",
    opacity = 0.80,
  },
}

-- ====================================================
-- Colors (ネオングリーン/HUD)
-- ====================================================

config.term = "xterm-256color"

config.colors = {
  foreground = "#a8ffcf",
  background = "#000503",

  cursor_bg = "#00c850",
  cursor_fg = "#00140a",
  cursor_border = "#00c850",

  selection_bg = "rgba(11, 42, 24, 0.70)",
  selection_fg = "#d7ffe9",

  split = "#00c850",

  -- #RRGGBBAA は弾かれるケースがあるので rgba() を使うのが安全
  scrollbar_thumb = "#00c850",

  ansi = {
    "#050a07",
    "#ff3b30",
    "#00c850",
    "#d7ff00",
    "#00b3ff",
    "#b266ff",
    "#00ffd5",
    "#d0d7de",
  },
  brights = {
    "#0b1a12",
    "#ff6b60",
    "#66ff99",
    "#e6ff66",
    "#66d9ff",
    "#d199ff",
    "#66ffe6",
    "#ffffff",
  },

  tab_bar = {
    background = "rgba(0,0,0,0.35)",
    inactive_tab_edge = "rgba(0,0,0,0)",

    active_tab = {
      bg_color = "#00c850",
      fg_color = "#00140a",
      intensity = "Bold",
      underline = "None",
      italic = false,
      strikethrough = false,
    },
    inactive_tab = {
      bg_color = "rgba(6,19,12,0.85)",
      fg_color = "#7dffb8",
    },
    inactive_tab_hover = {
      bg_color = "rgba(11,42,24,0.90)",
      fg_color = "#a8ffcf",
      italic = true,
    },
    new_tab = { bg_color = "rgba(0,0,0,0.35)", fg_color = "#00c850" },
    new_tab_hover = { bg_color = "rgba(11,42,24,0.90)", fg_color = "#00c850", italic = true },
  },
}

config.inactive_pane_hsb = {
  saturation = 0.85,
  brightness = 0.65,
}

config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_rate = 650

-- ====================================================
-- Tab Title
-- ====================================================
local SOLID_LEFT_ARROW = "◀"
local SOLID_RIGHT_ARROW = "▶"

wezterm.on("format-tab-title", function(tab, tabs, panes, cfg, hover, max_width)
  local background = "rgba(6,19,12,0.85)"
  local foreground = "#7dffb8"
  local edge_background = "rgba(0,0,0,0)"

  if tab.is_active then
    background = "#00c850"
    foreground = "#00140a"
  elseif hover then
    background = "rgba(11,42,24,0.95)"
    foreground = "#a8ffcf"
  end

  local edge_foreground = background
  local idx = (tab.tab_index or 0) + 1
  local raw = string.format("%02d %s", idx, tab.active_pane.title)
  local title = "  " .. wezterm.truncate_right(raw, max_width - 1) .. "  "

  return {
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_LEFT_ARROW },

    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },

    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_RIGHT_ARROW },
  }
end)

-- ====================================================
-- HUD Status（NerdFont無しでも読める表記に）
-- ====================================================
config.status_update_interval = 1000

local function basename_uri(uri)
  if not uri then return "" end
  local s = tostring(uri)
  s = s:gsub("^file://", "")
  s = s:gsub("%%(%x%x)", function(hex) return string.char(tonumber(hex, 16)) end)
  return s:match("([^/]+)/?$") or s
end

wezterm.on("update-right-status", function(window, pane)
  local time = wezterm.strftime("%Y-%m-%d %H:%M:%S")
  local host = wezterm.hostname() or ""
  local cwd = basename_uri(pane:get_current_working_dir())

  local ws = window:active_workspace() or "default"
  local kt = window:active_key_table()
  local leader = window:leader_is_active()

  -- Left HUD
  local left = {
    { Foreground = { Color = "#66ffe6" } },
    { Text = " WS:" .. ws .. " " },
  }

  if kt then
    table.insert(left, { Foreground = { Color = "#d7ff00" } })
    table.insert(left, { Text = " KT:" .. kt .. " " })
  end

  if leader then
    table.insert(left, { Background = { Color = "#00c850" } })
    table.insert(left, { Foreground = { Color = "#00140a" } })
    table.insert(left, { Text = " LEADER " })
    table.insert(left, { Background = { Color = "rgba(0,0,0,0)" } })
  end

  window:set_left_status(wezterm.format(left))

  -- Right HUD
  window:set_right_status(wezterm.format({
    { Foreground = { Color = "#00c850" } },
    { Text = "  " .. time .. "  " },
    { Foreground = { Color = "#66ffe6" } },
    { Text = " HOST:" .. host .. "  " },
    { Foreground = { Color = "#a8ffcf" } },
    { Text = " CWD:" .. cwd .. "  " },
  }))
end)

-- --------------------------------------------------
-- 起動時イベント
-- --------------------------------------------------
wezterm.on("gui-startup", function(cmd)
  -- 起動コマンド側で描画して、Enter 後に通常のシェルへ移行する。
  local logo_zeus_path = wezterm.config_dir .. "/assets/zeus.txt"
  local logo_wez_path = wezterm.config_dir .. "/assets/wezterm_logo.txt"
  local logo_zeus_q = wezterm.shell_quote_arg(logo_zeus_path)
  local logo_wez_q = wezterm.shell_quote_arg(logo_wez_path)
  local sh = "/bin/sh"
  local script = "logo_zeus=" .. logo_zeus_q .. "\n" .. "logo_wez=" .. logo_wez_q .. "\n" .. [[
# 2つのロゴを縦に積む（間に1行空ける）
gap_lines=1

# ロゴ色（TrueColor）
# NOTE: '\033' をクォートするとエスケープとして解釈されず、文字として表示されてしまう。
# printf で実際の ESC 文字を生成する。
zeus_color=$(printf '\033[38;2;201;162;77m')  # #C9A24D
wez_color=$(printf '\033[38;2;138;122;90m')   # #8A7A5A
reset_color=$(printf '\033[0m')

# 行数/最大“表示幅” を計算（display width）
calc_dims() {
  local file=$1
  python3 - "$file" 2>/dev/null <<'PY' || perl -Mutf8 -ne 'chomp; $n++; $l=length($_); $m=$l if $l>$m; END{print "$n $m"}' "$file" 2>/dev/null
import sys, unicodedata
path = sys.argv[1]
n = 0
m = 0
with open(path, "r", encoding="utf-8", errors="replace") as f:
    for line in f:
        line = line.rstrip("\n")
        n += 1
        w = 0
        for ch in line:
            if ch == "\t":
                w += 4
                continue
            if unicodedata.combining(ch):
                continue
            e = unicodedata.east_asian_width(ch)
            w += 2 if e in ("W", "F") else 1
        if w > m:
            m = w
print(n, m)
PY
}

set -- $(calc_dims "$logo_zeus")
zeus_lines=${1:-0}
zeus_max=${2:-0}

set -- $(calc_dims "$logo_wez")
wez_lines=${1:-0}
wez_max=${2:-0}

logo_lines=$((zeus_lines + gap_lines + wez_lines))
logo_max=$zeus_max
if [ "$wez_max" -gt "$logo_max" ] 2>/dev/null; then
  logo_max=$wez_max
fi

# WezTerm ロゴの“横幅”は Zeus の横幅（chafa 160幅想定）に合わせたい。
# ここでは「箱幅」を Zeus の最大幅に寄せ、WezTerm ロゴはその箱内で左右にパディングして揃える。
box_width=$zeus_max
if [ -z "$box_width" ] || [ "$box_width" -le 0 ] 2>/dev/null; then
  box_width=$logo_max
fi
# WezTerm ロゴの方が大きい場合は潰れないように箱幅を広げる
if [ "$wez_max" -gt "$box_width" ] 2>/dev/null; then
  box_width=$wez_max
fi

# フルスクリーン化/リサイズ直後は cols/lines が変動するので、ロゴが収まるサイズで安定するまで待つ
get_size() {
  local c r
  # 最優先: /dev/tty から stty（コマンド置換 `$(...)` だと stdout が pipe になりやすいので）
  if command -v stty >/dev/null 2>&1; then
    if [ -r /dev/tty ]; then
      set -- $(stty size </dev/tty 2>/dev/null)
      r=$1; c=$2
    fi
  fi
  # 次点: stty（通常の stdin から）
  if [ -z "$c" ] || [ -z "$r" ]; then
    if command -v stty >/dev/null 2>&1; then
      set -- $(stty size 2>/dev/null)
      r=$1; c=$2
    fi
  fi
  # 最後: tput（ダメならデフォルト）
  if [ -z "$c" ] || [ -z "$r" ]; then
    c=$(tput cols 2>/dev/null || echo 80)
    r=$(tput lines 2>/dev/null || echo 24)
  fi
  printf '%sx%s\n' "${c:-80}" "${r:-24}"
}

# WezTerm 側のフルスクリーン処理が走るまで少し待つ
sleep 0.15

prev=""
stable=0
i=0
while [ "$i" -lt 80 ]; do
  cur=$(get_size)
  c=${cur%x*}; r=${cur#*x}
  # ロゴが収まるサイズでのみ安定判定する
  if [ -n "$c" ] && [ -n "$r" ] && [ "$c" -ge "$logo_max" ] 2>/dev/null && [ "$r" -ge "$logo_lines" ] 2>/dev/null; then
    if [ "$cur" = "$prev" ]; then
      stable=$((stable+1))
    else
      stable=0
      prev=$cur
    fi
    if [ "$stable" -ge 3 ]; then
      break
    fi
  else
    stable=0
    prev=$cur
  fi
  i=$((i+1))
  sleep 0.05
done

cols=${prev%x*}; cols=${cols:-80}
rows=${prev#*x}; rows=${rows:-24}

vpad=$(( (rows - logo_lines - 1) / 2 ))
hpad=$(( (cols - box_width) / 2 ))
if [ "$vpad" -lt 0 ]; then vpad=0; fi
if [ "$hpad" -lt 0 ]; then hpad=0; fi

clear
i=0
while [ "$i" -lt "$vpad" ]; do
  printf '\n'
  i=$((i+1))
done

# 行ごとに表示幅を見てセンタリングして出力（python3 が無ければ全体 hpad で妥協）
print_center_file() {
  local file=$1
  local color=${2:-}
  if command -v python3 >/dev/null 2>&1; then
    COLS="$cols" BOX_LEFT="$hpad" BOX_WIDTH="$box_width" COLOR="$color" RESET="$reset_color" python3 - "$file" <<'PY'
import os, sys, unicodedata
cols = int(os.environ.get("COLS", "80"))
box_left = int(os.environ.get("BOX_LEFT", "0"))
box_width = int(os.environ.get("BOX_WIDTH", str(cols)))
color = os.environ.get("COLOR", "")
reset = os.environ.get("RESET", "")
path = sys.argv[1]
def dispw(s: str) -> int:
    w = 0
    for ch in s:
        if ch == "\t":
            w += 4
            continue
        if unicodedata.combining(ch):
            continue
        e = unicodedata.east_asian_width(ch)
        w += 2 if e in ("W","F") else 1
    return w
with open(path, "r", encoding="utf-8", errors="replace") as f:
    for line in f:
        line = line.rstrip("\n")
        w = dispw(line)
        inner = max((box_width - w) // 2, 0)
        pad = max(box_left + inner, 0)
        sys.stdout.write((" " * pad) + color + line + reset + "\n")
PY
  else
    while IFS= read -r line; do
      printf '%*s%s%s%s\n' "$hpad" '' "$color" "$line" "$reset_color"
    done < "$file"
  fi
}

print_center_file "$logo_zeus" "$zeus_color"
i=0
while [ "$i" -lt "$gap_lines" ]; do
  printf '\n'
  i=$((i+1))
done
print_center_file "$logo_wez" "$wez_color"

printf '\n%*sPress Enter to start...\n' "$hpad" ''
read -r
# Enter後は通常起動へ（シンプルに戻す）
printf '%s' "$reset_color"
printf '\033[H'
exec "${SHELL:-zsh}" -l
]]

  local tab, pane, window = wezterm.mux.spawn_window({
    args = { sh, "-lc", script },
  })

  -- 起動時にフルスクリーンへ（デザインは変えず、ウィンドウ状態だけ変更）
  -- 環境/バージョン差分があるので複数手段で試す
  wezterm.on("window-config-reloaded", function(_) end) -- no-op: event loop を確実に回す
  wezterm.time.call_after(0.1, function()
    local gui = window:gui_window()
    if gui and gui.toggle_fullscreen then
      pcall(function()
        gui:toggle_fullscreen()
      end)
      return
    end
    pcall(function()
      window:perform_action(act.ToggleFullScreen, pane)
    end)
  end)
end)

-- --------------------------------------------------
-- keybinds（機能追加は keybinds.lua 側へ。ここは読み込みだけ）
-- --------------------------------------------------
config.disable_default_key_bindings = true
config.keys = require("keybinds").keys
config.key_tables = require("keybinds").key_tables
config.leader = { key = "q", mods = "CTRL", timeout_milliseconds = 2000 }

return config
