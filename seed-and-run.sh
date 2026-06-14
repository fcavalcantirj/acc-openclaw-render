#!/bin/sh
# acc seed: place our pre-rendered agent config onto the persistent disk before the proxy
# starts openclaw. The proxy skips `onboard` when /data/.openclaw/openclaw.json already exists,
# so this makes openclaw boot as OUR agent (Telegram + persona + KB). Seed-if-absent → a
# redeploy refreshes config only on first boot; runtime state persists on the disk afterward.
set -e
mkdir -p /data/.openclaw /data/workspace
[ -f /data/.openclaw/openclaw.json ] || cp /etc/secrets/openclaw.json /data/.openclaw/openclaw.json
[ -f /data/workspace/SOUL.md ]   || cp /etc/secrets/SOUL.md   /data/workspace/SOUL.md
[ -f /data/workspace/AGENTS.md ] || cp /etc/secrets/AGENTS.md /data/workspace/AGENTS.md
[ -f /data/workspace/MEMORY.md ] || cp /etc/secrets/MEMORY.md /data/workspace/MEMORY.md
echo "acc-seed: config in place at /data/.openclaw ; launching proxy"
exec /usr/local/bin/proxy
