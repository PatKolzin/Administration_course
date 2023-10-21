## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ `elasticsearch` на запрос пути `/` в json виде

Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.

### Ответ

- Подготовил [Dockerfile](06-db-05-elasticsearch/Dockerfile) и конфигурационные файлы [elasticsearch.yml](06-db-05-elasticsearch/elasticsearch.yml), [logging.yml](06-db-05-elasticsearch/logging.yml)
- Собрал образ
    ```commandline
    vagrant@server1:~/elk$ DOCKER_BUILDKIT=0 docker build -t patkolzin/elasticsearch:8.8.1 . 
    ```
- При запуске вылетала ошибка `max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]`, выполнил команду
    ```commandline
    sysctl -w vm.max_map_count=262144 
    ```
- Запустил образ
    ```commandline
   vagrant@server1:~/elk$ docker run -d -p 9200:9200 patkolzin/elasticsearch:8.8.1 
    ```
- Ответ `elasticsearch` на запрос пути `/` 
    ```commandline
    {
      "name" : "netology_test",
      "cluster_name" : "netology",
      "cluster_uuid" : "bUVxq4WdTryk8XnX60MKGQ",
      "version" : {
        "number" : "8.8.1",
        "build_flavor" : "default",
        "build_type" : "tar",
        "build_hash" : "f8edfccba429b6477927a7c1ce1bc6729521305e",
        "build_date" : "2023-06-05T21:32:25.188464208Z",
        "build_snapshot" : false,
        "lucene_version" : "9.6.0",
        "minimum_wire_compatibility_version" : "7.17.0",
        "minimum_index_compatibility_version" : "7.0.0"
      },
      "tagline" : "You Know, for Search"
    }
    ```

    ![image](https://github.com/PatKolzin/Administration_course/assets/75835363/960fe4c6-9ffc-4b99-9a54-89b3289a6063)

- Загрузил образ в свой docker.io репозиторий [ссылка](https://hub.docker.com/repository/docker/patkolzin/elasticsearch/general)
    ```commandline
      vagrant@server1:~/elk$ docker push patkolzin/elasticsearch:8.8.1
    ```
## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

Получите состояние кластера `elasticsearch`, используя API.

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Удалите все индексы.

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

## Ответ

добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:
```commandline
curl -X PUT localhost:9200/ind-1 -H 'Content-Type: application/json' -d '
> {
> "settings": {
> "index": {
> "number_of_replicas": 0,
> "number_of_shards": 1
> }
> }
> }'

curl -X PUT localhost:9200/ind-2 -H 'Content-Type: application/json' -d '
> {
> "settings": {
> "index": {
> "number_of_replicas": 1,
> "number_of_shards": 2
> }
> }
> }'

curl -X PUT localhost:9200/ind-3 -H 'Content-Type: application/json' -d '
> {
> "settings": {
> "index": {
> "number_of_replicas": 2,
> "number_of_shards": 4
> }
> }
> }'
```
Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.
```commandline
curl http://localhost:9200/_cat/indices
green  open ind-1  -q_Dzf6iQpiNcduf2-XMLw 1 0 0 0 225b 225b
yellow open ind-3  3Gu5fHxYQWWpVwupl0o0iQ 4 2 0 0 413b 413b
yellow open ind-2  pV3rXA00QfyeHLd5Nt9Nxw 2 1 0 0 450b 450b
```
Получите состояние кластера `elasticsearch`, используя API.
```commandline
curl -X GET 'localhost:9200/_cluster/health?&pretty'
{
  "cluster_name" : "netology",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 9,
  "active_shards" : 9,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 11,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 45.0
}
```
Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

- Так как в кластере одна нода, на которой располагаются шарды, остальным репликам негде разместиться.


Удалите все индексы.
```commandline
curl -X DELETE http://localhost:9200/ind-1
curl -X DELETE http://localhost:9200/ind-2
curl -X DELETE http://localhost:9200/ind-3
```
## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`ами.

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

---

## Ответ

Добавляем в Dockerfile: 
```commandline
mkdir /elasticsearch-8.8.1/snapshots;
```
и elasticsearch.yml:
```commandline
path.repo: /elasticsearch-8.8.1/snapshots
```

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.
```commandline
curl -X PUT "localhost:9200/_snapshot/netology_backup?pretty" -H 'Content-Type: application/json' -d'
{
  "type": "fs",
  "settings": {
    "location": "/elasticsearch-8.8.1/snapshots"
  }
}
'
{
  "acknowledged" : true
}
```
Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.
```commandline
curl -X PUT "localhost:9200/test?pretty" -H 'Content-Type: application/json' -d'
> {
>   "settings": {
>     "index": {
>       "number_of_shards": 1,
>       "number_of_replicas": 0
>     }
>   }
> }
> '
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test"
}
```
[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.
```commandline
curl -X PUT "localhost:9200/_snapshot/netology_backup/my_snapshot?wait_for_completion=true&pretty"
{
  "snapshot" : {
    "snapshot" : "my_snapshot",
    "uuid" : "zFThrYYyTOmhh3_JdBIxUQ",
    "repository" : "netology_backup",
    "version_id" : 8080199,
    "version" : "8.8.1",
    "indices" : [
      "test-2",
      "test"
    ],
    "data_streams" : [ ],
    "include_global_state" : true,
    "state" : "SUCCESS",
    "start_time" : "2023-10-21T14:50:34.811Z",
    "start_time_in_millis" : 1697899834811,
    "end_time" : "2023-10-21T14:50:35.012Z",
    "end_time_in_millis" : 1697899835012,
    "duration_in_millis" : 201,
    "failures" : [ ],
    "shards" : {
      "total" : 2,
      "failed" : 0,
      "successful" : 2
    },
    "feature_states" : [ ]
  }
}
```
**Приведите в ответе** список файлов в директории со `snapshot`ами.
```commandline
docker exec -ti elastic bash
[elasticsearch@2f8f3dbf68bb elasticsearch-8.8.1]$ ll ./snapshots/snapshot_repository/
total 36
-rw-r--r-- 1 elasticsearch elasticsearch   587 Oct 20 22:00 index-0
-rw-r--r-- 1 elasticsearch elasticsearch     8 Oct 20 22:00 index.latest
drwxr-xr-x 3 elasticsearch elasticsearch  4096 Oct 20 22:00 indices
-rw-r--r-- 1 elasticsearch elasticsearch 19514 Oct 20 22:00 meta-Ly9LxN6XSdSHQiZljnja4A.dat
-rw-r--r-- 1 elasticsearch elasticsearch   304 Oct 20 22:00 snap-Ly9LxN6XSdSHQiZljnja4A.dat
```
Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.
```commandline
curl -X DELETE localhost:9200/test

curl -X PUT localhost:9200/test-2 -H 'Content-Type: application/json' -d '
{
"settings": {
"index": {
"number_of_replicas": 0,
"number_of_shards": 1
}
}
}'
```
[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 
```commandline
curl -X POST localhost:9200/_snapshot/netology_backup/my_snapshot/_restore?pretty -H 'Content-Type: application/json' -d'
> {"include_global_state":true}
> '
{
  "accepted" : true
```
**Приведите в ответе** запрос к API восстановления и итоговый список индексов.
```commandline
curl -X GET localhost:9200/_cat/indices?pretty
yellow open test-2 9pLrWTrvQYipMB7vUdJ8Dw 1 1 0 0 247b 247b
green  open test   JGry5uuEScuR1HV051WiWQ 1 0 0 0 247b 247b
```

