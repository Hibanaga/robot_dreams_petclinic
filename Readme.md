## HM-16 - Docker

## Dockerfile
### Helpful sources:
### [Rootless Docker](https://www.reddit.com/r/nginx/comments/16ih337/running_nginx_as_nonroot_unprivileged_inside/)
### [Nginx Rootless Config](https://stackoverflow.com/questions/63108119/how-to-run-an-nginx-container-as-non-root)
```dockerfile
FROM alpine:latest

ARG USER=nonroot
ENV HOME=/home/$USER

EXPOSE "8080"

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

CMD ["nginx", "-g", "daemon off;", "-e", "/tmp/error.log"]
```

### Build Image:
```textmate
hibana@mac robot_dreams_petclinic % docker build -t rootless-app .
[+] Building 1.7s (12/12) FINISHED                                                                                                                              docker:orbstack
 => [internal] load build definition from Dockerfile                                                                                                                       0.0s
 => => transferring dockerfile: 696B                                                                                                                                       0.0s
 => [internal] load metadata for docker.io/library/alpine:latest                                                                                                           1.3s
 => [internal] load .dockerignore                                                                                                                                          0.0s
 => => transferring context: 2B                                                                                                                                            0.0s
 => [1/7] FROM docker.io/library/alpine:latest@sha256:a8560b36e8b8210634f77d9f7f9efd7ffa463e380b75e2e74aff4511df3ef88c                                                     0.0s
 => [internal] load build context                                                                                                                                          0.0s
 => => transferring context: 136B                                                                                                                                          0.0s
 => CACHED [2/7] RUN apk add --update sudo                                                                                                                                 0.0s
 => CACHED [3/7] RUN apk add nginx                                                                                                                                         0.0s
 => [4/7] RUN adduser -D nonroot &&     echo "nonroot ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/nonroot &&     chmod 0440 /etc/sudoers.d/nonroot &&     mkdir -p /var/lib  0.1s
 => [5/7] COPY nginx.conf /etc/nginx/nginx.conf                                                                                                                            0.0s
 => [6/7] COPY index.html /var/www/localhost/htdocs/index.html                                                                                                             0.0s
 => [7/7] WORKDIR /home/nonroot                                                                                                                                            0.0s
 => exporting to image                                                                                                                                                     0.0s
 => => exporting layers                                                                                                                                                    0.0s
 => => writing image sha256:e5506973657555ac056a9e7f9d2b9065ec0893cc1a014b47fa6c815c5f78440f                                                                               0.0s
 => => naming to docker.io/library/rootless-app                                                                                                                            0.0s
```

### Run Container based on image and check installed packages and permissions:
```textmate
hibana@mac robot_dreams_petclinic % docker run -d --name="rootless-container" -p="8080:8080" rootless-app
76858a73ab9e3430c8a76a9854d6b28ced27d0825115c960335fbbbb2853bb21
hibana@mac robot_dreams_petclinic % docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED              STATUS              PORTS      NAMES
76858a73ab9e   rootless-app   "nginx -g 'daemon of…"   About a minute ago   Up About a minute   8080/tcp   rootless-container
hibana@mac robot_dreams_petclinic % docker exec -it rootless-container sh
~ $ nginx -v
nginx version: nginx/1.26.3
~ $ apk add curl
ERROR: Unable to lock database: Permission denied
ERROR: Failed to open apk database: Permission denied
```

### Run Container with Limited Resources:
### Without limits:
```textmate
docker stats 76858a73ab9e

CONTAINER ID   NAME                 CPU %     MEM USAGE / LIMIT     MEM %     NET I/O       BLOCK I/O        PIDS
76858a73ab9e   rootless-container   0.00%     1.219MiB / 11.73GiB   0.01%     1.05kB / 0B   8.22MB / 414kB   2
```

### With Limits:
```textmate
hibana@mac robot_dreams_petclinic %  docker run -d --cpus="0.5" --memory="256m" --name="rootless-container" -p="8080:8080" rootless-app
a7937dcdd51a29399f633a85e8e3e23d5c23df04ee4257800a028f00e68560c1
hibana@mac robot_dreams_petclinic % docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                                       NAMES
a7937dcdd51a   rootless-app   "nginx -g 'daemon of…"   2 seconds ago   Up 2 seconds   0.0.0.0:8080->8080/tcp, :::8080->8080/tcp   rootless-container

docker stats a7937dcdd51a --no-stream
CONTAINER ID   NAME                 CPU %     MEM USAGE / LIMIT   MEM %     NET I/O       BLOCK I/O         PIDS
a7937dcdd51a   rootless-container   0.00%     4.68MiB / 256MiB    1.83%     1.05kB / 0B   3.17MB / 32.8kB   2
```

### Nginx html:
```textmate
Важлива нотатка:

При створенні container на основі image важливим є вказання порту, 
в іншому випадку в браузері нічого не запрацює(
```
![nginx.png](nginx.png)