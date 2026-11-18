# Serve the static exam simulator with nginx.
# Optional HTTP Basic Auth: set BASIC_AUTH_USER and BASIC_AUTH_PASS (e.g. in Coolify's
# environment variables). When either is empty, the site is served without a password.
FROM nginx:1.27-alpine

RUN apk add --no-cache openssl

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY 40-basic-auth.sh /docker-entrypoint.d/40-basic-auth.sh
RUN chmod +x /docker-entrypoint.d/40-basic-auth.sh

COPY index.html banco.js /usr/share/nginx/html/
COPY img /usr/share/nginx/html/img

EXPOSE 80
