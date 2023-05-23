# Домашнее задание к занятию «Языки разметки JSON и YAML»


## Задание 1

Мы выгрузили JSON, который получили через API-запрос к нашему сервису:

```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис.

### Ваш скрипт:

```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            },
            { "name" : "second",
            "type" : "proxy",
            "ip" : 71.78.22.43
            }
        ]
    }
```

---

## Задание 2

В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML-файлов, описывающих наши сервисы. 

Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. 

Формат записи YAML по одному сервису: `- имя сервиса: его IP`. 

Если в момент исполнения скрипта меняется IP у сервиса — он должен так же поменяться в YAML и JSON-файле.

### Ваш скрипт:

```##!/usr/bin/env python3

import socket as s
import time as t
import datetime as dt
import json
import yaml

# VARS
wait = 2 # интервал проверок в секундах
serv = {'drive.google.com':'0.0.0.0', 'mail.google.com':'0.0.0.0', 'google.com':'0.0.0.0'}

print('*** start ***')
print(serv)
print('********************')

while 1==1 : # бесконечный цикл
  for host in serv:
    ip = s.gethostbyname(host)
    data = [{host : ip}]
    if ip != serv[host]:
      print(str(dt.datetime.now().strftime("%Y-%m-%d %H:%M:%S")) +' [ERROR] ' + str(host) +' IP mistmatch: '+serv[host]+' '+ip)
# json
      with open(host+".json",'w') as jsonfile: 
          json_data=json.dump(data,jsonfile)
# yaml
      with open(host+".yaml",'w') as yamlfile:
          yaml_data= yaml.dump(data,yamlfile)  
      serv[host]=ip
  t.sleep(wait)


```

### Вывод скрипта при запуске во время тестирования:



### JSON-файл(ы), который(е) записал ваш скрипт:

```json
???
```

### YAML-файл(ы), который(е) записал ваш скрипт:

```yaml
???
```

---
