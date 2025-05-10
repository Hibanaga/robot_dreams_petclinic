1. Створіть новий каталог для вашого проєкту:
   * Назвіть його, наприклад, multi-container-app
1. Створіть docker-compose.yml файл:
   * У цьому файлі буде визначено конфігурацію для вебсервера, бази даних та кешу
   * Додайте до docker-compose.yml файлу образи nginx, postgres та redis
   * Додайте volume db-data для postgresql, та web-data для nginx
   * Додайте спільну мережу appnet
   * Створіть файл index.html з простим змістом і додайте до web-data приклад коду:

## HTML: web/index.html
```html
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>My Docker App</title>
    </head>
    <body style="width: 100%; height: 100vh; display: flex; align-items: center;">
        <div style="margin: 0 auto; text-align: center;">
            <h1>Hello from Docker!</h1>
            <h2>Немає нічого більш постійного, ніж тимчасове</h2>
        </div>
    </body>
</html>
```

```dockerfile
name: 'multi-container-app'

services:
  nginx:
    image: 'nginx'
    ports:
      - "8080:80"
    volumes:
      - web-data:/usr/share/nginx/html:ro
    networks:
      - appnet

  postgres:
    image: 'postgres:bookworm'
    shm_size: 128mb
    volumes:
      - db-data:/var/lib/postgresql/data
    environment:
      - POSTGRES_PASSWORD=root
    networks:
      - appnet

  redis:
    image: 'redis:alpine'
    ports:
      - "6380:6379"
    networks:
      - appnet
    healthcheck:
      test: [ "CMD", "redis-cli", "ping" ]
      interval: 10s
      timeout: 5s
      retries: 3

volumes:
  db-data:
  web-data:

networks:
  appnet:
    driver: bridge
```

### Update nginx index.html
```textmate
hibana@mac robot_dreams_petclinic % docker cp ./web-data/index.html multi-container-app-nginx-1:/usr/share/nginx/html/index.html
Successfully copied 2.05kB to multi-container-app-nginx-1:/usr/share/nginx/html/index.html
```

📌  Завдання 3: Запуск багатоконтейнерного застосунку

1. Запустіть застосунок за допомогою Docker Compose:
* Використовуйте команду docker-compose up -d для запуску всіх сервісів у фоновому режимі
2. Перевірте стан запущених сервісів:
* Застосовуйте команду docker-compose ps для перегляду стану запущених контейнерів
3. Перевірте роботу вебсервера:
* Відкрийте браузер та перейдіть за адресою http://localhost:8080. Ви повинні побачити сторінку nginx.

```textmate
hibana@mac robot_dreams_petclinic % docker-compose up -d

hibana@mac robot_dreams_petclinic % docker-compose up -d                                                                        
[+] Running 6/6
 ✔ Network multi-container-app_appnet        Created                                                                                                                       0.0s 
 ✔ Volume "multi-container-app_web-data"     Created                                                                                                                       0.0s 
 ✔ Volume "multi-container-app_db-data"      Created                                                                                                                       0.0s 
 ✔ Container multi-container-app-postgres-1  Started                                                                                                                       0.2s 
 ✔ Container multi-container-app-nginx-1     Started                                                                                                                       0.2s 
 ✔ Container multi-container-app-redis-1     Started                                                                                                                       0.2s 

hibana@mac robot_dreams_petclinic % docker-compose ps 
NAME                             IMAGE               COMMAND                  SERVICE    CREATED              STATUS                        PORTS
multi-container-app-nginx-1      nginx               "/docker-entrypoint.…"   nginx      About a minute ago   Up About a minute             0.0.0.0:8080->80/tcp, [::]:8080->80/tcp
multi-container-app-postgres-1   postgres:bookworm   "docker-entrypoint.s…"   postgres   About a minute ago   Up About a minute             5432/tcp
multi-container-app-redis-1      redis:alpine        "docker-entrypoint.s…"   redis      About a minute ago   Up About a minute (healthy)   0.0.0.0:6380->6379/tcp, [::]:6380->6379/tcp
```

![nginx.png](nginx.png)


📌  Завдання 4: Налаштування мережі й томів

1. Досліджуйте створені мережі та томи:
* Використовуйте команди docker network ls та docker volume ls для перегляду створених мереж і томів

