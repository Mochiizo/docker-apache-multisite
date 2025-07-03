FROM debian:11

ARG USERNAME=mathishb

# Installer Apache, PHP, SSH, fail2ban, cron, outils
RUN apt-get update && apt-get install -y \
    apache2 \
    php \
    php-mysql \
    openssh-server \
    sudo \
    curl \
    nano \
    apache2-utils \
    fail2ban \
    cron \
    vsftpd\
    logrotate \
    && apt-get clean

# Créer utilisateurs
RUN useradd -m -s /bin/bash $USERNAME && echo "$USERNAME:password123" | chpasswd
RUN useradd -m -s /bin/bash csi && echo "csi:csi" | chpasswd

# Configuration sudo
RUN usermod -aG sudo $USERNAME && echo "$USERNAME ALL=(ALL:ALL) ALL" >> /etc/sudoers
RUN echo "csi ALL=(ALL) NOPASSWD: /bin/false" >> /etc/sudoers.d/csi && chmod 440 /etc/sudoers.d/csi

# Configuration SSH
RUN mkdir -p /var/run/sshd
RUN sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config && \
    echo "DenyUsers root $USERNAME" >> /etc/ssh/sshd_config && \
    echo "AllowUsers csi" >> /etc/ssh/sshd_config

# Activer modules Apache
RUN a2enmod rewrite proxy proxy_http

# Copier fichiers de config
COPY start.sh /start.sh
COPY jail.local /etc/fail2ban/jail.local
COPY apache-auth.conf /etc/fail2ban/filter.d/apache-auth.conf
COPY backup.sh /root/backup.sh
COPY cronjob /etc/cron.d/backup-cron

RUN chmod +x /start.sh /root/backup.sh && chmod 0644 /etc/cron.d/backup-cron
RUN crontab /etc/cron.d/backup-cron

# Rotation logs Apache personnalisée
RUN echo "/var/log/apache2/*.log {\n daily\n missingok\n rotate 14\n compress\n delaycompress\n notifempty\n create 640 root adm\n sharedscripts\n postrotate\n /etc/init.d/apache2 reload > /dev/null\n endscript\n}" > /etc/logrotate.d/apache2

# VirtualHosts (siteA à D, localhost, WordPress, Joomla)
RUN htpasswd -b -c /etc/apache2/.htpasswd admin admin

# siteA
RUN cat <<EOF > /etc/apache2/sites-available/siteA.conf
<VirtualHost *:80>
    ServerName siteA.fr
    DocumentRoot /var/www/html/sitea
</VirtualHost>
EOF
RUN a2ensite siteA

# siteB
RUN cat <<EOF > /etc/apache2/sites-available/siteB.conf
<VirtualHost *:80>
    ServerName siteB.fr
    DocumentRoot /var/www/html/siteb
</VirtualHost>
EOF
RUN a2ensite siteB

# siteC
RUN cat <<EOF > /etc/apache2/sites-available/siteC.conf
<VirtualHost *:80>
    ServerName siteC.fr
    DocumentRoot /var/www/html/sitec
</VirtualHost>
EOF
RUN a2ensite siteC

# siteD
RUN cat <<EOF > /etc/apache2/sites-available/siteD.conf
<VirtualHost *:80>
    ServerName siteD.fr
    DocumentRoot /var/www/html/sited
    DirectoryIndex accueil.php
</VirtualHost>
EOF
RUN a2ensite siteD

# localhost
RUN cat <<EOF > /etc/apache2/sites-available/000-local.conf
<VirtualHost *:80>
    ServerName localhost
    DocumentRoot /var/www/html

    ProxyPass /pma http://phpmyadmin:80/
    ProxyPassReverse /pma http://phpmyadmin:80/

    <Location /pma>
        ProxyPreserveHost On
        Require all granted
    </Location>
</VirtualHost>
EOF
RUN a2ensite 000-local
RUN a2dissite 000-default

# sitewp.fr (WordPress)
RUN cat <<EOF > /etc/apache2/sites-available/sitewp.conf
<VirtualHost *:80>
    ServerName sitewp.fr
    ProxyPass / http://sitewp:80/
    ProxyPassReverse / http://sitewp:80/
</VirtualHost>
EOF
RUN a2ensite sitewp

# sitej.fr (Joomla) + auth sur /administrator
RUN cat <<EOF > /etc/apache2/sites-available/sitej.conf
<VirtualHost *:80>
    ServerName sitej.fr
    ProxyPass / http://sitej:80/
    ProxyPassReverse / http://sitej:80/
    <Location /administrator>
        AuthType Basic
        AuthName "Restricted Area"
        AuthUserFile /etc/apache2/.htpasswd
        Require valid-user
    </Location>
</VirtualHost>
EOF
RUN a2ensite sitej

# Créer utilisateur FTP
RUN useradd -m -d /home/ftpuser ftpuser && \
    echo "ftpuser:ftp123" | chpasswd && \
    mkdir -p /home/ftpuser/files && \
    chown -R ftpuser:ftpuser /home/ftpuser && \
    chmod 755 /home/ftpuser

# Copier la config vsftpd
COPY vsftpd.conf /etc/vsftpd.conf


EXPOSE 80 22 21 40000-40010

CMD ["/start.sh"]
