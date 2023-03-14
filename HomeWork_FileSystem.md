# Домашнее задание к занятию «Файловые системы»



1. Узнайте о [sparse-файлах](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B6%D1%91%D0%BD%D0%BD%D1%8B%D0%B9_%D1%84%D0%B0%D0%B9%D0%BB) (разряженных).

Готово.

2. Могут ли файлы, являющиеся жёсткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?

Не могут. 
В Linux каждый файл имеет уникальный идентификатор - индексный дескриптор (inode). Это число, которое однозначно идентифицирует файл в файловой системе. Жесткая ссылка и файл, для которой она создавалась имеют одинаковые inode. Поэтому жесткая ссылка имеет те же права доступа, владельца и время последней модификации, что и целевой файл. Различаются только имена файлов. Фактически жесткая ссылка это еще одно имя для файла.

3. Сделайте `vagrant destroy` на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:

    ```ruby
    path_to_disk_folder = './disks'
    host_params = {
        'disk_size' => 2560,
        'disks'=>[1, 2],
        'cpus'=>2,
        'memory'=>2048,
        'hostname'=>'sysadm-fs',
        'vm_name'=>'sysadm-fs'
    }
    Vagrant.configure("2") do |config|
        config.vm.box = "bento/ubuntu-20.04"
        config.vm.hostname=host_params['hostname']
        config.vm.provider :virtualbox do |v|
            v.name=host_params['vm_name']
            v.cpus=host_params['cpus']
            v.memory=host_params['memory']
            host_params['disks'].each do |disk|
                file_to_disk=path_to_disk_folder+'/disk'+disk.to_s+'.vdi'
                unless File.exist?(file_to_disk)
                    v.customize ['createmedium', '--filename', file_to_disk, '--size', host_params['disk_size']]
                end
                v.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', disk.to_s, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
            end
        end
        config.vm.network "private_network", type: "dhcp"
    end
    ```

    Эта конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2,5 Гб.

4. Используя `fdisk`, разбейте первый диск на два раздела: 2 Гб и оставшееся пространство.

![2](https://user-images.githubusercontent.com/75835363/224944740-530b87b2-906f-4819-8acb-2bd2cff8fbf0.png)


5. Используя `sfdisk`, перенесите эту таблицу разделов на второй диск.

![3](https://user-images.githubusercontent.com/75835363/224944765-a61056fd-778e-46c3-be81-769b8e913d89.png)


6. Соберите `mdadm` RAID1 на паре разделов 2 Гб.

![4](https://user-images.githubusercontent.com/75835363/224944776-8ac5438f-d0fb-4b6d-aa90-d94bac1fd0a4.png)

7. Соберите `mdadm` RAID0 на второй паре маленьких разделов.

![5](https://user-images.githubusercontent.com/75835363/224945226-aef19ef6-9c14-4924-b3de-43c2cde14b56.png)

8. Создайте два независимых PV на получившихся md-устройствах.

![image](https://user-images.githubusercontent.com/75835363/224945644-c26e2015-3e5e-4f3b-9c53-8b5f55a10be5.png)

9. Создайте общую volume-group на этих двух PV.

![7](https://user-images.githubusercontent.com/75835363/224945789-8a0f167c-b55e-48b7-81ff-6a105529e887.png)

10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.

```lvcreate -L 100MB -n data vg1 /dev/md1```

11. Создайте `mkfs.ext4` ФС на получившемся LV.

![8](https://user-images.githubusercontent.com/75835363/224945884-275d964c-ea5e-4eb9-a9f3-ebefa1bdd5d3.png)

12. Смонтируйте этот раздел в любую директорию, например, `/tmp/new`.

```mkdir /tmp/new && mount -t ext4 /dev/vg1/data /tmp/new/```

13. Поместите туда тестовый файл, например, `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`.

*Готово.*

14. Прикрепите вывод `lsblk`.

![9](https://user-images.githubusercontent.com/75835363/224946553-584e9fed-fd5d-463e-a2fd-35424933437e.png)

15. Протестируйте целостность файла:

    ```bash
    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0
    ```
*Готово.*

16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.

![10](https://user-images.githubusercontent.com/75835363/224946709-d9126265-5c91-4aae-8540-5a9055bbcc35.png)

17. Сделайте `--fail` на устройство в вашем RAID1 md.

![11](https://user-images.githubusercontent.com/75835363/224946769-31bdeb8a-78f9-43f5-9803-c5da3428578b.png)

18. Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии.

![12](https://user-images.githubusercontent.com/75835363/224946818-a880061b-d829-4b06-b12e-aeea95aadd94.png)

19. Протестируйте целостность файла — он должен быть доступен несмотря на «сбойный» диск:

    ```bash
    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0
    ```
![13](https://user-images.githubusercontent.com/75835363/224946867-5393487b-4e37-4df6-9fa1-eeab8e9b0ad5.png)

20. Погасите тестовый хост — `vagrant destroy`.
 
 Готово.
