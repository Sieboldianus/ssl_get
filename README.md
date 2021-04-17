# Central Wildcard SSL Cert Setup

## SSL


- Console

```sh
cd /etc/apache2/
# or /etc/nginx/
mkdir ssl
apt-get install ftp
chmod +x check_cert.sh ftp.sh
```


- `cp .env.example .env`
- edit parameters

```sh
sh check_cert.sh
```

## Cron


Add cron:
```sh
sudo crontab -e
```

Add line:
```sh
5 8 * * 0 /etc/apache2/check_cert.sh
```

## Debug

Inspect crontab logs
```sh
sudo grep "check_cert.sh" /var/log/syslog
sudo zgrep "check_cert.sh" /var/log/syslog.1.gz
> Mar 21 08:05:01 cloud CRON[25307]: (root) CMD (/etc/apache2/check_cert.sh)
...
```

Test all crontab entries:
```sh
crontab -l | grep -v '^#' | cut -f 6- -d ' ' | while read CMD; do eval $CMD; done
```

Check expiration of web address:
```sh
openssl s_client \
    -servername service.local.mytld.com \
    -connect service.local.mytld.com:443 | openssl x509 -noout -dates
```

Check SSL cert:
```sh
openssl s_client \
    -showcerts -connect service.local.mytld.com:443 </dev/null
```