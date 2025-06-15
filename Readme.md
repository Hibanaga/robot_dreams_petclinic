1. Створення RDS інстансу

1. Увійдіть до AWS Management Console
2. Відкрийте сервіс RDS та створіть інстанс бази даних:
* Виберіть Create database
* Тип бази: MySQL (можна обрати PostgreSQL за бажанням)
* Шаблон: Free tier
* Конфігурація:
    * DB instance identifier: library-db
    * Master username: admin
    * Master password: створіть надійний пароль
    * DB instance class: db.t3.micro
    * Дисковий простір: 20 ГБ (General Purpose SSD)
    * Увімкніть Public access для підключення до бази з вашого комп'ютера
* У розділі Network & Security:
    * Виберіть існуючу VPC або створіть нову
    * Додайте нову security group, що дозволяє доступ лише з вашого IP
3. Дочекайтесь завершення створення інстансу.

2. Підключення до бази
1. Під'єднайтеся до бази даних за допомогою SQL-клієнта (наприклад, MySQL Workbench)
2. Використовуйте параметри підключення, надані в RDS (адреса хоста, порт 3306, ім'я користувача admin та пароль)