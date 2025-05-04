FROM alpine:latest

ARG USER=nonroot
ENV HOME=/home/$USER

CMD [ "/bin/sh" ]

RUN apk add --update sudo
RUN apk add nginx

RUN adduser -D $USER && \
    echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER && \
    chmod 0440 /etc/sudoers.d/$USER && \
    mkdir -p /var/lib/nginx/tmp/client_body && \
    mkdir -p /var/lib/nginx/logs && \
    mkdir -p /run/nginx && \
    chown -R $USER:$USER /var/lib/nginx /run/nginx

COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html /var/www/localhost/htdocs/index.html

USER $USER
WORKDIR $HOME

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;", "-e", "/tmp/error.log"]