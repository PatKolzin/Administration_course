# Домашнее задание к занятию "5. Оркестрация кластером Docker контейнеров на примере Docker Swarm"

## Задача 1

Дайте письменые ответы на следующие вопросы:

- В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?

- 
- Какой алгоритм выбора лидера используется в Docker Swarm кластере?

- 
- Что такое Overlay Network?

- 

## Задача 2

Создать ваш первый Docker Swarm кластер в Яндекс.Облаке

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
```
docker node ls
```
![1 - docker node ls](https://github.com/PatKolzin/Administration_course/assets/75835363/fc384071-12a4-4a96-81a5-564db68c143a)



## Задача 3

Создать ваш первый, готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
```
docker service ls
```
![2 - docker service ls](https://github.com/PatKolzin/Administration_course/assets/75835363/f72b86cd-31c8-4627-a197-3c86a6864e85)



## Задача 4 (*)

Выполнить на лидере Docker Swarm кластера команду (указанную ниже) и дать письменное описание её функционала, что она делает и зачем она нужна:
```
# см.документацию: https://docs.docker.com/engine/swarm/swarm_manager_locking/
docker swarm update --autolock=true
```
![3 - docker swarm update --autolock=true](https://github.com/PatKolzin/Administration_course/assets/75835363/fc170e1e-e8f2-4933-8e9e-b02a3292895c)

Команда docker swarm update --autolock=true позволяет зашифровать ключ шифрующий логи Raft и TLS ключ используемый для шифрования коммуникаций между нодами другим ключом, для дополнительной безопасности. Соответственно при перезагрузке ноды нужно будет ввести ключ расшифровки вышеуказанных ключей для успешной работы ноды.