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
  web:
    image: 'nginx'
    ports:
      - "8080:80"
    networks:
      - appnet
    volumes:
      - ./web:/usr/share/nginx/html:ro

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

📌  Завдання 3: Запуск багатоконтейнерного застосунку

1. Запустіть застосунок за допомогою Docker Compose:
* Використовуйте команду docker-compose up -d для запуску всіх сервісів у фоновому режимі
2. Перевірте стан запущених сервісів:
* Застосовуйте команду docker-compose ps для перегляду стану запущених контейнерів
3. Перевірте роботу вебсервера:
* Відкрийте браузер та перейдіть за адресою http://localhost:8080. Ви повинні побачити сторінку nginx.

```textmate
hibana@mac robot_dreams_petclinic % docker-compose up -d

```

![nginx.png](nginx.png)


📌  Завдання 4: Налаштування мережі й томів

1. Досліджуйте створені мережі та томи:
* Використовуйте команди docker network ls та docker volume ls для перегляду створених мереж і томів

```textmate

```

```textmate

```

```textmate
В мене в докері трошки безлад тому знайшов через інспект потрібний volume, тому що без нього нічого не зрозуміло(
```

2. Перевірте підключення до бази даних:
* Застосовуйте команду docker exec для підключення до бази даних PostgreSQL всередині контейнера. <db_container_id> можна отримати з команди docker-compose ps.

## Redis
```redis
~/PhpstormProjects/robot_dreams_petclinic git:[Lesson_17] docker exec -it multi-container-app-redis-1 sh

/data # redis-cli
127.0.0.1:6379> ping
127.0.0.1:6379> info memory

```
## Postgres
```postgresql
~/PhpstormProjects/robot_dreams_petclinic git:[Lesson_17] docker exec -it multi-container-app-postgres-1 sh
# psql -U postgres
psql (17.5 (Debian 17.5-1.pgdg120+1))
Type "help" for help.

postgres=# SHOW DATABASES;
ERROR:  unrecognized configuration parameter "databases"
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

postgres=# INSERT INTO users (name, email) VALUES ("Thomas", "thomas@gmail.com");
ERROR:  column "Thomas" does not exist
postgres=# INSERT INTO users (name, email) VALUES ('Thomas', 'thomas@gmail.com');
INSERT 0 1
postgres=# SELECT * FROM users;
id |  name  |      email       |         created_at         
----+--------+------------------+----------------------------
  1 | Thomas | thomas@gmail.com | 2025-05-10 06:41:27.774989
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
