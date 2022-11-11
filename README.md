# Winter CMS Docker
Docker image for Winter CMS

[![Docker](https://github.com/Dragontek/wintercms/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/Dragontek/wintercms/actions/workflows/docker-publish.yml)

# About this Repo
This is an automated build based on the official PHP image, and supports similar tags.

# Quickstart
If you'd like to get up and running quickly, this image can be run without any linked containers.
```
$ docker run --name some-winter -p 8080:80 -d dragontek/wintercms
```
This will start the container and initialize a local SQLite instance for the database.  You can visit the site by going to http://localhost:8080.  The default username for the backend is 'admin', and the initial password is randomly generated and can be found in the logs.
```
$ docker logs some-winter

...
The following password has been automatically generated for the "admin" account: ***************
...

```

Winter provides a great interface for modifying files directly through the backend, and for many takss, such as theme and plugin development, this may be sufficient.  The image also exposes the /var/www/html folder so if you'd like to use a local editor, you can mount that to your local machine:

```
$ docker run --name some-winter -p 8080:80 -v $(pwd):/var/www/html -d dragontek/wintercms
```
This will start the container and copy the full website to the current directory.  This is a better option for tasks such as plugin development as you can use local tools such as `git`.

# Database Support
The examples so far have used a local SQLite instance, but for production you will probably want to use either MySQL/MariaDB or Postgres.  These can be configured through environment variables.
```
$ docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=superstrongpassword -e MYSQL_DATABASE=winter -e MYSQL_USER=winter -e MYSQL_PASSWORD -d mysql:5.7
$ docker run --name some-winter -p 8080:80 -e DB_CONNECTION=mysql -e DB_HOST=some-mysql DB_DATABASE=winter DB_USERNAME=winter DB_PASSWORD=winter -d dragontek/octobercms
```
A better solution is to use docker-compose:

```
# docker-compose.yml
version: "3.9"
    
services:
  db:
    image: mysql:5.7
    volumes:
      - db_data:/var/lib/mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: superstrongpassword
      MYSQL_DATABASE: winter
      MYSQL_USER: winter
      MYSQL_PASSWORD: winter
    
  winter:
    depends_on:
      - db
    image: dragontek/wintercms:latest
    volumes:
      - winter_data:/var/www/html
    ports:
      - "8080:80"
    restart: always
    environment:
      APP_DEBUG: 'false'
      DB_CONNECTION: mysql
      DB_HOST: db
      DB_DATABASE: winter
      DB_USERNAME: winter
      DB_PASSWORD: winter
volumes:
  db_data: {}
  winter_data: {}
```
