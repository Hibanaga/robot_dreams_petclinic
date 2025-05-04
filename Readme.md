# HM 15 - Replication

## Resource: ([source](https://dev.to/siddhantkcode/how-to-set-up-a-mysql-master-slave-replication-in-docker-4n0a))

```sql
    mysql> CREATE USER 'slave'@'%' IDENTIFIED BY 'slave';
    Query OK, 0 rows affected (0.009 sec)
    
    mysql> GRANT REPLICATION SLAVE ON *.* TO 'slave'@'%';
    Query OK, 0 rows affected (0.003 sec)
    
    mysql> FLUSH PRIVILEGES;
    Query OK, 0 rows affected, 1 warning (0.009 sec)

                                                        
    mysql> SHOW BINARY LOG STATUS;
    +------------------+----------+--------------+------------------+-------------------+
    | File             | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
    +------------------+----------+--------------+------------------+-------------------+
    | mysql-bin.000003 |     1218 |              |                  |                   |
    +------------------+----------+--------------+------------------+-------------------+
    1 row in set (0.007 sec)

```

## Version mismatch (to version above 8.0) ([source](https://www.reddit.com/r/mysql/comments/1d6ysx0/show_master_status_not_working/)):
```sql

    mysql> SHOW MASTER STATUS;
    ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'MASTER STATUS' at line 1
      
```

## Latest MySql command to assign replication source ([source](https://dba.stackexchange.com/questions/322002/i-get-a-syntax-error-whenever-i-use-change-replication-source-to-in-mysql))
```sql 
mysql> CHANGE REPLICATION SOURCE TO
    ->   SOURCE_HOST='mysql-master',
    ->   SOURCE_USER='slave',
    ->   SOURCE_PASSWORD='slave',
    ->   SOURCE_LOG_FILE='mysql-bin.000003',
    ->   SOURCE_LOG_POS=1218,
    ->   GET_SOURCE_PUBLIC_KEY = 1;
Query OK, 0 rows affected, 2 warnings (0.040 sec)

mysql> START REPLICA;
Query OK, 0 rows affected (0.035 sec)

mysql> SHOW REPLICA STATUS\G
*************************** 1. row ***************************
             Replica_IO_State: Waiting for source to send event
                  Source_Host: mysql-master
                  Source_User: slave
                  Source_Port: 3306
                Connect_Retry: 60
              Source_Log_File: mysql-bin.000003
          Read_Source_Log_Pos: 1218
               Relay_Log_File: 22def9d29cbe-relay-bin.000002
                Relay_Log_Pos: 328
        Relay_Source_Log_File: mysql-bin.000003
           Replica_IO_Running: Yes
          Replica_SQL_Running: Yes
              Replicate_Do_DB: 
          Replicate_Ignore_DB: 
           Replicate_Do_Table: 
       Replicate_Ignore_Table: 
      Replicate_Wild_Do_Table: 
  Replicate_Wild_Ignore_Table: 
                   Last_Errno: 0
                   Last_Error: 
                 Skip_Counter: 0
          Exec_Source_Log_Pos: 1218
              Relay_Log_Space: 546
              Until_Condition: None
               Until_Log_File: 
                Until_Log_Pos: 0
           Source_SSL_Allowed: No
           Source_SSL_CA_File: 
           Source_SSL_CA_Path: 
              Source_SSL_Cert: 
            Source_SSL_Cipher: 
               Source_SSL_Key: 
        Seconds_Behind_Source: 0
Source_SSL_Verify_Server_Cert: No
                Last_IO_Errno: 0
                Last_IO_Error: 
               Last_SQL_Errno: 0
               Last_SQL_Error: 
  Replicate_Ignore_Server_Ids: 
             Source_Server_Id: 1
                  Source_UUID: 4937988b-28b4-11f0-ba3c-0242c0a86b02
             Source_Info_File: mysql.slave_master_info
                    SQL_Delay: 0
          SQL_Remaining_Delay: NULL
    Replica_SQL_Running_State: Replica has read all relay log; waiting for more updates
           Source_Retry_Count: 10
                  Source_Bind: 
      Last_IO_Error_Timestamp: 
     Last_SQL_Error_Timestamp: 
               Source_SSL_Crl: 
           Source_SSL_Crlpath: 
           Retrieved_Gtid_Set: 
            Executed_Gtid_Set: 
                Auto_Position: 0
         Replicate_Rewrite_DB: 
                 Channel_Name: 
           Source_TLS_Version: 
       Source_public_key_path: 
        Get_Source_public_key: 1
            Network_Namespace: 
1 row in set (0.000 sec)
```

