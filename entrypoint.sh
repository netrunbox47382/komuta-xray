#!/bin/sh
set -e
PORT="${PORT:-8080}"
UUID="${UUID:-00000000-0000-0000-0000-000000000000}"
WS_PATH="${WS_PATH:-/d1eb81b7}"
case "$WS_PATH" in
  /*) ;;
  *) WS_PATH="/$WS_PATH" ;;
esac
mkdir -p /tmp/km-client /tmp/km-proxy /tmp/km-fastcgi /tmp/km-uwsgi /tmp/km-scgi
sed -e "s|__UUID__|${UUID}|g" -e "s|__WS_PATH__|${WS_PATH}|g" /usr/local/etc/xray/config.json.template > /usr/local/etc/xray/config.json
sed -e "s|__PORT__|${PORT}|g" -e "s|__WS_PATH__|${WS_PATH}|g" /etc/nginx/nginx.conf.template > /tmp/nginx.conf
echo "starting xray loopback + nginx on port ${PORT} path ${WS_PATH}"
/usr/local/bin/xray run -c /usr/local/etc/xray/config.json &
exec nginx -e stderr -c /tmp/nginx.conf -g 'daemon off;'
