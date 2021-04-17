# Central Wildcard SSL Cert Setup

## SSL


- Console

```bash
cd /etc/apache2/
# or /etc/nginx/
mkdir ssl
apt-get install ftp
chmod +x check_cert.sh ftp.sh
```


- `cp .env.example .env`
- edit parameters

```
bash ftp.sh
```

## Cron


Add cron:
```
sudo crontab -e
```

Add line:
```
5 8 * * 0 /etc/apache2/check_cert.sh
```

## Debug

Inspect crontab logs
```
sudo grep "check_cert.sh" /var/log/syslog
sudo zgrep "check_cert.sh" /var/log/syslog.1.gz
> Mar 21 08:05:01 cloud CRON[25307]: (root) CMD (/etc/apache2/check_cert.sh)
...
```

Test all crontab entries:
```
crontab -l | grep -v '^#' | cut -f 6- -d ' ' | while read CMD; do eval $CMD; done
```

Check expiration of web address:
```
openssl s_client \
    -servername service.local.mytld.com \
    -connect service.local.mytld.com:443 | openssl x509 -noout -dates
```

Check SSL cert:
```
openssl s_client \
    -showcerts -connect service.local.mytld.com:443 </dev/null
```