## Root:
```sql
mysql> create database replication_master;
Query OK, 1 row affected (0.021 sec)

mysql> use replication_master;
Database changed
mysql> CREATE TABLE users (
    ->   id INT AUTO_INCREMENT PRIMARY KEY,
    ->   first_name VARCHAR(128),
    ->   last_name VARCHAR(128)
    -> );
Query OK, 0 rows affected (0.044 sec)

mysql> INSERT INTO users (first_name, last_name) VALUES 
    -> ('Thomas', 'Abracham'),
    -> ('Jack', 'Black'),
    -> ('Jason', 'Tatum');
Query OK, 3 rows affected (0.022 sec)
Records: 3  Duplicates: 0  Warnings: 0

mysql> select * from users;
+----+------------+-----------+
| id | first_name | last_name |
+----+------------+-----------+
|  1 | Thomas     | Abracham  |
|  2 | Jack       | Black     |
|  3 | Jason      | Tatum     |
+----+------------+-----------+
3 rows in set (0.001 sec)

mysql> SHOW REPLICA STATUS\G
Empty set (0.008 sec)
```

## Slave:
```sql
mysql> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| replication_master |
| replication_test   |
| sys                |
+--------------------+
6 rows in set (0.003 sec)

mysql> use replication_master;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> select * from users;
+----+------------+-----------+
| id | first_name | last_name |
+----+------------+-----------+
|  1 | Thomas     | Abracham  |
|  2 | Jack       | Black     |
|  3 | Jason      | Tatum     |
+----+------------+-----------+
3 rows in set (0.001 sec)

mysql> SHOW REPLICA STATUS\G
*************************** 1. row ***************************
             Replica_IO_State: Waiting for source to send event
                  Source_Host: mysql-master
                  Source_User: slave
                  Source_Port: 3306
                Connect_Retry: 60
              Source_Log_File: mysql-bin.000003
          Read_Source_Log_Pos: 2121
               Relay_Log_File: 22def9d29cbe-relay-bin.000002
                Relay_Log_Pos: 1231
        Relay_Source_Log_File: mysql-bin.000003
           Replica_IO_Running: Yes
          Replica_SQL_Running: Yes
              Replicate_Do_DB: 
          Replicate_Ignore_DB: 
           Replicate_Do_Table: 
       Replicate_Ignore_Table: 
      Replicate_Wild_Do_Table: 
  Replicate_Wild_Ignore_Table: 
                   Last_Errno: 0
                   Last_Error: 
                 Skip_Counter: 0
          Exec_Source_Log_Pos: 2121
              Relay_Log_Space: 1449
              Until_Condition: None
               Until_Log_File: 
                Until_Log_Pos: 0
           Source_SSL_Allowed: No
           Source_SSL_CA_File: 
           Source_SSL_CA_Path: 
              Source_SSL_Cert: 
            Source_SSL_Cipher: 
               Source_SSL_Key: 
        Seconds_Behind_Source: 0
Source_SSL_Verify_Server_Cert: No
                Last_IO_Errno: 0
                Last_IO_Error: 
               Last_SQL_Errno: 0
               Last_SQL_Error: 
  Replicate_Ignore_Server_Ids: 
             Source_Server_Id: 1
                  Source_UUID: 4937988b-28b4-11f0-ba3c-0242c0a86b02
             Source_Info_File: mysql.slave_master_info
                    SQL_Delay: 0
          SQL_Remaining_Delay: NULL
    Replica_SQL_Running_State: Replica has read all relay log; waiting for more updates
           Source_Retry_Count: 10
                  Source_Bind: 
      Last_IO_Error_Timestamp: 
     Last_SQL_Error_Timestamp: 
               Source_SSL_Crl: 
           Source_SSL_Crlpath: 
           Retrieved_Gtid_Set: 
            Executed_Gtid_Set: 
                Auto_Position: 0
         Replicate_Rewrite_DB: 
                 Channel_Name: 
           Source_TLS_Version: 
       Source_public_key_path: 
        Get_Source_public_key: 1
            Network_Namespace: 
1 row in set (0.004 sec)
```


```sql
Перевірка статусу реплікації:
● Використовуйте команду SHOW SLAVE STATUS на вторинному сервері для перевірки стану
реплікації
```

```textmate
Команда застаріла в нових версіях за це відповідає SHOW REPLICA STATUS;
```


```textmate
Симуляція збою мастера:
● Симулюйте збій основного сервера та перевірте, як вторинний сервер реагує на збій.
Після відновлення основного сервера перевірте синхронізацію даних за потреби відновіть
вручну синхронізацію.
```

Master:
```textmate
hibana@mac robot_dreams_petclinic % docker stop mysql-master
mysql-master
hibana@mac robot_dreams_petclinic % docker start mysql-master
```

