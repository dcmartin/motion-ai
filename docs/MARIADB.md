# `MARIADB.md` - Use of MariaDB
Starting the MariaDB from the standard add-on store repository will provide the required SQL services.

## _Add-On_ configuration

```
databases:
  - homeassistant
logins:
  - username: homeassistant
    password: '!secret mariadb-password'
rights:
  - username: homeassistant
    database: homeassistant
```

## `homeassistant/recorder.yaml`
Configuration of Home Assistant through the `recorder` component has commented-out directive:

```
#db_url: !secret mariadb-url
```

## `homeassistant/secrets.yaml.tmpl`
The secret `mariadb-url` is defined using a template; note the `utf8mb4` character set is required, for example:

```
# mariadb
mariadb-url: mysql://homeassistant:${MARIADB_PASSWORD}@${MARIADB_HOST}/homeassistant?charset=utf8mb4
mariadb-password: ${MARIADB_PASSWORD}
mariadb-host: ${MARIADB_HOST}
```

## [Options](OPTIONS.md)

+ `MARIADB_PASSWORD` should match MariaDB add-on configuration; default is `HomeAssistant1234`
+ `MARIADB_HOST` default is `core-mariadb`; alternative server IP address may be used


