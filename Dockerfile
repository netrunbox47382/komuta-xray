# Komuta free tier (dz-nano: 0.1 vCPU / 256 MB) — Xray VLESS+WS behind nginx.
# Komuta terminates TLS at its gateway and forwards plain HTTP to $PORT.
# Xray binds loopback only; nginx serves a decoy at / and proxies only the WS path.
FROM ghcr.io/xtls/xray-core:latest AS xray-src
FROM alpine:3.21
RUN apk add --no-cache nginx && mkdir -p /usr/local/etc/xray && touch /usr/local/etc/xray/config.json && chmod 666 /usr/local/etc/xray/config.json
COPY --from=xray-src /usr/local/bin/xray /usr/local/bin/xray
COPY --chmod=644 config.json.template /usr/local/etc/xray/config.json.template
COPY --chmod=644 nginx.conf.template /etc/nginx/nginx.conf.template
COPY --chmod=644 index.html /var/www/html/index.html
# nginx workers run as an unprivileged user; make the decoy world-readable.
RUN chmod -R a+rX /var/www/html
COPY --chmod=755 entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
