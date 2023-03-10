## Задание

***1. На лекции вы познакомились с [node_exporter](https://github.com/prometheus/node_exporter/releases). В демонстрации его исполняемый файл запускался в background. Этого достаточно для демо, но не для настоящей production-системы, где процессы должны находиться под внешним управлением. Используя знания из лекции по systemd, создайте самостоятельно простой [unit-файл](https://www.freedesktop.org/software/systemd/man/systemd.service.html) для node_exporter:***

* поместите его в автозагрузку;
* предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например, на `systemctl cat cron`);
* удостоверьтесь, что с помощью systemctl процесс корректно стартует, завершается, а после перезагрузки автоматически поднимается.

На странице копируем путь для скачивания актуальной версии node_exporter и распаковываем его:

`pat@Patefon:~$ wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz`

`pat@Patefon:~$ tar xvfz node_exporter-1.5.0.linux-amd64.tar.gz`

Для запуска демона node_exporter создадим системного пользователя node_exporter:

`pat@Patefon:~$ useradd --no-create-home --shell /bin/false nodeusr`

*Создадим новый unit-файл и настроим его для node_exporter:*

![1](https://user-images.githubusercontent.com/75835363/224321985-dd64a05b-a066-44e7-ad53-abc033005c7b.png)

![2](https://user-images.githubusercontent.com/75835363/224323000-b174e525-3bca-4dfa-b388-fd0252c30355.png)

*Добавим опции к запускаемому процессу через внешний файл*

![3](https://user-images.githubusercontent.com/75835363/224323899-67753f9b-43c6-4442-9da7-c346deb48ab0.png)
![4](https://user-images.githubusercontent.com/75835363/224323932-a815598d-8694-4349-9ab8-1efb747d7dd2.png)

Далее перечитываем директорию с юнит-файлами `systemctl daemon-reload`. Перед запуском сервиса необходимо проверить, что исполняемый файл лежит тут `/usr/bin/node_exporter` и файл конфигурации тут `/etc/default/node_exporter`. Запускаем сервис `systemctl start node_exporter` и добавляем сервис в автозагрузку при старте системы `systemctl enable node_exporter`.

*Проверяем статус сервиса node_exporter:*

![5](https://user-images.githubusercontent.com/75835363/224324644-ae2767a3-26c2-4194-95e4-ca3d5bfdd0b5.png)

Для проверки работы сервиса перезагрузил машину командой `sudo reboot`. После перезагрузки сервис *node_exporter* был в статусе *active*.




***2. Изучите опции node_exporter и вывод `/metrics` по умолчанию. Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.***

```
--collector.disable-defaults
--collector.cpu
--collector.cpufreq
--collector.meminfo
--collector.diskstats
--collector.netstat
```


***3. Установите в свою виртуальную машину [Netdata](https://github.com/netdata/netdata). Воспользуйтесь [готовыми пакетами](https://packagecloud.io/netdata/netdata/install) для установки (`sudo apt install -y netdata`).***
   ***После успешной перезагрузки в браузере на своём ПК (не в виртуальной машине) вы должны суметь зайти на localhost:19999. Ознакомьтесь с метриками, которые по умолчанию собираются Netdata, и с комментариями, которые даны к этим метрикам.***
   
![image](https://user-images.githubusercontent.com/75835363/224336428-faadf32b-455c-456d-9226-8f5246a35dd4.png)

***4. Можно ли по выводу `dmesg` понять, осознаёт ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?***

![image](https://user-images.githubusercontent.com/75835363/224339728-16336654-9b88-44fa-9d23-1b504a3b07a7.png)
Можно, по сообщению `*Hypervisor detected`

***5. Как настроен sysctl `fs.nr_open` на системе по умолчанию? Определите, что означает этот параметр. Какой другой существующий лимит не позволит достичь такого числа (`ulimit --help`)?***

![image](https://user-images.githubusercontent.com/75835363/224407844-3470ddf9-f819-440a-8a5d-27ee98b03cf7.png)

*`fs.nr_open` устанавливает системное ограничение на максимальное число открываемых файлов.*

*команды `ulimit -Sn` и `ulimit -Hn` отображают soft ограничение (который вызывает ограничение) и hard ограничение.*

***6. Запустите любой долгоживущий процесс (не `ls`, который отработает мгновенно, а, например, `sleep 1h`) в отдельном неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через `nsenter`. Для простоты работайте в этом задании под root (`sudo -i`). Под обычным пользователем требуются дополнительные опции (`--map-root-user`) и т. д.***

![image](https://user-images.githubusercontent.com/75835363/224431078-1a74733c-4074-4c74-a2a3-13107d9c183c.png)
![image](https://user-images.githubusercontent.com/75835363/224431151-d0c9aac0-e75c-4ce6-a750-2cc0388aeff4.png)


***7. Найдите информацию о том, что такое `:(){ :|:& };:`. Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04*** (**это важно, поведение в других ОС не проверялось**). ***Некоторое время всё будет плохо, после чего (спустя минуты) — ОС должна стабилизироваться. Вызов `dmesg` расскажет, какой механизм помог автоматической стабилизации.***
***Как настроен этот механизм по умолчанию, и как изменить число процессов, которое можно создать в сессии?***

Так называемая *fork bomb* функция, которая параллельно пускает два своих экземпляра. Каждый пускает ещё по два и т.д.

![image](https://user-images.githubusercontent.com/75835363/224436230-5ed07fde-20de-4119-8575-2cb20a663e28.png)
*Работу форкбомбы прервал Process Number Controller*

![image](https://user-images.githubusercontent.com/75835363/224437627-6a7bdbf6-8267-4e96-baf5-22e0b3589476.png)

*Максимальное количество процессов для пользователя можно изменить командой `ulimit -u <число>` или в файле `cat etc/security/limits.conf`*




