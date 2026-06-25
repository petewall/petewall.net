FROM nginxinc/nginx-unprivileged:1.31-alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY public /usr/share/nginx/html
