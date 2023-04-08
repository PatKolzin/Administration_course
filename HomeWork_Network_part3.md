# Домашнее задание к занятию «Компьютерные сети. Лекция 3»



## Задание

1. Подключитесь к публичному маршрутизатору в интернет. Найдите маршрут к вашему публичному IP.

 ```
telnet route-views.routeviews.org
Username: rviews
show ip route x.x.x.x/32
show bgp x.x.x.x/32
```

![image](https://user-images.githubusercontent.com/75835363/230742437-c049ade4-fe4b-43b8-a815-d5183a595665.png)


2. Создайте dummy-интерфейс в Ubuntu. Добавьте несколько статических маршрутов. Проверьте таблицу маршрутизации.

![image](https://user-images.githubusercontent.com/75835363/230738520-28a6793e-9556-4da9-bb5b-c417d2066e13.png)
![image](https://user-images.githubusercontent.com/75835363/230740502-61f04746-d0f4-42c5-8299-3b4dce393c1f.png)

3. Проверьте открытые TCP-порты в Ubuntu. Какие протоколы и приложения используют эти порты? Приведите несколько примеров.

![image](https://user-images.githubusercontent.com/75835363/230740838-9b0fc060-6011-4620-ba1c-5855795be4d9.png)
![image](https://user-images.githubusercontent.com/75835363/230741024-3ec03ff0-67e3-4d78-b9ed-2c56eedee5ed.png)

4. Проверьте используемые UDP-сокеты в Ubuntu. Какие протоколы и приложения используют эти порты?

![image](https://user-images.githubusercontent.com/75835363/230741207-57e40b60-698b-4ca3-a7e7-674fdc632478.png)


5. Используя diagrams.net, создайте L3-диаграмму вашей домашней сети или любой другой сети, с которой вы работали. 

![image](https://user-images.githubusercontent.com/75835363/230742071-5510210d-be2e-484a-bfee-d9a8d4883892.png)
