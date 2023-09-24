# Домашнее задание к занятию 2. «SQL»

## Задача 1

Используя Docker, поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose-манифест.

```
version: "3.9"


volumes:
    pg_data:
    pg_backup:

services:
  postgresql_database:
    image: postgres:12
    ports:
      - 5432:5432
    container_name: pupsik
    environment:
      POSTGRES_DB: "pat_base"
      POSTGRES_USER: "pat"
      POSTGRES_PASSWORD: "der_parol"
    volumes:
      - pg_data:/var/lib/postgresql/data/
      - pg_backup:/var/backups/pg_backup
```

## Задача 2

В БД из задачи 1: 

- создайте пользователя test-admin-user и БД test_db;
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже);
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db;
- создайте пользователя test-simple-user;
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE этих таблиц БД test_db.

Таблица orders:

- id (serial primary key);
- наименование (string);
- цена (integer).

Таблица clients:

- id (serial primary key);
- фамилия (string);
- страна проживания (string, index);
- заказ (foreign key orders).

```
postgres=# CREATE DATABASE test_db;
CREATE DATABASE
CREATE USER "test-admin-user";
CREATE ROLE

postgres=# \c test_db

test_db=# CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  Наименование VARCHAR(27),
  Цена INT
);

test_db=# CREATE TABLE clients (
  id SERIAL PRIMARY KEY,
  Фамилия VARCHAR(20),
  Страна_проживания VARCHAR(20),
  Заказ INT,
  FOREIGN KEY (Заказ) REFERENCES orders (id)
);

create country_idx on clients (Страна_проживания);

test_db=# GRANT ALL ON orders, clients TO "test-admin-user";
test_db=# CREATE USER "test-simple-user";
CREATE ROLE

test_db=# GRANT SELECT, INSERT, UPDATE, DELETE ON orders, clients TO "test-simple-user";
GRANT
```

Приведите:

- итоговый список БД после выполнения пунктов выше;

```
test_db=# \l
                             List of databases
   Name    | Owner | Encoding |  Collate   |   Ctype    | Access privileges
-----------+-------+----------+------------+------------+-------------------
 pat_base  | pat   | UTF8     | en_US.utf8 | en_US.utf8 |
 postgres  | pat   | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | pat   | UTF8     | en_US.utf8 | en_US.utf8 | =c/pat           +
           |       |          |            |            | pat=CTc/pat
 template1 | pat   | UTF8     | en_US.utf8 | en_US.utf8 | =c/pat           +
           |       |          |            |            | pat=CTc/pat
 test_db   | pat   | UTF8     | en_US.utf8 | en_US.utf8 |
(5 rows)
```

- описание таблиц (describe);

```
test_db=# \d orders
                                      Table "public.orders"
    Column    |         Type          | Collation | Nullable |              Default
--------------+-----------------------+-----------+----------+------------------------------------
 id           | integer               |           | not null | nextval('orders_id_seq'::regclass)
 наименование | character varying(25) |           |          |
 цена         | integer               |           |          |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)

test_db=# \d clients
                                         Table "public.clients"
      Column       |         Type          | Collation | Nullable |               Default
-------------------+-----------------------+-----------+----------+-------------------------------------
 id                | integer               |           | not null | nextval('clients_id_seq'::regclass)
 фамилия           | character varying(35) |           |          |
 страна_проживания | character varying(30) |           |          |
 заказ             | integer               |           |          |
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
    "country_idx" btree ("страна_проживания")
Foreign-key constraints:
    "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)
```
  
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db;

```
# SELECT * FROM information_schema.table_privileges WHERE table_name = 'clients' OR table_name = 'orders';
```

- список пользователей с правами над таблицами test_db.

