# Central Wildcard SSL Cert Setup

## SSL

- Console

```bash
cd /etc/apache2/
# or /etc/nginx/
mkdir ssl
apt-get install ftp
nano ftp.sh
nano check_cert.sh
chmod +x check_cert.sh ftp.sh
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

inspect crontab logs
```
sudo grep CRON /var/log/syslog
```

Test all crontab entries:
```
crontab -l | grep -v '^#' | cut -f 6- -d ' ' | while read CMD; do eval $CMD; done
```