```textmate
NETWORK ID     NAME                              DRIVER    SCOPE
6c8184c3c423   bridge                            bridge    local
6bd848cca67f   gazetkowo-api_gazetkowo-network   bridge    local
a2534d2dbf21   host                              host      local
ee01d744d39a   multi-container-app_appnet        bridge    local
0b3079b7c109   none                              null      local

hibana@mac robot_dreams_petclinic % docker volume ls
DRIVER    VOLUME NAME
local     9d0cf952ea734b4e686a54e02c36d97b2996bdce3ccf65aaf10ab273c060e060
local     17fa6c47f6ad3b4a9d781f237488bd0ed06fd29ca06a3f8c2ff7864da5785754
local     7428b2a42857de24a5b206963b7f74d7090888a3d246d1a69bde1e8e0163df4f
local     7762787f1b1799a4198ce7261adb20c90616b526290bf60b6f4e8cd9d8d5bd38
local     e8c83073fa04cd92b0d5fb29842d00904f9921fcd122878d732e8fb2b8be9ab9
local     multi-container-app_db-data
local     multi-container-app_web-data
```

2. Перевірте підключення до бази даних:
* Застосовуйте команду docker exec для підключення до бази даних PostgreSQL всередині контейнера. <db_container_id> можна отримати з команди docker-compose ps.

## Redis
```redis
hibana@mac robot_dreams_petclinic % docker exec -it multi-container-app-redis-1 sh          
/data # redis-cli

127.0.0.1:6379> keys *
(empty array)

127.0.0.1:6379> info memory
# Memory
used_memory:1091200
used_memory_human:1.04M
used_memory_rss:17920000
used_memory_rss_human:17.09M
used_memory_peak:1327840
used_memory_peak_human:1.27M
used_memory_peak_perc:82.18%
used_memory_overhead:1060560
used_memory_startup:993936
used_memory_dataset:30640
used_memory_dataset_perc:31.50%
allocator_allocated:5118688
allocator_active:13500416
allocator_resident:16384000
allocator_muzzy:0
total_system_memory:12591759360
total_system_memory_human:11.73G
used_memory_lua:31744
used_memory_vm_eval:31744
used_memory_lua_human:31.00K
used_memory_scripts_eval:0
number_of_cached_scripts:0
number_of_functions:0
number_of_libraries:0
used_memory_vm_functions:32768
used_memory_vm_total:64512
used_memory_vm_total_human:63.00K
used_memory_functions:192
used_memory_scripts:192
used_memory_scripts_human:192B
maxmemory:0
maxmemory_human:0B
maxmemory_policy:noeviction
allocator_frag_ratio:2.71
allocator_frag_bytes:5292064
allocator_rss_ratio:1.21
allocator_rss_bytes:2883584
rss_overhead_ratio:1.09
rss_overhead_bytes:1536000
mem_fragmentation_ratio:16.43
mem_fragmentation_bytes:16829000
mem_not_counted_for_evict:0
mem_replication_backlog:0
mem_total_replication_buffers:0
mem_replica_full_sync_buffer:0
mem_clients_slaves:0
mem_clients_normal:1920
mem_cluster_links:0
mem_aof_buffer:0
mem_allocator:jemalloc-5.3.0
mem_overhead_db_hashtable_rehashing:0
active_defrag_running:0
lazyfree_pending_objects:0
lazyfreed_objects:0

127.0.0.1:6379> ping
PONG
```
## Postgres
```postgresql
hibana@mac robot_dreams_petclinic % docker exec -it multi-container-app-postgres-1 sh
# psql -U postgres
psql (17.5 (Debian 17.5-1.pgdg120+1))
Type "help" for help.

postgres=# \l
List of databases
   Name    |  Owner   | Encoding | Locale Provider |  Collate   |   Ctype    | Locale | ICU Rules |   Access privileges   
-----------+----------+----------+-----------------+------------+------------+--------+-----------+-----------------------
 postgres  | postgres | UTF8     | libc            | en_US.utf8 | en_US.utf8 |        |           | 
 template0 | postgres | UTF8     | libc            | en_US.utf8 | en_US.utf8 |        |           | =c/postgres          +
           |          |          |                 |            |            |        |           | postgres=CTc/postgres
 template1 | postgres | UTF8     | libc            | en_US.utf8 | en_US.utf8 |        |           | =c/postgres          +
           |          |          |                 |            |            |        |           | postgres=CTc/postgres
(3 rows)

postgres=# \c postgres
You are now connected to database "postgres" as user "postgres".
postgres=# \dt
Did not find any relations.
postgres=# CREATE TABLE users ( id SERIAL PRIMARY KEY, name VARCHAR(100) NOT NULL, email VARCHAR(100) UNIQUE NOT NULL, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE
   postgres=# \dt
List of relations
 Schema | Name  | Type  |  Owner   
--------+-------+-------+----------
 public | users | table | postgres
(1 row)
postgres=# INSERT INTO users (name, email) VALUES ('Thomas', 'thomas@gmail.com');
INSERT 0 1
postgres=# SELECT * FROM users;
 id |  name  |      email       |         created_at         
----+--------+------------------+----------------------------
  1 | Thomas | thomas@gmail.com | 2025-05-10 09:46:28.476662
(1 row)
```