```
 grantor |     grantee      | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy
---------+------------------+---------------+--------------+------------+----------------+--------------+----------------
 pat     | pat              | test_db       | public       | orders     | INSERT         | YES          | NO
 pat     | pat              | test_db       | public       | orders     | SELECT         | YES          | YES
 pat     | pat              | test_db       | public       | orders     | UPDATE         | YES          | NO
 pat     | pat              | test_db       | public       | orders     | DELETE         | YES          | NO
 pat     | pat              | test_db       | public       | orders     | TRUNCATE       | YES          | NO
 pat     | pat              | test_db       | public       | orders     | REFERENCES     | YES          | NO
 pat     | pat              | test_db       | public       | orders     | TRIGGER        | YES          | NO
 pat     | test-admin-user  | test_db       | public       | orders     | INSERT         | NO           | NO
 pat     | test-admin-user  | test_db       | public       | orders     | SELECT         | NO           | YES
 pat     | test-admin-user  | test_db       | public       | orders     | UPDATE         | NO           | NO
 pat     | test-admin-user  | test_db       | public       | orders     | DELETE         | NO           | NO
 pat     | test-admin-user  | test_db       | public       | orders     | TRUNCATE       | NO           | NO
 pat     | test-admin-user  | test_db       | public       | orders     | REFERENCES     | NO           | NO
 pat     | test-admin-user  | test_db       | public       | orders     | TRIGGER        | NO           | NO
 pat     | test-simple-user | test_db       | public       | orders     | INSERT         | NO           | NO
 pat     | test-simple-user | test_db       | public       | orders     | SELECT         | NO           | YES
 pat     | test-simple-user | test_db       | public       | orders     | UPDATE         | NO           | NO
 pat     | test-simple-user | test_db       | public       | orders     | DELETE         | NO           | NO
 pat     | pat              | test_db       | public       | clients    | INSERT         | YES          | NO
 pat     | pat              | test_db       | public       | clients    | SELECT         | YES          | YES
 pat     | pat              | test_db       | public       | clients    | UPDATE         | YES          | NO
 pat     | pat              | test_db       | public       | clients    | DELETE         | YES          | NO
 pat     | pat              | test_db       | public       | clients    | TRUNCATE       | YES          | NO
 pat     | pat              | test_db       | public       | clients    | REFERENCES     | YES          | NO
 pat     | pat              | test_db       | public       | clients    | TRIGGER        | YES          | NO
 pat     | test-admin-user  | test_db       | public       | clients    | INSERT         | NO           | NO
 pat     | test-admin-user  | test_db       | public       | clients    | SELECT         | NO           | YES
 pat     | test-admin-user  | test_db       | public       | clients    | UPDATE         | NO           | NO
 pat     | test-admin-user  | test_db       | public       | clients    | DELETE         | NO           | NO
 pat     | test-admin-user  | test_db       | public       | clients    | TRUNCATE       | NO           | NO
 pat     | test-admin-user  | test_db       | public       | clients    | REFERENCES     | NO           | NO
 pat     | test-admin-user  | test_db       | public       | clients    | TRIGGER        | NO           | NO
 pat     | test-simple-user | test_db       | public       | clients    | INSERT         | NO           | NO
 pat     | test-simple-user | test_db       | public       | clients    | SELECT         | NO           | YES
 pat     | test-simple-user | test_db       | public       | clients    | UPDATE         | NO           | NO
 pat     | test-simple-user | test_db       | public       | clients    | DELETE         | NO           | NO
(36 rows)
```

## Задача 3

Используя SQL-синтаксис, наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL-синтаксис:
- вычислите количество записей для каждой таблицы.

Приведите в ответе:

    - запросы,
    - результаты их выполнения.

```
test_db=# INSERT INTO orders (Наименование, Цена) VALUES
('Шоколад', 10),
('Принтер', 3000),
('Книга', 500),
('Монитор', 7000),
('Гитара', 4000);
INSERT 0 5

test_db=# INSERT INTO clients (Фамилия, Страна_проживания) VALUES
('Иванов Иван Иванович', 'USA'),
('Петров Петр Петрович', 'Canada'),
('Иоганн Себастьян Бах', 'Japan'),
('Ронни Джеймс Дио', 'Russia'),
('Ritchie Blackmore', 'Russia');
INSERT 0 5

test_db=# SELECT COUNT(*) FROM orders;
 count
-------
     5
(1 row)

test_db=# SELECT COUNT(*) FROM clients;
 count
-------
     5
(1 row)
```

## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys, свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения этих операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод этого запроса.
 
Подсказка: используйте директиву `UPDATE`.

```
UPDATE clients SET "Заказ" = 3 WHERE Фамилия = 'Иванов Иван Иванович';
UPDATE clients SET "Заказ" = 4 WHERE Фамилия = 'Петров Петр Петрович';
UPDATE clients SET "Заказ" = 5 WHERE Фамилия = 'Иоганн Себастьян Бах';

test_db=# SELECT * FROM clients WHERE заказ IS NOT NULL;
 id |       фамилия        | страна_проживания | заказ
----+----------------------+-------------------+-------
  1 | Иванов Иван Иванович | USA               |     3
  2 | Петров Петр Петрович | Canada            |     4
  3 | Иоганн Себастьян Бах | Japan             |     5
   
(3 rows)
```

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните, что значат полученные значения.

```
EXPLAIN SELECT * FROM clients WHERE заказ IS NOT NULL;
                       QUERY PLAN
---------------------------------------------------------
 Seq Scan on clients  (cost=0.00..1.05 rows=5 width=174)
   Filter: ("заказ" IS NOT NULL)
(2 rows)
```

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. задачу 1).

Остановите контейнер с PostgreSQL, но не удаляйте volumes.

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

```
root@89aa47cf6d89:/# pg_dumpall -U pat > /var/backups/pg_backup/backup_"`date +"%d-%m-%Y"`"

vagrant@server1:~/pg_test$ docker-compose down

vagrant@server1:~/pg_test$ docker-compose down
[+] Running 2/2
 ✔ Container pupsik         Removed                                                                                       7.3s
 ✔ Network pg_test_default  Removed                                                                                       0.2s
vagrant@server1:~/pg_test$ docker-compose ps
NAME      IMAGE     COMMAND   SERVICE   CREATED   STATUS    PORTS
vagrant@server1:~/pg_test$ docker-compose up
[+] Building 0.0s (0/0)                                                                                         docker:default
[+] Running 2/2
 ✔ Network pg_test_default  Created                                                                                       0.5s
 ✔ Container pupsik         Created                                                                                       1.1s
Attaching to pupsik

root@bdc4453ff954:/var/backups/pg_backup# psql -U pat -d pat_base

test_db=# \dl
      Large objects
 ID | Owner | Description
----+-------+-------------
(0 rows)

test_db=# \d
             List of relations
 Schema |      Name      |   Type   | Owner
--------+----------------+----------+-------
 public | clients        | table    | pat
 public | clients_id_seq | sequence | pat
 public | orders         | table    | pat
 public | orders_id_seq  | sequence | pat
(4 rows)

test_db=# \dt
        List of relations
 Schema |  Name   | Type  | Owner
--------+---------+-------+-------
 public | clients | table | pat
 public | orders  | table | pat
(2 rows)

test_db=# \d clients
                                         Table "public.clients"
      Column       |         Type          | Collation | Nullable |               Default
-------------------+-----------------------+-----------+----------+-------------------------------------
 id                | integer               |           | not null | nextval('clients_id_seq'::regclass)
 фамилия           | character varying(35) |           |          |
 страна_проживания | character varying(30) |           |          |
 заказ             | integer               |           |          |
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
    "country_idx" btree ("страна_проживания")
Foreign-key constraints:
    "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)

test_db=# \d orders
                                      Table "public.orders"
    Column    |         Type          | Collation | Nullable |              Default
--------------+-----------------------+-----------+----------+------------------------------------
 id           | integer               |           | not null | nextval('orders_id_seq'::regclass)
 наименование | character varying(25) |           |          |
 цена         | integer               |           |          |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)
```
