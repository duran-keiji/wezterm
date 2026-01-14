#!/usr/bin/env bash
set -euo pipefail

# Debug mode
DEBUG="${DEBUG:-false}"
if [[ "$DEBUG" = "true" ]]; then
  echo "Debug: Starting md-preview.sh with args: $*" >&2
fi

md="${1:-}"
if [[ -z "$md" ]]; then
  echo "usage: md-preview.sh path/to/file.md" >&2
  exit 2
fi

# Current pane id (the editor will run here)
edit_pane_id="${WEZTERM_PANE:-}"
if [[ "$DEBUG" = "true" ]]; then
  echo "Debug: WEZTERM_PANE(edit)=$edit_pane_id" >&2
fi

# Resolve to absolute path (best-effort)
if command -v python3 >/dev/null 2>&1; then
  md_abs="$(
    python3 - <<'PY' "$md"
import os, sys
p = sys.argv[1]
print(os.path.abspath(os.path.expanduser(p)))
PY
  )"
else
  md_abs="$(cd "$(dirname "$md")" && pwd)/$(basename "$md")"
fi

if [[ "$DEBUG" = "true" ]]; then
  echo "Debug: Resolved path: $md_abs" >&2
fi
if [[ ! -f "$md_abs" ]]; then
  # Convenience fallback:
  # If user passed just "README.md" etc. from another cwd, try ~/.config/wezterm/<name>
  if [[ "$md" != /* ]] && [[ "$md" != ~* ]] && [[ "$md" != */* ]]; then
    alt="${HOME}/.config/wezterm/${md}"
    if [[ -f "$alt" ]]; then
      if [[ "$DEBUG" = "true" ]]; then
        echo "Debug: Fallback hit: $alt" >&2
      fi
      md_abs="$alt"
    fi
  fi
fi

if [[ ! -f "$md_abs" ]]; then
  echo "Error: file not found: $md_abs" >&2
  echo "Debug: Original input: $md" >&2
  echo "Hint: 例) ~/.config/wezterm/md-preview.sh ~/.config/wezterm/README.md" >&2
  exit 1
fi

dir="$(cd "$(dirname "$md_abs")" && pwd)"

if ! command -v wezterm >/dev/null 2>&1; then
  echo "wezterm not found in PATH" >&2
  exit 1
fi

if [[ "$DEBUG" = "true" ]]; then
  echo "Debug: Checking WezTerm CLI connection..." >&2
fi
if ! wezterm cli list >/dev/null 2>&1; then
  echo "Error: This script must be run inside a WezTerm pane (wezterm cli is not connected)." >&2
  exit 1
fi

viewer_kind=""
if [[ "$DEBUG" = "true" ]]; then
  echo "Debug: Checking for markdown viewers..." >&2
fi
if command -v glow >/dev/null 2>&1; then
  viewer_kind="glow"
elif command -v bat >/dev/null 2>&1; then
  viewer_kind="bat"
else
  echo "Error: Install a markdown viewer first: brew install glow (recommended) or brew install bat" >&2
  exit 1
fi

watch_kind="none"
if command -v watchexec >/dev/null 2>&1; then
  watch_kind="watchexec"
elif command -v entr >/dev/null 2>&1; then
  watch_kind="entr"
fi

if [[ "$DEBUG" = "true" ]]; then
  echo "Debug: viewer=$viewer_kind watch=$watch_kind" >&2
fi

preview_runner="${HOME}/.config/wezterm/md-preview-pane.sh"
if [[ ! -x "$preview_runner" ]]; then
  echo "Error: preview runner not found or not executable: $preview_runner" >&2
  echo "Run: chmod +x ~/.config/wezterm/md-preview-pane.sh" >&2
  exit 1
fi

preview_pane_id="$(
  wezterm cli split-pane --right --cwd "$dir" -- env \
    MD_PREVIEW_PATH="$md_abs" \
    MD_PREVIEW_VIEWER="$viewer_kind" \
    MD_PREVIEW_WATCH="$watch_kind" \
    MD_PREVIEW_DEBUG="$DEBUG" \
    bash -lc "$preview_runner" 2>&1
)" || {
  echo "Error: failed to create preview pane" >&2
  exit 1
}

if [[ "$DEBUG" = "true" ]]; then
  echo "Debug: preview pane id=$preview_pane_id" >&2
fi

# Ensure we run the editor in the original pane
if [[ -n "$edit_pane_id" ]]; then
  wezterm cli activate-pane --pane-id "$edit_pane_id" >/dev/null 2>&1 || true
fi

exec "${EDITOR:-nvim}" "$md_abs"