📌  Завдання 5: Масштабування сервісів

1. Масштабуйте вебсервер:
* Використовуйте команду docker-compose up -d --scale web=3 для запуску трьох екземплярів вебсервера
2. Перевірте стан масштабованих сервісів:
* Використовуйте команду docker-compose ps для перегляду стану запущених контейнерів

```textmate
Для виконання цього завдання були потрібні зміни в конфігурації,
тому що при початковій ініціалізації було явно алоковано порт 
і при створенні нових контейнерів на основі 'nginx', виникає помилка.

Тому умовно розділив на дві різних конфігурації, але конкретно в контейнері залишив тільки нову конфігурацію.
Тому що при виконанні попередніх пунктів ми не потребуємо чогось більшого ніж надана конфігурація.

hibana@mac robot_dreams_petclinic % docker-compose up -d --scale web=3
[+] Building 0.1s (15/15) FINISHED                                                                                                                              docker:orbstack
 => [web internal] load build definition from Dockerfile                                                                                                                   0.0s
 => => transferring dockerfile: 183B                                                                                                                                       0.0s
 => [reverse-proxy internal] load build definition from Dockerfile                                                                                                         0.0s
 => => transferring dockerfile: 134B                                                                                                                                       0.0s
 => [reverse-proxy internal] load metadata for docker.io/library/nginx:latest                                                                                              0.0s
 => [web internal] load .dockerignore                                                                                                                                      0.0s
 => => transferring context: 2B                                                                                                                                            0.0s
 => [reverse-proxy internal] load .dockerignore                                                                                                                            0.0s
 => => transferring context: 2B                                                                                                                                            0.0s
 => [reverse-proxy 1/3] FROM docker.io/library/nginx:latest                                                                                                                0.0s
 => [web internal] load build context                                                                                                                                      0.0s
 => => transferring context: 610B                                                                                                                                          0.0s
 => [reverse-proxy internal] load build context                                                                                                                            0.0s
 => => transferring context: 71B                                                                                                                                           0.0s
 => CACHED [web 2/3] COPY index.html /usr/share/nginx/html/index.html                                                                                                      0.0s
 => CACHED [web 3/3] COPY default.conf /etc/nginx/conf.d/default.conf                                                                                                      0.0s
 => CACHED [reverse-proxy 2/2] COPY default.conf /etc/nginx/conf.d/default.conf                                                                                            0.0s
 => [web] exporting to image                                                                                                                                               0.0s
 => => exporting layers                                                                                                                                                    0.0s
 => => writing image sha256:508640157ad414b541b2a0063b7c4a866c1d60f7f132914ff98da61a190cca91                                                                               0.0s
 => => naming to docker.io/library/multi-container-app-web                                                                                                                 0.0s
 => [reverse-proxy] exporting to image                                                                                                                                     0.0s
 => => exporting layers                                                                                                                                                    0.0s
 => => writing image sha256:9e2ad581db5a805619fad43fff9c7edbd4ad01f561c15c04844c162f70a3f718                                                                               0.0s
 => => naming to docker.io/library/multi-container-app-reverse-proxy                                                                                                       0.0s
 => [web] resolving provenance for metadata file                                                                                                                           0.0s
 => [reverse-proxy] resolving provenance for metadata file                                                                                                                 0.0s
[+] Running 10/10
 ✔ reverse-proxy                                  Built                                                                                                                    0.0s 
 ✔ web                                            Built                                                                                                                    0.0s 
 ✔ Network multi-container-app_appnet             Created                                                                                                                  0.0s 
 ✔ Volume "multi-container-app_db-data"           Created                                                                                                                  0.0s 
 ✔ Container multi-container-app-reverse-proxy-1  Started                                                                                                                  0.2s 
 ✔ Container multi-container-app-redis-1          Started                                                                                                                  0.2s 
 ✔ Container multi-container-app-postgres-1       Started                                                                                                                  0.2s 
 ✔ Container multi-container-app-web-1            Started                                                                                                                  0.2s 
 ✔ Container multi-container-app-web-2            Started                                                                                                                  0.4s 
 ✔ Container multi-container-app-web-3            Started                                                                                                                  0.3s 

hibana@mac robot_dreams_petclinic % docker-compose ps
NAME                                  IMAGE                               COMMAND                  SERVICE         CREATED          STATUS                    PORTS
multi-container-app-postgres-1        postgres:bookworm                   "docker-entrypoint.s…"   postgres        20 seconds ago   Up 20 seconds             5432/tcp
multi-container-app-redis-1           redis:alpine                        "docker-entrypoint.s…"   redis           20 seconds ago   Up 20 seconds (healthy)   0.0.0.0:6380->6379/tcp, [::]:6380->6379/tcp
multi-container-app-reverse-proxy-1   multi-container-app-reverse-proxy   "/docker-entrypoint.…"   reverse-proxy   20 seconds ago   Up 20 seconds             0.0.0.0:8080->80/tcp, [::]:8080->80/tcp
multi-container-app-web-1             multi-container-app-web             "/docker-entrypoint.…"   web             20 seconds ago   Up 20 seconds             80/tcp
multi-container-app-web-2             multi-container-app-web             "/docker-entrypoint.…"   web             20 seconds ago   Up 19 seconds             80/tcp
multi-container-app-web-3             multi-container-app-web             "/docker-entrypoint.…"   web             20 seconds ago   Up 19 seconds             80/tcp
```

