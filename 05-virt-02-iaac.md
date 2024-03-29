
# Домашнее задание к занятию 2. «Применение принципов IaaC в работе с виртуальными машинами»


## Задача 1

- Опишите основные преимущества применения на практике IaaC-паттернов.

```
Непрерывная интеграция - CI - позволяет быстро находить ошибки в коде за счет постоянного тестирования небольшими объемами.

Непрерывная доставка - CD - позволяет легко исправить или откатиться на недавнее состояние в случае ошибок.

Непрерывное развёртывание - CD - упраздняет ручные действия, не требуя непосредственного утверждения со стороны ответственного лица.
```

- Какой из принципов IaaC является основополагающим?

```
Основопологающим принципом IaaC является идемпотентность - свойство повторять одни и те же действия безошибочно.
```



## Задача 2

- Чем Ansible выгодно отличается от других систем управление конфигурациями?

```
Ansible можно использовать без установки специального ПО на целевом хосте. Ansible работает по SSH, на распространенном языке Python. Также может оповестить о неудачной доставке конфигурации на сервер.
```

- Какой, на ваш взгляд, метод работы систем конфигурации более надёжный — push или pull?
```
На мой взгляд более надёжный push - так как он позволяет определить когда, куда, а также какую конфигурацию отправить, позволяет проконтролировать результат применения на ошибки.
```
## Задача 3

Установите на личный компьютер:

- [VirtualBox](https://www.virtualbox.org/),
- [Vagrant](https://github.com/netology-code/devops-materials),
- [Terraform](https://github.com/netology-code/devops-materials/blob/master/README.md),
- Ansible.

*Приложите вывод команд установленных версий каждой из программ, оформленный в Markdown.*

![Screenshot from 2023-05-31 11-43-29](https://github.com/PatKolzin/Administration_course/assets/75835363/66553490-f384-475f-897a-9e485a8c8635)



## Задача 4 

Воспроизведите практическую часть лекции самостоятельно.

- Создайте виртуальную машину.
- Зайдите внутрь ВМ, убедитесь, что Docker установлен с помощью команды
```
docker ps,
```

![Screenshot from 2023-05-31 10-39-27](https://github.com/PatKolzin/Administration_course/assets/75835363/d9e20844-c403-4112-b210-728d6b9739c4)


