#!/bin/sh
# Xray entrypoint for Cloady.
# Reads $PORT (Cloady sets it; default 3000), $UUID and $WS_PATH, writes the
# Xray config, then starts Xray. TLS is terminated by Cloady's edge, so the
# inbound is plain WebSocket.
set -e

PORT="${PORT:-3000}"
UUID="${UUID:-c7b1393c-6e9a-4063-a966-b1635ec75e1d}"
WS_PATH="${WS_PATH:-/ray}"

mkdir -p /etc/xray
cat > /etc/xray/config.json <<EOF
{
  "log": { "loglevel": "warning" },
  "inbounds": [
    {
      "port": $PORT,
      "listen": "0.0.0.0",
      "protocol": "vless",
      "settings": {
        "clients": [ { "id": "$UUID", "flow": "" } ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": { "path": "$WS_PATH" }
      }
    }
  ],
  "outbounds": [ { "protocol": "freedom", "tag": "direct" } ]
}
EOF

echo "xray listening on port $PORT, ws path $WS_PATH"
exec /usr/local/bin/xray -config /etc/xray/config.json
