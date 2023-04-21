# Домашнее задание к занятию «Элементы безопасности информационных систем»




### Дополнительные материалы для выполнения задания

1. [SSL + Apache2](https://digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-apache-in-ubuntu-20-04).

------

## Задание

1. Установите плагин Bitwarden для браузера. Зарегестрируйтесь и сохраните несколько паролей.

![image](https://user-images.githubusercontent.com/75835363/233698995-5771cf38-aa43-4d5d-b603-059515cb0909.png)


2. Установите Google Authenticator на мобильный телефон. Настройте вход в Bitwarden-акаунт через Google Authenticator OTP.

![image](https://user-images.githubusercontent.com/75835363/233699119-c45a76ab-91c7-4152-a3dc-7a754596a7b8.png)


3. Установите apache2, сгенерируйте самоподписанный сертификат, настройте тестовый сайт для работы по HTTPS.

![1](https://user-images.githubusercontent.com/75835363/233628469-0f361f76-fbf0-44ec-8007-1ba0fc1d64fe.png)
![4](https://user-images.githubusercontent.com/75835363/233628575-caa689f8-3b09-4d64-863e-97b7ebdb7d58.png)
![3](https://user-images.githubusercontent.com/75835363/233628584-7a47e4c3-8116-4a86-b71c-90b77c672545.png)

```
pat@Patefon:/etc/apache2/sites-available$ curl -v -k https://localhost
*   Trying 127.0.0.1:443...
* Connected to localhost (127.0.0.1) port 443 (#0)
* ALPN, offering h2
* ALPN, offering http/1.1
* TLSv1.0 (OUT), TLS header, Certificate Status (22):
* TLSv1.3 (OUT), TLS handshake, Client hello (1):
* TLSv1.2 (IN), TLS header, Certificate Status (22):
* TLSv1.3 (IN), TLS handshake, Server hello (2):
* TLSv1.2 (IN), TLS header, Finished (20):
* TLSv1.2 (IN), TLS header, Supplemental data (23):
* TLSv1.3 (IN), TLS handshake, Encrypted Extensions (8):
* TLSv1.2 (IN), TLS header, Supplemental data (23):
* TLSv1.3 (IN), TLS handshake, Certificate (11):
* TLSv1.2 (IN), TLS header, Supplemental data (23):
* TLSv1.3 (IN), TLS handshake, CERT verify (15):
* TLSv1.2 (IN), TLS header, Supplemental data (23):
* TLSv1.3 (IN), TLS handshake, Finished (20):
* TLSv1.2 (OUT), TLS header, Finished (20):
* TLSv1.3 (OUT), TLS change cipher, Change cipher spec (1):
* TLSv1.2 (OUT), TLS header, Supplemental data (23):
* TLSv1.3 (OUT), TLS handshake, Finished (20):
* SSL connection using TLSv1.3 / TLS_AES_256_GCM_SHA384
* ALPN, server accepted to use http/1.1
* Server certificate:
*  subject: C=RU; ST=Example; L=Example; O=Example Inc; OU=Example Dept; CN=devops.local; emailAddress=xxelius@gmail.com*  start date: Apr 20 13:37:48 2023 GMT
*  expire date: Apr 19 13:37:48 2024 GMT
*  issuer: C=RU; ST=Example; L=Example; O=Example Inc; OU=Example Dept; CN=devops.local; emailAddress=xxelius@gmail.com
*  SSL certificate verify result: self-signed certificate (18), continuing anyway.
* TLSv1.2 (OUT), TLS header, Supplemental data (23):
> GET / HTTP/1.1
> Host: localhost
> User-Agent: curl/7.81.0
> Accept: */*
>
* TLSv1.2 (IN), TLS header, Supplemental data (23):
* TLSv1.3 (IN), TLS handshake, Newsession Ticket (4):
* TLSv1.2 (IN), TLS header, Supplemental data (23):
* TLSv1.3 (IN), TLS handshake, Newsession Ticket (4):
* old SSL session ID is stale, removing
* TLSv1.2 (IN), TLS header, Supplemental data (23):
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Date: Fri, 21 Apr 2023 11:46:07 GMT
< Server: Apache/2.4.52 (Ubuntu)
< Last-Modified: Wed, 19 Apr 2023 13:28:02 GMT
< ETag: "14-5f9b064b22a48"
< Accept-Ranges: bytes
< Content-Length: 20
< Content-Type: text/html
<
<h1>it worked!</h1>
* Connection #0 to host localhost left intact
pat@Patefon:/etc/apache2/sites-available$
```
![image](https://user-images.githubusercontent.com/75835363/233653376-98fa554f-e34e-4242-b085-22ceb76a4be8.png)


4. Проверьте на TLS-уязвимости произвольный сайт в интернете (кроме сайтов МВД, ФСБ, МинОбр, НацБанк, РосКосмос, РосАтом, РосНАНО и любых госкомпаний, объектов КИИ, ВПК и т. п.).

![image](https://user-images.githubusercontent.com/75835363/233653512-50bb22a0-9195-411f-ad7b-e84b040a65e5.png)



5. Установите на Ubuntu SSH-сервер, сгенерируйте новый приватный ключ. Скопируйте свой публичный ключ на другой сервер. Подключитесь к серверу по SSH-ключу.
 
 Устанавливаем сервер:


*apt install openssh-server*

*systemctl start sshd.service*

*systemctl enable ssh*



Генерируем ключи:

*ssh-keygen*

 ![image](https://user-images.githubusercontent.com/75835363/233654906-4b7552fb-ee87-4540-9daa-0ee5be40e590.png)

 
6. Переименуйте файлы ключей из задания 5. Настройте файл конфигурации SSH-клиента так, чтобы вход на удалённый сервер осуществлялся по имени сервера.

![image](https://user-images.githubusercontent.com/75835363/233663370-6c3a725e-15e8-4775-8e91-f829863cff73.png)


7. Соберите дамп трафика утилитой tcpdump в формате pcap, 100 пакетов. Откройте файл pcap в Wireshark.

![Screenshot 2023-04-21 175209](https://user-images.githubusercontent.com/75835363/233692158-55539978-1688-4220-9a21-19ea53b7a4c8.png)

![image](https://user-images.githubusercontent.com/75835363/233692193-53b82cc2-e221-41b9-a8ea-19fc289fc0c0.png)


*В качестве решения приложите: скриншоты, выполняемые команды, комментарии (при необходимости).*

 ---
 
## Задание со звёздочкой* 

Это самостоятельное задание, его выполнение необязательно.

8. Просканируйте хост scanme.nmap.org. Какие сервисы запущены?

9. Установите и настройте фаервол UFW на веб-сервер из задания 3. Откройте доступ снаружи только к портам 22, 80, 443.
