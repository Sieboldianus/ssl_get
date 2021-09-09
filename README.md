# Central Wildcard SSL Cert Setup

## Requirements

```
apt-get install ftp
```

## SSL


- Console

```sh
cd /etc/apache2/
# or /etc/nginx/
mkdir ssl
apt-get install ftp
git clone .../ssl_get.git
cd ssl_get
chmod +x check_cert.sh ftp.sh
cp .env.example .env
```

Edit parameters in `.env`.

It is possible to define any after-script-hook  
in `.env` such as reload service nginx, apache,  
or docker restart. The command must be defined as  
a variable `RESTART_CMD` that will be executed via  
`eval` in `check_cert.sh`.  

Test script:
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
5 8 * * 0 /etc/apache2/ssl_get/check_cert.sh
```

## Debug

Inspect crontab logs
```sh
sudo find /var/log/. -name \syslog.*.gz -print0 | xargs -0 zgrep "check_cert.sh"
# or individual
sudo grep "check_cert.sh" /var/log/syslog
sudo grep "check_cert.sh" /var/log/syslog.1
sudo zgrep "check_cert.sh" /var/log/syslog.2.gz
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