# Домашнее задание к занятию «Введение в Terraform»

### Задание 1

   Скачайте и установите Terraform версии =1.5.5 (версия 1.6 может вызывать проблемы с Яндекс провайдером) . Приложите скриншот вывода команды terraform --version.

   ![Снимок экрана от 2023-10-26 11-53-39](https://github.com/PatKolzin/Administration_course/assets/75835363/79fa06d7-c306-48d4-8614-f64f34672898)

1. Перейдите в каталог [**src**](https://github.com/netology-code/ter-homeworks/tree/main/01/src). Скачайте все необходимые зависимости, использованные в проекте. 
2. Изучите файл **.gitignore**. В каком terraform-файле, согласно этому .gitignore, допустимо сохранить личную, секретную информацию?
   ```
    # own secret vars store.
    personal.auto.tfvars
   ```
3. Выполните код проекта. Найдите  в state-файле секретное содержимое созданного ресурса **random_password**, пришлите в качестве ответа конкретный ключ и его значение.
   ![tfstate password](https://github.com/PatKolzin/Administration_course/assets/75835363/003c2d0c-6a36-474a-a650-d33a41d08028)
   ```
   В ключе result, значение '5Gy9UpGWdruGyOxR'
   ```

4. Раскомментируйте блок кода, примерно расположенный на строчках 29–42 файла **main.tf**.
Выполните команду ```terraform validate```. Объясните, в чём заключаются намеренно допущенные ошибки. Исправьте их.
![result - fake 1nginx](https://github.com/PatKolzin/Administration_course/assets/75835363/8bc7b2e2-6795-4efc-a2d4-c08357a5a970)

   ```
   1 лишняя в названии nginx и неправильные названия переменных - лишнее слово _FAKE и T в верхнем регистре resulT
   ```

5. Выполните код. В качестве ответа приложите: исправленный фрагмент кода и вывод команды ```docker ps```.
![docker example](https://github.com/PatKolzin/Administration_course/assets/75835363/dbe550c6-51b0-435f-aa1f-57c2f908b865)



6. Замените имя docker-контейнера в блоке кода на ```hello_world```. Не перепутайте имя контейнера и имя образа. Мы всё ещё продолжаем использовать name = "nginx:latest". Выполните команду ```terraform apply -auto-approve```.
Объясните своими словами, в чём может быть опасность применения ключа  ```-auto-approve```. В качестве ответа дополнительно приложите вывод команды ```docker ps```.
![docker hello_world](https://github.com/PatKolzin/Administration_course/assets/75835363/dcd16427-b60d-4f7a-b42c-adac58f042bd)
   ```
    Опасность применения команды ```terraform apply -auto-approve``` в том, что она начинает применять изменения без подтверждения, и можно не глядя совершить ошибочные      действия, которые приведут к сбою всей инфраструктуры.
   ```
7. Уничтожьте созданные ресурсы с помощью **terraform**. Убедитесь, что все ресурсы удалены. Приложите содержимое файла **terraform.tfstate**. 
![tfstate destroy](https://github.com/PatKolzin/Administration_course/assets/75835363/6051a13b-3f54-4beb-8f5e-d13ee274f9b6)

8. Объясните, почему при этом не был удалён docker-образ **nginx:latest**. Ответ **обязательно** подкрепите строчкой из документации [**terraform провайдера docker**](https://docs.comcloud.xyz/providers/kreuzwerker/docker/latest/docs).  (ищите в классификаторе resource docker_image )
   ![image](https://github.com/PatKolzin/Administration_course/assets/75835363/9d4fc4d7-e49c-4ad7-a243-61e87f6786d9)

   ```
   keep_locally (Boolean) If true, then the Docker image won't be deleted on destroy operation. If this is false, it will delete the image from the docker local storage on destroy operation.

   ```
------

## Дополнительное задание (со звёздочкой*)

**Настоятельно рекомендуем выполнять все задания со звёздочкой.** Они помогут глубже разобраться в материале.   
Задания со звёздочкой дополнительные, не обязательные к выполнению и никак не повлияют на получение вами зачёта по этому домашнему заданию. 

### Задание 2*

1. Изучите в документации provider [**Virtualbox**](https://docs.comcloud.xyz/providers/shekeriev/virtualbox/latest/docs) от 
shekeriev.
2. Создайте с его помощью любую виртуальную машину. Чтобы не использовать VPN, советуем выбрать любой образ с расположением в GitHub из [**списка**](https://www.vagrantbox.es/).

В качестве ответа приложите plan для создаваемого ресурса и скриншот созданного в VB ресурса. 

![Снимок экрана от 2023-10-26 12-01-38](https://github.com/PatKolzin/Administration_course/assets/75835363/c2317cca-6fe4-4984-8070-a4cb1cb4f448)

![Снимок экрана от 2023-10-26 12-04-54](https://github.com/PatKolzin/Administration_course/assets/75835363/44fd5c6e-883a-42c9-9feb-59f92ecd38e1)


На доработку работу отправят, если:

* задание выполнено частично или не выполнено вообще,
* в логике выполнения заданий есть противоречия и существенные недостатки. 
