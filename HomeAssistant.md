# 自签证书

```
openssl req -sha256 -addext "subjectAltName = DNS:<本地劫持域名>" -newkey rsa:4096 -nodes -keyout privkey.pem -x509 -days 1860 -out fullchain.pem
```

Common Name填本地劫持域名，其他随便

```yaml
http:
  ssl_certificate: /ssl/certificate.pem
  ssl_key: /ssl/privkey.pem
```
