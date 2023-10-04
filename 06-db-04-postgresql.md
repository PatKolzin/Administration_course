# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
- подключения к БД
- вывода списка таблиц
- вывода описания содержимого таблиц
- выхода из psql

## Ответ

```commandline
version: '3.7'
services:
  postgres_db_container:
    image: postgres:13
    container_name: pg6.4
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: pat
    ports:
      - 5432:5432
    volumes:
      - postgres_db_data_container:/var/lib/postgresql/data
  adminer_container:
    image: adminer:latest
    environment:
      ADMINER_DEFAULT_SERVER: mysql_db_container
    ports:
      - 8080:8080

volumes:
  postgres_db_data_container:
```
**Найдите и приведите** управляющие команды для:
- вывода списка БД
```commandline
postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
(3 rows)
```
- подключения к БД
```commandline
\c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}
                         connect to new database (currently "postgres")
```
- вывода списка таблиц
```commandline
\dt[S+] [PATTERN]      list tables
```
- вывода описания содержимого таблиц
```commandline
 \d[S+]                 list tables, views, and sequences
```
- выхода из psql
```commandline
\q                     quit psql
```

## Задача 2

Используя `psql` создайте БД `test_database`.

```bash
postgres=# CREATE DATABASE test_database;
CREATE DATABASE
```

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).


Восстановите бэкап БД в `test_database`.


```bash
postgres=# \q
/ # psql -U postgres -f /var/lib/postgresql/backup/test_dump.sql test_database
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval 
--------
      8
(1 row)

ALTER TABLE

~ $ psql postgresql://postgres:pgpwd4test@localhost:5432
psql (13.6)
Type "help" for help.
postgres=# \l
                                   List of databases
     Name      |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
---------------+----------+----------+------------+------------+-----------------------
 postgres      | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0     | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
               |          |          |            |            | postgres=CTc/postgres
 template1     | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
               |          |          |            |            | postgres=CTc/postgres
 test_database | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
(4 rows)

```


Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

```bash
postgres=# \c test_database 
You are now connected to database "test_database" as user "postgres".
test_database=# \dt+
                              List of relations
 Schema |  Name  | Type  |  Owner   | Persistence |    Size    | Description 
--------+--------+-------+----------+-------------+------------+-------------
 public | orders | table | postgres | permanent   | 8192 bytes | 
(1 row)

test_database=# ANALYZE VERBOSE public.orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 8 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE

```

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

```
avg_width	integer	 	Средний размер элементов в столбце, в байтах
```
**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

```bash
test_database=# select avg_width, attname from pg_stats where tablename='orders' order by avg_width desc;
 avg_width | attname 
-----------+---------
        16 | title
         4 | id
         4 | price
(3 rows)

```

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

[Секционирование таблиц](https://postgrespro.ru/docs/postgresql/13/ddl-partitioning)

Предложите SQL-транзакцию для проведения данной операции.

По условиям граница orders_1 начинается со значения большего чем 499 по этой причине начальное value from будет 500
для секции orders_2 значения должны быть меньше или раывно 499 по этой причине последнее значение бужет равно 500,
верхние и нижние границы 

```bash
test_database=# create table orders (id integer not null,title character varying(80) not null,price integer default 0) partition by range (price); 
CREATE TABLE
test_database=# create table orders_2 partition of orders for values from (0) to (500);
CREATE TABLE
test_database=# create table orders_1 partition of orders for values from (500) to (1000);
CREATE TABLE
test_database=# insert into orders (id, title, price) select * from orders_old;
INSERT 0 8
test_database=# select * from orders_1;
 id |       title        | price 
----+--------------------+-------
  2 | My little database |   500
  6 | WAL never lies     |   900
  8 | Dbiezdmin          |   501
(3 rows)
test_database=# select * from orders_2;
 id |        title         | price 
----+----------------------+-------
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  7 | Me and my bash-pet   |   499
(5 rows)
test_database=# select * from orders;
 id |        title         | price 
----+----------------------+-------
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  7 | Me and my bash-pet   |   499
  2 | My little database   |   500
  6 | WAL never lies       |   900
  8 | Dbiezdmin            |   501
(8 rows)
test_database=# select * from orders_old ;
 id |        title         | price 
----+----------------------+-------
  1 | War and peace        |   100
  2 | My little database   |   500
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  6 | WAL never lies       |   900
  7 | Me and my bash-pet   |   499
  8 | Dbiezdmin            |   501
(8 rows)

```

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

Ответ: "ручного" разбиения можно было избежать при проектировании таблицы путём введения секционирования до внесения данных в таблицу.

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

что бы добавить уникальность значений в секционированнных таблицах необходимо добавить после создания секции соответсвующие констрэйт:

```
alter table orders_1 add constraint orders_1_title_unique unique (title);

alter table orders_2 add constraint orders_2_title_unique unique (title);
```

---
