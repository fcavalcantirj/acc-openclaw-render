#!/bin/sh
# acc seed: place our pre-rendered agent config onto the persistent disk before the proxy
# starts openclaw. The proxy skips `onboard` when /data/.openclaw/openclaw.json already exists,
# so this makes openclaw boot as OUR agent (Telegram + persona + KB). Seed-if-absent → a
# redeploy refreshes config only on first boot; runtime state persists on the disk afterward.
set -e
mkdir -p /data/.openclaw /data/workspace
# Always refresh CONFIG + cognitive files from secret files (idempotent). Runtime state
# (sessions/, identity/, credentials/, telegram offsets) lives in separate files and is untouched,
# so it persists across deploys while config stays authoritative from our secret files.
cp /etc/secrets/openclaw.json /data/.openclaw/openclaw.json
rm -f /data/.openclaw/openclaw.json5   # drop any stale/empty json5 so openclaw uses our openclaw.json
cp /etc/secrets/SOUL.md   /data/workspace/SOUL.md
cp /etc/secrets/AGENTS.md /data/workspace/AGENTS.md
cp /etc/secrets/MEMORY.md /data/workspace/MEMORY.md
echo "acc-seed: config refreshed ($(wc -c < /data/.openclaw/openclaw.json) bytes) ; json5 removed ; launching proxy"
exec /usr/local/bin/proxy
