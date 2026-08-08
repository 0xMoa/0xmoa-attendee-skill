#!/usr/bin/env bash
# Clone/build 0xmoa-client (+ protocol sibling) into a workspace directory.
set -euo pipefail

ROOT="${OXMOA_WORKSPACE:-$HOME/code/0xmoa-workspace}"
CLIENT_DIR="$ROOT/0xmoa-client"
PROTO_DIR="$ROOT/0xmoa-protocol"
CORE_ADDR="${OXMOA_CORE:-127.0.0.1:7420}"

mkdir -p "$ROOT"
cd "$ROOT"

if [[ ! -d "$PROTO_DIR/.git" ]]; then
  git clone https://github.com/0xMoa/0xmoa-protocol.git "$PROTO_DIR"
else
  git -C "$PROTO_DIR" pull --ff-only || true
fi

if [[ ! -d "$CLIENT_DIR/.git" ]]; then
  git clone https://github.com/0xMoa/0xmoa-client.git "$CLIENT_DIR"
else
  git -C "$CLIENT_DIR" pull --ff-only || true
fi

cd "$CLIENT_DIR"
go build -o bin/0xmoa ./cmd/0xmoa
echo "Built: $CLIENT_DIR/bin/0xmoa"
echo "Try: OXMOA_CORE=$CORE_ADDR $CLIENT_DIR/bin/0xmoa identity"
