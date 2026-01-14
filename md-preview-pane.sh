#!/usr/bin/env bash
set -euo pipefail

DEBUG="${MD_PREVIEW_DEBUG:-false}"
md="${MD_PREVIEW_PATH:?}"
viewer="${MD_PREVIEW_VIEWER:?}"   # glow | bat
watch="${MD_PREVIEW_WATCH:-none}" # watchexec | entr | none

log() { if [[ "$DEBUG" = "true" ]]; then echo "Preview(debug): $*" >&2; fi; }
log "md=$md"
log "viewer=$viewer watch=$watch"

if [[ "$viewer" = "glow" ]]; then
  # NOTE:
  # `glow -p` は pager 実行に失敗すると exit 1 になりやすく、watch との相性が悪い。
  # 右ペインは自動再描画するので pager は使わず、毎回 clear して描画し直す。
  view_cmd=(glow "$md")
else
  view_cmd=(bat -l md "$md")
fi

case "$watch" in
  watchexec)
    log "starting watchexec..."
    watchexec -r -w "$md" -- bash -lc 'clear || true; "$@"' bash "${view_cmd[@]}"
    rc=$?
    echo "Preview error: watchexec exited with status $rc" >&2
    sleep 999999
    ;;
  entr)
    log "starting entr..."
    printf "%s\n" "$md" | entr -c bash -lc 'clear || true; "$@"' bash "${view_cmd[@]}"
    rc=$?
    echo "Preview error: entr exited with status $rc" >&2
    sleep 999999
    ;;
  *)
    log "no watcher; rendering once"
    clear || true
    "${view_cmd[@]}"
    rc=$?
    if [[ $rc -ne 0 ]]; then
      echo "Preview error: viewer exited with status $rc" >&2
    fi
    sleep 999999
    ;;
esac


