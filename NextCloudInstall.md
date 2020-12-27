## Install apache and config for security...(omitted)

## Install MariaDB

`sudo apt install mariadb-server`

## Configure MariaDB

```
# https://websiteforstudents.com/setup-nextcloud-on-ubuntu-18-04-lts-beta-with-apache2-mariadb-and-php-7-1-support/
mysql_secure_installation
mysql -u root -p
CREATE USER 'nextcloud'@'localhost' IDENTIFIED BY 'PASSWORD';
CREATE DATABASE nextcloud;
GRANT ALL ON nextcloud.* TO 'nextcloud'@'localhost' IDENTIFIED BY 'PASSWORD' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EXIT;
```

## Install PHP

`sudo apt install php php-curl php-dom php-gd php-json libxml2 php-mbstring php-zip php-pdo-mysql php-bz2 php-intl php-ldap php-smbclient php-imap php-bcmath php-gmp php-apcu php-memcached php-redis`

## Follow the tutorial

https://docs.nextcloud.com/server/20/admin_manual/installation/source_installation.html#prerequisites-for-manual-installation
