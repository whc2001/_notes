https://github.com/mhubig/docker-partkeepr

## 国内源

https://mirrors.tuna.tsinghua.edu.cn/help/docker-ce/

https://yeasy.gitbook.io/docker_practice/install/mirror

## Docker

```
export PARTKEEPR_AUTHENTICATION_PROVIDER="PartKeepr.Auth.HTTPBasicAuthenticationProvider"
export PARTKEEPR_DATABASE_PASS="..."
export PARTKEEPR_CATEGORY_PATH_SEPARATOR="/"
```

https://github.com/mhubig/docker-partkeepr/blob/2502a3550c7d5f38eab26ca2390345cf8f591d6a/docker-compose.yml#L8

`MYSQL_ROOT_PASSWORD="..."`


## Backup & Restore

Backup

`docker exec partkeepr_database /usr/bin/mysqldump -uroot -ppassword partkeepr > partkeepr.sql`

Restore

`cat partkeepr.sql | docker exec -i partkeepr_database /usr/bin/mysql -uroot -ppassword partkeepr`