Slave:
```textmate
mysql> SHOW REPLICA STATUS\G
*************************** 1. row ***************************
             Replica_IO_State: Reconnecting after a failed source event read
                  Source_Host: mysql-master
                  Source_User: slave
                  Source_Port: 3306
                Connect_Retry: 60
              Source_Log_File: mysql-bin.000003
          Read_Source_Log_Pos: 2121
               Relay_Log_File: 22def9d29cbe-relay-bin.000002
                Relay_Log_Pos: 1231
        Relay_Source_Log_File: mysql-bin.000003
           Replica_IO_Running: Connecting
          Replica_SQL_Running: Yes
              Replicate_Do_DB: 
          Replicate_Ignore_DB: 
           Replicate_Do_Table: 
       Replicate_Ignore_Table: 
      Replicate_Wild_Do_Table: 
  Replicate_Wild_Ignore_Table: 
                   Last_Errno: 0
                   Last_Error: 
                 Skip_Counter: 0
          Exec_Source_Log_Pos: 2121
              Relay_Log_Space: 1449
              Until_Condition: None
               Until_Log_File: 
                Until_Log_Pos: 0
           Source_SSL_Allowed: No
           Source_SSL_CA_File: 
           Source_SSL_CA_Path: 
              Source_SSL_Cert: 
            Source_SSL_Cipher: 
               Source_SSL_Key: 
        Seconds_Behind_Source: NULL
Source_SSL_Verify_Server_Cert: No
                Last_IO_Errno: 2003
                Last_IO_Error: Error reconnecting to source 'slave@mysql-master:3306'. This was attempt 1/10, with a delay of 60 seconds between attempts. Message: Can't connect to MySQL server on 'mysql-master:3306' (111)
               Last_SQL_Errno: 0
               Last_SQL_Error: 
  Replicate_Ignore_Server_Ids: 
             Source_Server_Id: 1
                  Source_UUID: 4937988b-28b4-11f0-ba3c-0242c0a86b02
             Source_Info_File: mysql.slave_master_info
                    SQL_Delay: 0
          SQL_Remaining_Delay: NULL
    Replica_SQL_Running_State: Replica has read all relay log; waiting for more updates
           Source_Retry_Count: 10
                  Source_Bind: 
      Last_IO_Error_Timestamp: 250504 07:24:50
     Last_SQL_Error_Timestamp: 
               Source_SSL_Crl: 
           Source_SSL_Crlpath: 
           Retrieved_Gtid_Set: 
            Executed_Gtid_Set: 
                Auto_Position: 0
         Replicate_Rewrite_DB: 
                 Channel_Name: 
           Source_TLS_Version: 
       Source_public_key_path: 
        Get_Source_public_key: 1
            Network_Namespace: 
1 row in set (0.000 sec)

mysql> STOP REPLICA;
Query OK, 0 rows affected (0.018 sec)

mysql> START REPLICA;
Query OK, 0 rows affected (0.027 sec)
```

```textmate
Після виникнення проблеми між підключеннями, 
базуючись на логах конфігурації slave буде стукати до master, щодо відновлення роботи 10 * 60 (sek.) = 10 min.

Але допустим якщо ми встигнемо заемулювати ситуацію, коли реплікація буде недопуступна і додамо новий рекорд. 
Після відновлення підключення цей бракуючий елемент буде додано в репліку.
```

## Master:
```sql
mysql> use replication_master;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

mysql>  INSERT INTO users (first_name, last_name) VALUES ('disabled', 'mysql');
Query OK, 1 row affected (0.013 sec)
```

