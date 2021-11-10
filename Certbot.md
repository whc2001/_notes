https://github.com/broly8/letsencrypt-aliyun-dns-manual-hook

```
certbot certonly --manual -n --agree-tos --manual-public-ip-logging-ok --email EMAIL_ADDRESS -d DOMAIN.COM -d *.DOMAIN.COM --preferred-challenges dns-01 --manual-auth-hook "python /root/letsencrypt-aliyun-dns-manual-hook-master/manual-hook.py --auth" --manual-cleanup-hook "python /root/letsencrypt-aliyun-dns-manual-hook-master/manual-hook.py --cleanup"
```
