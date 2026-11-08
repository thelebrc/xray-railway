# Xray (VLESS + WebSocket) for Cloady — Japan node
# Cloady serves the app on $PORT (default 3000) behind its own HTTPS edge,
# so Xray listens plain WebSocket here; TLS is terminated by Cloady.
FROM alpine:latest

RUN apk add --no-cache curl unzip ca-certificates \
  && curl -fsSL https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip -o /tmp/xray.zip \
  && unzip -o /tmp/xray.zip -d /usr/local/bin/ \
  && chmod +x /usr/local/bin/xray \
  && rm -f /tmp/xray.zip

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
