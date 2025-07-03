#!/bin/bash

# Démarrer SSH
service ssh start

# Démarrer fail2ban
service fail2ban start

# Démarrer cron
service cron start

# Démarrer Apache
service apache2 start

# Démarrer FTP
service vsftpd start


# Garder le conteneur en vie
tail -f /var/log/apache2/access.log
