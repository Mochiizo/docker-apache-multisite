#!/bin/bash
DATE=$(date +%F_%H-%M)
mkdir -p /backups

# Sauvegarde du dossier web
tar -czf /backups/www_$DATE.tar.gz /var/www/html

# Sauvegarde DB si mariadb dispo
mysqldump -h db -u user -puserpass tp_apache > /backups/db_$DATE.sql 2>/dev/null
