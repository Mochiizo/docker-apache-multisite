# ![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white) ![Apache](https://img.shields.io/badge/Apache-DB4437?style=flat&logo=apache&logoColor=white)

# docker-apache-multisite
Je précise que c'était pour un TP à l'origine.

Ce projet permet de déployer plusieurs sites web à l'aide de Docker et d'Apache. Il est conçu pour faciliter la gestion de plusieurs sites dans un environnement isolé, tout en offrant une configuration simple et efficace.

## Fonctionnalités clés

- Déploiement facile de plusieurs sites web avec Apache.
- Configuration flexible à l'aide de fichiers Docker et de scripts d'initialisation.
- Support pour l'authentification et la gestion des utilisateurs via des fichiers de configuration.

## Stack Technique

| Technologie | Description |
|-------------|-------------|
| ![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white) | Conteneurisation pour déployer des applications. |
| ![Apache](https://img.shields.io/badge/Apache-DB4437?style=flat&logo=apache&logoColor=white) | Serveur web pour héberger les sites. |

## Instructions d'installation

### Prérequis

- Docker
- Docker Compose

### Guide d'installation

1. Clonez le dépôt :
   ```bash
   git clone https://github.com/Mochiizo/docker-apache-multisite.git
   cd docker-apache-multisite
   ```

2. Copiez le fichier d'exemple d'environnement :
   ```bash
   cp .env.example .env
   ```

3. Modifiez le fichier `.env` pour configurer vos variables d'environnement si nécessaire.

4. Construisez et démarrez les conteneurs :
   ```bash
   docker-compose up --build -d
   ```

## Utilisation

Pour accéder aux différents sites, ouvrez votre navigateur et allez à l'adresse suivante :

- Site A : `http://localhost/site/sitea`
- Site B : `http://localhost/site/siteb`
- Site C : `http://localhost/site/sitec`
- Site D : `http://localhost/site/sited`

Pour éviter de saisir à chaque fois les chemins longs avec `localhost/site/sitex`, vous pouvez configurer des noms de domaine locaux en modifiant votre fichier `hosts`.
Cette opération nécessite les droits administrateur.

 Modifiez votre fichier `hosts` pour mapper les noms de domaine locaux :
   - Sous Linux/macOS : `/etc/hosts`
   - Sous Windows     : `C:\Windows\System32\drivers\etc\hosts`

   À ajouter :
   ```
   127.0.0.1 siteA.fr
   127.0.0.1 siteB.fr
   127.0.0.1 siteC.fr
   127.0.0.1 siteD.fr
   127.0.0.1 sitewp.fr
   127.0.0.1 sitej.fr
   ```

Ensuite, vous pourrez accéder aux sites directement avec ces URLs simplifiées :
- Site A : `sitea.fr:8080`
- Site B : `siteb.fr:8080`
- Site C : `sited.fr:8080`
- Site D : `sited.fr:8080`
- Site wp : `sitewp.fr:8080`
- Site J : `sitej.fr:8080`

## Structure du projet

Voici un aperçu de la structure du projet :

```
docker-apache-multisite/
├── web/
│   ├── site/
│   │   ├── sitea/
│   │   │   └── index.php         # Point d'entrée du site A
│   │   ├── siteb/
│   │   │   └── index.php         # Point d'entrée du site B
│   │   ├── sitec/
│   │   │   └── index.php         # Point d'entrée du site C
│   │   ├── sited/
│   │   │   └── accueil.php       # Point d'entrée du site D
│   │   └── index.html            # Page d'accueil générale
│   ├── apache-auth.conf          # Configuration d'authentification Apache
│   ├── backup.sh                 # Script de sauvegarde
│   ├── cronjob                   # Tâches planifiées
│   ├── Dockerfile                 # Fichier de configuration Docker
│   ├── jail.local                # Configuration de sécurité
│   ├── start.sh                  # Script de démarrage
│   └── vsftpd.conf               # Configuration de FTP
├── .env.example                   # Exemple de fichier d'environnement
├── .gitignore                     # Fichiers à ignorer par Git
├── docker-compose.yml             # Fichier de configuration Docker Compose
├── db-data/         # (📁 généré automatiquement - BDD MariaDB)
├── wp-data/         # (📁 généré automatiquement - WordPress)
├── joomla-data/     # (📁 généré automatiquement - Joomla)
└── backups/         # (📁 généré automatiquement - sauvegardes .tar.gz)
```

### Explication des fichiers et répertoires principaux

- `web/` : Contient tous les fichiers nécessaires au déploiement des sites.
- `site/` : Contient les répertoires pour chaque site avec leurs fichiers d'entrée respectifs.
- `Dockerfile` : Fichier utilisé pour construire l'image Docker.
- `docker-compose.yml` : Fichier pour orchestrer les conteneurs Docker.

## Contribuer

Les contributions sont les bienvenues !
