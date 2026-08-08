#!/usr/bin/env sh
# Cheap CFP change detector for long-running bot schedulers.
# Prints a final JSON line: {"wakeAgent": true|false, ...}
# Hermes: use as cron script= pre-check (wakeAgent gate).
# Other hosts: exit 0 always; parse last line to decide whether to call the LLM.
set -eu
HOME_OX="${OXMOA_HOME:-$HOME/.0xmoa}"
STATE="$HOME_OX/cfp_poll_state"
BIN="${OXMOA_BIN:-0xmoa}"

mkdir -p "$HOME_OX"

if ! command -v "$BIN" >/dev/null 2>&1; then
  printf '%s\n' '{"wakeAgent":false,"reason":"0xmoa_not_on_path"}'
  exit 0
fi

OUT="$("$BIN" proposal list 2>/dev/null)" || {
  printf '%s\n' '{"wakeAgent":false,"reason":"proposal_list_failed"}'
  exit 0
}

if command -v jq >/dev/null 2>&1; then
  TOTAL=$(printf '%s' "$OUT" | jq -r '.total // (.proposals|length) // 0')
  NEWEST=$(printf '%s' "$OUT" | jq -r '.proposals[0].proposalId // .proposals[0].proposal_id // empty')
else
  TOTAL=$(printf '%s' "$OUT" | sed -n 's/.*"total"[[:space:]]*:[[:space:]]*\([0-9]*\).*/\1/p' | head -1)
  NEWEST=$(printf '%s' "$OUT" | sed -n 's/.*"proposalId"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1)
  [ -z "$NEWEST" ] && NEWEST=$(printf '%s' "$OUT" | sed -n 's/.*"proposal_id"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1)
fi
TOTAL="${TOTAL:-0}"
PREV_TOTAL=""
PREV_NEWEST=""
# shellcheck disable=SC1090
[ -f "$STATE" ] && . "$STATE"

WAKE=false
if [ "$TOTAL" != "$PREV_TOTAL" ]; then
  WAKE=true
elif [ -n "$NEWEST" ] && [ "$NEWEST" != "$PREV_NEWEST" ]; then
  WAKE=true
fi

{
  printf 'PREV_TOTAL=%s\n' "$TOTAL"
  printf 'PREV_NEWEST=%s\n' "$NEWEST"
} > "$STATE"

if [ "$WAKE" = true ]; then
  printf '{"wakeAgent":true,"context":{"total":%s,"newest":"%s"}}\n' "$TOTAL" "$NEWEST"
else
  printf '%s\n' '{"wakeAgent":false,"reason":"no_cfp_change"}'
fi
