# Домашнее задание к занятию «Использование Python для решения типовых DevOps-задач»

## Задание 1

Есть скрипт:

```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:

| Вопрос  | Ответ |
| ------------- | ------------- |
| Какое значение будет присвоено переменной `c`?  | Разные типы переменных нельзя сложить - TypeError: unsupported operand type(s) for +: 'int' and 'str'  |
| Как получить для переменной `c` значение 12?  | с = str(a) + b  |
| Как получить для переменной `c` значение 3?  | c = int(b) + a |

------

## Задание 2

Мы устроились на работу в компанию, где раньше уже был DevOps-инженер. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. 

Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()

is_change = False

for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/gitkolzin/devops-netology/", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()

for result in result_os.split('\n'):
        if result.find('modified') != -1:
            prepare_result = result.replace('\tmodified:   ', '')
            print(os.getcwd(), '/', prepare_result, sep='')
```

### Вывод скрипта при запуске во время тестирования:


![image](https://github.com/PatKolzin/Administration_course/assets/75835363/52da27cd-5831-4ec9-9ad7-0c40da27e818)


------

## Задание 3

Доработать скрипт выше так, чтобы он не только мог проверять локальный репозиторий в текущей директории, но и умел воспринимать путь к репозиторию, который мы передаём, как входной параметр. Мы точно знаем, что начальство будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:

```#!/usr/bin/env python3

import os, sys

argument = sys.argv

#test input argument
if len(argument) == 1:
    print('Введите путь к репозиторию, будьте добры:')
    way = input()
else:
    way = sys.argv[1]


bash_command = [f'cd {way}', "git status"]
result_os = os.popen(' && '.join(bash_command)).read()

print('Измененные файлы:')
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(os.getcwd(), '/', prepare_result, sep='')
```

### Вывод скрипта при запуске во время тестирования:

![image](https://github.com/PatKolzin/Administration_course/assets/75835363/9f585e54-5e4b-4c1e-a90f-ceb2f593e687)

------

## Задание 4

Наша команда разрабатывает несколько веб-сервисов, доступных по HTTPS. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. 

Проблема в том, что отдел, занимающийся нашей инфраструктурой, очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS-имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. 

Мы хотим написать скрипт, который: 

- опрашивает веб-сервисы; 
- получает их IP; 
- выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. 

Также должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена — оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт:

```#!/usr/bin/env python3

import socket
import time

dns_list = ['drive.google.com', 'mail.google.com', 'google.com']
ip_list = [None, None, None]

while True:

    for i in range(0, len(dns_list)):
        time.sleep(1)
        ip = socket.gethostbyname(dns_list[i])
        print(dns_list[i] + ' -> ' + ip)
        if ip_list[i] is None:
            ip_list[i] = ip
        elif ip_list[i] != ip:
            print(dns_list[i] + ' IP changed from: ' + ip_list[i] + ' to: ' + ip)

```

### Вывод скрипта при запуске во время тестирования:
![image](https://github.com/PatKolzin/Administration_course/assets/75835363/11830a7f-d87d-4b25-82c8-75065fe3f921)

![image](https://github.com/PatKolzin/Administration_course/assets/75835363/68825a70-4ed3-4d8b-92aa-d8a6885872bc)


------