```postgresql
Error response from daemon: driver failed programming external connectivity on endpoint multi-container-app-web-3 (dda560fa2da34dd5e584ec5608ccd19a37035f6a77e5272617142c7be4d785fe): Bind for 0.0.0.0:8080 failed: port is already allocated
```

## docker-compose.yml
```dockerfile
name: 'multi-container-app'

services:
  reverse-proxy:
    build:
      context: ./nginx
      dockerfile: Dockerfile
    ports:
      - "8080:80"
    networks:
      - appnet

  web:
    build:
      context: ./web-data
      dockerfile: Dockerfile
    expose:
      - "80"
    networks:
      - appnet

  postgres:
    image: 'postgres:bookworm'
    shm_size: 128mb
    volumes:
      - db-data:/var/lib/postgresql/data
    environment:
      - POSTGRES_PASSWORD=root
    networks:
      - appnet

  redis:
    image: 'redis:alpine'
    ports:
      - "6380:6379"
    networks:
      - appnet
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 3

volumes:
  db-data:

networks:
  appnet:
    driver: bridge
```

# Reverse-proxy
## nginx/default.conf
```textmate
upstream web_instance {
    server web:80;
    server web:80;
    server web:80;
}

server {
    listen 80;

    access_log /var/log/nginx/access.log;

    location / {
        proxy_pass http://web_instance;
    }
}
```

## nginx/Dockerfile
```textmate
FROM nginx

COPY default.conf /etc/nginx/conf.d/default.conf
```

# Web
## web-data/default.conf:
```textmate
server {
    listen 80;

    location / {
        root /usr/share/nginx/html;
        index index.html;
        add_header X-Served-By $hostname;
    }
}
```

## web-data/Dockerfile
```textmate
FROM nginx

COPY index.html /usr/share/nginx/html/index.html
COPY default.conf /etc/nginx/conf.d/default.conf
```

## web-data/index.html
```textmate
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>My Docker App</title>
</head>
<body style="width: 100%; height: 100vh; display: flex; align-items: center;">
<div style="margin: 0 auto; text-align: center;">
    <h1>Hello from Docker!</h1>
    <h2>Немає нічого більш постійного, ніж тимчасове</h2>
</div>
</body>
</html>
```

## Bash (verification):
```textmate
#!/bin/bash

echo "Collection unique X-Served-By values..."

for i in {1..100}; do
  curl -s -D - http://localhost:8080 -o /dev/null | grep -i 'X-Served-By'
done  | sort | uniq

hibana@mac robot_dreams_petclinic % sh x-server-by-log.sh
Collection unique X-Served-By values...
X-Served-By: 8b13493d8ef0
X-Served-By: aeed6545d5c0
```

```textmate
Власне тут в певній мірі можна було зробити в декілька разів простіше без створення кількох 
Dockerfile і додаткової конфігурації nginx для web-data, але я трошки хотів досягнути того чого певно в docker-compose 
без docker-swarm досягнути неможливо, тобто щоб трафік розподілявся рівномірно між всіма інстансами під час пінгування.
```
