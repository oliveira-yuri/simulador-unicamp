#!/bin/sh
# Generates the nginx Basic Auth config from environment variables at container start.
# The password never lives in the repository or the image.
set -eu

AUTH_CONF=/etc/nginx/auth.conf

if [ -n "${BASIC_AUTH_USER:-}" ] && [ -n "${BASIC_AUTH_PASS:-}" ]; then
    printf '%s:%s\n' "$BASIC_AUTH_USER" "$(printf '%s' "$BASIC_AUTH_PASS" | openssl passwd -apr1 -stdin)" > /etc/nginx/.htpasswd
    chmod 640 /etc/nginx/.htpasswd
    chown root:nginx /etc/nginx/.htpasswd
    printf 'auth_basic "Simulador Unicamp";\nauth_basic_user_file /etc/nginx/.htpasswd;\n' > "$AUTH_CONF"
    echo "basic-auth: enabled for user $BASIC_AUTH_USER"
else
    : > "$AUTH_CONF"
    echo "basic-auth: disabled (BASIC_AUTH_USER/BASIC_AUTH_PASS not set)"
fi
