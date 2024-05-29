# Use with `frp`

`[NPM] -LAN- [frpc] -WAN- [frps] -LO- [Nginx]`

`frp` create TCP tunnel from `npm`'s 443 to VPS, `nginx` reverse proxy the tunnel

502 Bad gateway: `SSL: error:14094458:SSL routines:ssl3_read_bytes:tlsv1 unrecognized name:SSL alert number 112`

SNI related, add the following to `nginx` reverse proxy config:

```
proxy_ssl_name $host;
proxy_ssl_server_name on;
```

# Home Assistant

## ESPHome WebSocket

https://github.com/esphome/issues/issues/4327

![image](https://github.com/whc2001/_notes/assets/16266909/4128816b-df14-4872-883d-21cf8019bf1e)
