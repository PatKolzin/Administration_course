# Домашнее задание к занятию 6. «Troubleshooting»

## Задача 1

Перед выполнением задания ознакомьтесь с документацией по [администрированию MongoDB](https://docs.mongodb.com/manual/administration/).

Пользователь (разработчик) написал в канал поддержки, что у него уже 3 минуты происходит CRUD-операция в MongoDB и её 
нужно прервать. 

Вы как инженер поддержки решили произвести эту операцию:

## Ответ

- напишите список операций, которые вы будете производить для остановки запроса пользователя
  
1) Узнать под каким пользователем выполняется операция
2) Завершить пользовательскую операцию - ```db.killOp(opid)```

- предложите вариант решения проблемы с долгими (зависающими) запросами в MongoDB

  Можно включить профилирование для поиска медленных запросов.
  Использовать метод .explain("executionStats") на запросе, проанализировать вывод, добавить/изменить индекс и добиться улучшение производительности.
  Использовать метод .maxTimeMS(<time limit>) на запросе, чтобы автоматически завершать его через определенное время. 

## Задача 2

Перед выполнением задания познакомьтесь с документацией по [Redis latency troobleshooting](https://redis.io/topics/latency).

Вы запустили инстанс Redis для использования совместно с сервисом, который использует механизм TTL. 
Причём отношение количества записанных key-value-значений к количеству истёкших значений есть величина постоянная и
увеличивается пропорционально количеству реплик сервиса. 

При масштабировании сервиса до N реплик вы увидели, что:

- сначала происходит рост отношения записанных значений к истекшим,
- Redis блокирует операции записи.

## Ответ

Как вы думаете, в чём может быть проблема?

 Вероятно проблема в истекшем TTL. Так как Redis чистит ключи каждые 100мс но не более 20 за раз и он блокируется на момент чистки, если в БД более 25% истекших ключей.
 
## Задача 3

Вы подняли базу данных MySQL для использования в гис-системе. При росте количества записей в таблицах базы
пользователи начали жаловаться на ошибки вида:
```python
InterfaceError: (InterfaceError) 2013: Lost connection to MySQL server during query u'SELECT..... '
```

Как вы думаете, почему это начало происходить и как локализовать проблему?

Какие пути решения этой проблемы вы можете предложить?

## Ответ

Судя по официальной документации - https://dev.mysql.com/doc/refman/8.0/en/error-lost-connection.html

Нужно увеличить значения некоторых параметрамов сервера: ```net_read_timeout```, ```connect_timeout```, ```max_allowed_packet```. 
Возможно увеличить ```max_connections```.

## Задача 4


Вы решили перевести гис-систему из задачи 3 на PostgreSQL, так как прочитали в документации, что эта СУБД работает с 
большим объёмом данных лучше, чем MySQL.

После запуска пользователи начали жаловаться, что СУБД время от времени становится недоступной. В dmesg вы видите, что:

`postmaster invoked oom-killer`

## Ответ

Как вы думаете, что происходит?

Процесс Out-Of-Memory Killer завершил процесс PostgreSQL, чтобы исключить авариайное завершение ОС из-за нехватки оперативной памяти на сервере.

Как бы вы решили данную проблему?

Настроить параметры в конфигурации отвечающие за использование ОЗУ, типа "effective_cache_size", "shared_buffers" для оптимизации использования ОЗУ.
Либо увеличить количество оперативной памяти сервера.

---

