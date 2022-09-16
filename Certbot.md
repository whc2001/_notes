https://github.com/broly8/letsencrypt-aliyun-dns-manual-hook

```
certbot certonly --manual -n --agree-tos --email XXX -d XXX -d *.XXX -d *.AAA.XXX --expand --preferred-challenges dns-01 --manual-auth-hook "/usr/bin/python3 /home/whc/letsencrypt-aliyun-dns-manual-hook/manual-hook.py --auth" --manual-cleanup-hook "/usr/bin/python3 /home/whc/letsencrypt-aliyun-dns-manual-hook/manual-hook.py --cleanup" --renew-hook "nginx -s reload"
```
