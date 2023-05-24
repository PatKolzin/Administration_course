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

```import socket
import time
import json
import yaml

serv = {'drive.google.com': '0.0.0.0', 'mail.google.com': '0.0.0.0', 'google.com': '0.0.0.0'}


while 1==1 :

    for host in serv:
        time.sleep(1)
        ip = socket.gethostbyname(host)
        data = [{host : ip}]
        if ip != serv[host]:
            print(' [ERROR] ' + str(host) +' IP mistmatch: '+serv[host]+' '+ip)
        else:
           print(str(host) + ' ' + ip)

        with open(host+'.json', 'w') as json_file:
             json_file.write(str(data))
        with open(host+'.yaml', 'w') as yaml_file:
             yaml_file.write(yaml.dump(data, indent=2, explicit_start=True, explicit_end=True))
        serv[host]=ip


```

### Вывод скрипта при запуске во время тестирования:

![image](https://github.com/PatKolzin/Administration_course/assets/75835363/ba059c07-fc63-4297-b0c8-5a509bc62f33)


### JSON-файл(ы), который(е) записал ваш скрипт:

![image](https://github.com/PatKolzin/Administration_course/assets/75835363/83d32c96-2bdc-4741-be7a-accfabd34f35)

### YAML-файл(ы), который(е) записал ваш скрипт:

![image](https://github.com/PatKolzin/Administration_course/assets/75835363/6812a3f9-02a2-4f51-a16e-a95ed1129398)

---
