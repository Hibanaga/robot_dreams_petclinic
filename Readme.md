# HM-22 -> AWS Basics

```textmate
Усі створені скріни були зроблені на основі хронології оперцій, 
для спрощеної взаємодії під час переглядання домашнього завдання.

В випадку якщо потребуєш викладення під завданнями, 
то можеш написати і постараюсь погрупувати краще.
```

📌 Опис завдання

1. Створення та налаштування VPC

* Створіть нову VPC:
    * Використайте консоль AWS для створення VPC.
    * Виберіть CIDR-блок
* Створіть дві підмережі в VPC:
    * Створіть одну публічну підмережу з CIDR-блоком.
    * Створіть одну приватну підмережу з CIDR-блоком.
* Створіть та налаштуйте інтернет-шлюз (Internet Gateway):
    * Прив'яжіть інтернет-шлюз до вашої VPC.
    * Налаштуйте таблиці маршрутизації для забезпечення доступу до інтернету з публічної підмережі.
2. Налаштування груп безпеки (Security Groups) та списків контролю доступу (ACL)
* Додайте правила для дозволу вхідного HTTP та SSH трафіку з будь-якої IP-адреси.
3. Запуск інстансу EC2
* Запустіть новий інстанс EC2:
    * Використайте Amazon Linux 2 AMI.
    * Виберіть тип інстансу, наприклад, t2.micro. Оскільки він безкоштовний.
    * Прив'яжіть інстанс до публічної підмережі.
    * Використайте Security Group, створену на попередньому кроці.
    * Завантажте та використайте SSH-ключ для доступу до інстансу.

4. Призначення еластичної IP-адреси (EIP)
* Створіть та призначте EIP до вашого інстансу:
    * Створіть нову EIP в AWS консолі.
    * Прив'яжіть EIP до запущеного інстансу EC2.

## VPC & Subnets
![create_vpc.png](create_vpc.png)
![public_subnet.png](public_subnet.png)
![private_subnet.png](private_subnet.png)

## Gateway
![gateway.png](gateway.png)
![attach-to-vpc.png](attach-to-vpc.png)
![route_tables.png](route_tables.png)
![route_associations.png](route_associations.png)
![security_groups_ssh_http.png](security_groups_ssh_http.png)

## EC2 -> Instances
![rsa-keygen.png](rsa-keygen.png)
![ec2-instance-creation.png](ec2-instance-creation.png)

## SSH -> post-creation run
![ssh-server.png](ssh-server.png)

## EC2 -> ElasticIP associations
![elastic-ip-association.png](elastic-ip-association.png)

## SSH -> ElasticIP instance run
![elastic-ip-ssh.png](elastic-ip-ssh.png)

## Post HM actions -> Release Elastic IP and ec2 instance termination
![post-delete-ec2-instance.png](post-delete-ec2-instance.png)
![elastic-ip-release.png](elastic-ip-release.png)
