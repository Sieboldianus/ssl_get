# Central Wildcard SSL Cert Setup

## SSL

- Console

```bash
cd /etc/apache2/
mkdir ssl
apt-get install ftp
nano ftp.sh
nano check_ssl.sh
chmod +x check_ssl.sh ftp.sh
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