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