## Slave:
```sql
    mysql> SHOW REPLICA STATUS\G
    *************************** 1. row ***************************
                 Replica_IO_State: Reconnecting after a failed source event read
                      Source_Host: mysql-master
                      Source_User: slave
                      Source_Port: 3306
                    Connect_Retry: 60
                  Source_Log_File: mysql-bin.000005
              Read_Source_Log_Pos: 158
                   Relay_Log_File: 22def9d29cbe-relay-bin.000006
                    Relay_Log_Pos: 375
            Relay_Source_Log_File: mysql-bin.000005
               Replica_IO_Running: Connecting
              Replica_SQL_Running: Yes
                  Replicate_Do_DB: 
              Replicate_Ignore_DB: 
               Replicate_Do_Table: 
           Replicate_Ignore_Table: 
          Replicate_Wild_Do_Table: 
      Replicate_Wild_Ignore_Table: 
                       Last_Errno: 0
                       Last_Error: 
                     Skip_Counter: 0
              Exec_Source_Log_Pos: 158
                  Relay_Log_Space: 763
                  Until_Condition: None
                   Until_Log_File: 
                    Until_Log_Pos: 0
               Source_SSL_Allowed: No
               Source_SSL_CA_File: 
               Source_SSL_CA_Path: 
                  Source_SSL_Cert: 
                Source_SSL_Cipher: 
                   Source_SSL_Key: 
            Seconds_Behind_Source: NULL
    Source_SSL_Verify_Server_Cert: No
                    Last_IO_Errno: 2003
                    Last_IO_Error: Error reconnecting to source 'slave@mysql-master:3306'. This was attempt 1/10, with a delay of 60 seconds between attempts. Message: Can't connect to MySQL server on 'mysql-master:3306' (111)
                   Last_SQL_Errno: 0
                   Last_SQL_Error: 
      Replicate_Ignore_Server_Ids: 
                 Source_Server_Id: 1
                      Source_UUID: 4937988b-28b4-11f0-ba3c-0242c0a86b02
                 Source_Info_File: mysql.slave_master_info
                        SQL_Delay: 0
              SQL_Remaining_Delay: NULL
        Replica_SQL_Running_State: Replica has read all relay log; waiting for more updates
               Source_Retry_Count: 10
                      Source_Bind: 
          Last_IO_Error_Timestamp: 250504 07:33:32
         Last_SQL_Error_Timestamp: 
                   Source_SSL_Crl: 
               Source_SSL_Crlpath: 
               Retrieved_Gtid_Set: 
                Executed_Gtid_Set: 
                    Auto_Position: 0
             Replicate_Rewrite_DB: 
                     Channel_Name: 
               Source_TLS_Version: 
           Source_public_key_path: 
            Get_Source_public_key: 1
                Network_Namespace: 
    1 row in set (0.001 sec)
    
    mysql> SHOW REPLICA STATUS\G
    *************************** 1. row ***************************
                 Replica_IO_State: Waiting for source to send event
                      Source_Host: mysql-master
                      Source_User: slave
                      Source_Port: 3306
                    Connect_Retry: 60
                  Source_Log_File: mysql-bin.000006
              Read_Source_Log_Pos: 490
                   Relay_Log_File: 22def9d29cbe-relay-bin.000008
                    Relay_Log_Pos: 707
            Relay_Source_Log_File: mysql-bin.000006
               Replica_IO_Running: Yes
              Replica_SQL_Running: Yes
                  Replicate_Do_DB: 
              Replicate_Ignore_DB: 
               Replicate_Do_Table: 
           Replicate_Ignore_Table: 
          Replicate_Wild_Do_Table: 
      Replicate_Wild_Ignore_Table: 
                       Last_Errno: 0
                       Last_Error: 
                     Skip_Counter: 0
              Exec_Source_Log_Pos: 490
                  Relay_Log_Space: 1095
                  Until_Condition: None
                   Until_Log_File: 
                    Until_Log_Pos: 0
               Source_SSL_Allowed: No
               Source_SSL_CA_File: 
               Source_SSL_CA_Path: 
                  Source_SSL_Cert: 
                Source_SSL_Cipher: 
                   Source_SSL_Key: 
            Seconds_Behind_Source: 0
    Source_SSL_Verify_Server_Cert: No
                    Last_IO_Errno: 0
                    Last_IO_Error: 
                   Last_SQL_Errno: 0
                   Last_SQL_Error: 
      Replicate_Ignore_Server_Ids: 
                 Source_Server_Id: 1
                      Source_UUID: 4937988b-28b4-11f0-ba3c-0242c0a86b02
                 Source_Info_File: mysql.slave_master_info
                        SQL_Delay: 0
              SQL_Remaining_Delay: NULL
        Replica_SQL_Running_State: Replica has read all relay log; waiting for more updates
               Source_Retry_Count: 10
                      Source_Bind: 
          Last_IO_Error_Timestamp: 
         Last_SQL_Error_Timestamp: 
                   Source_SSL_Crl: 
               Source_SSL_Crlpath: 
               Retrieved_Gtid_Set: 
                Executed_Gtid_Set: 
                    Auto_Position: 0
             Replicate_Rewrite_DB: 
                     Channel_Name: 
               Source_TLS_Version: 
           Source_public_key_path: 
            Get_Source_public_key: 1
                Network_Namespace: 
    1 row in set (0.001 sec)
    
    mysql> use replication_master;
    Database changed
    mysql> select * from users;
    +----+------------+-----------+
    | id | first_name | last_name |
    +----+------------+-----------+
    |  1 | Thomas     | Abracham  |
    |  2 | Jack       | Black     |
    |  3 | Jason      | Tatum     |
    |  4 | disabled   | mysql     |
    +----+------------+-----------+
    4 rows in set (0.000 sec)

```