
# Домашнее задание к занятию 1.  «Введение в виртуализацию. Типы и функции гипервизоров. Обзор рынка вендоров и областей применения»



## Задача 1

Опишите кратко, в чём основное отличие полной (аппаратной) виртуализации, паравиртуализации и виртуализации на основе ОС.

```
Аппаратная виртуализация - гипервизор ставится непосредственно на сервер и взаимодействует с аппаратным обеспечением сервера напрямую. Гостевая ОС полностью отделяется от управления инфраструктурой хоста, она не требует никаких изменений, и не подозревает, что запущена в виртуальном окружении.
Паравиртуализация - гипервизор ставится на ОС и взаимодействует с аппаратным обеспечением сервера через прослойку ввиде ОС. Гостевая ОС модифицируется для коммуникации с гипервизором с целью улучшения производительности и эффективности работы. В ядре гостевой ОС модифицируются невиртуализуемые инструкции на гипервызовы, которые напрямую отправляются в гипервизор. 
Виртуализация на основе ОС (контейнерная виртуализация) - ядро ОС поддерживает несколько изолированных экземпляров пространства пользователя и эти экземпляры с точки зрения пользователя полностью идентичны реальному серверу.
```

## Задача 2

Выберите один из вариантов использования организации физических серверов в зависимости от условий использования.

Организация серверов:

- физические сервера,
- паравиртуализация,
- виртуализация уровня ОС.

Условия использования:

- высоконагруженная база данных, чувствительная к отказу;
- различные web-приложения;
- Windows-системы для использования бухгалтерским отделом;
- системы, выполняющие высокопроизводительные расчёты на GPU.

Опишите, почему вы выбрали к каждому целевому использованию такую организацию.

```
1. физические сервера - Высоконагруженная база данных, чувствительная к отказу; Системы, выполняющие высокопроизводительные расчеты на GPU;
Данные сервисы критичны к производительности и лучше не использовать виртуализацию, как прослойку на которую необходимо тратить ресурсы.
2. паравиртуализация - Windows системы для использования бухгалтерским отделом
Ввиду того, что системы не нагружены и их много, лучше использовать паравиртуализацию для оптимизиции ресурсов серверов.
3. виртуализация уровня ОС - Различные web-приложения
Готовая среда для приложений позволяет быстро их запускать.
```

## Задача 3

Выберите подходящую систему управления виртуализацией для предложенного сценария. Детально опишите ваш выбор.

Сценарии:

1. 100 виртуальных машин на базе Linux и Windows, общие задачи, нет особых требований. Преимущественно Windows based инфраструктура, требуется 
реализация программных балансировщиков нагрузки, репликации данных и автоматизированного механизма создания резервных копий.

```
VMWare VSphere - позволяет создавать кластера серверов для большей отказоустойчивости, имеет множество сторонних решения для бэкапа. Позволяет автоматизировать создания и обслуживание виртуальных машин.
```

2. Требуется наиболее производительное бесплатное open source решение для виртуализации небольшой (20-30 серверов) инфраструктуры на базе Linux и 
Windows виртуальных машин.

```
KVM - бесплатное решение, производительное. Есть множество систем виртуализации на базе KVM, например Proxmox. Так же есть множество инструментов для резервного копирования, либо можно написать самому и бэкапить машины через скрипты.
```

3. Необходимо бесплатное, максимально совместимое и производительное решение для виртуализации Windows инфраструктуры.

```
MS HyperV - бесплатное решение, так же при его использовании с windows инфраструктурой можно немного съэкономить на лицензиях.
```

4. Необходимо рабочее окружение для тестирования программного продукта на нескольких дистрибутивах Linux.

```
Docker - можно запустить на подавляющем большинстве дистрибутивов Linux. Сборку и развёртывание контейнеров можно автоматизировать например через docker-compose.
```
## Задача 4

Опишите возможные проблемы и недостатки гетерогенной среды виртуализации (использования нескольких систем управления виртуализацией одновременно) и что необходимо сделать для минимизации этих рисков и проблем. Если бы у вас был выбор, создавали бы вы гетерогенную среду или нет? Мотивируйте ваш ответ примерами.


```
Недостатками и возможными проблемами гетерогенной среды виртуализации считаю:

сложнее администрировать, требуется наличие более высококвалифицированных специалистов, сложнее бэкапить и увеличенная стоимость обслуживания.

если гетерогенность не необходимость, то рассмотреть возможность отказа от нее, максимальное автоматизировать развертывание и тестирование инфраструктуры, чтобы она была однородная.
На моем месте я бы скорее стремился к однотипной среде, которую легче масштабировать, обновлять, бэкапить и управлять.
```
