# Setup

## Prerequisites

The lab is designed for a Windows 11 workstation using:

- Docker Desktop
- Docker Compose
- Visual Studio Code
- Git
- Git Bash
- Web browser

## Recommended workflow

Open the repository in Visual Studio Code and use Git Bash as the terminal for Docker, Git and Keycloak administration commands.

The main Docker directory is:

```bash
cd /d/IAM-in-Practice/project/docker
```

## Configuration files

```text
docker-compose.yml
loki-config.yml
promtail-config.yml
grafana/provisioning/datasources/loki.yml
```

The purpose of the configuration files is to keep the lab reproducible and understandable instead of relying only on manual GUI configuration.

## Local service addresses

```text
Keycloak: http://localhost:8080
Grafana:  http://localhost:3000
Gitea:    http://localhost:3001
Loki:     http://localhost:3100
```

## Validate Docker Compose

Before recreating services after a YAML change:

```bash
docker compose config
```

This is useful for detecting YAML/Compose errors before starting the environment.

## Start the environment

```bash
docker compose up -d
```

Check status:

```bash
docker compose ps
```

## Stop the environment

```bash
docker compose stop
```

## Restart a service

Example:

```bash
docker compose restart grafana
```

## Recreate a service after configuration changes

Example:

```bash
docker compose up -d --force-recreate keycloak
```

## View logs

Keycloak:

```bash
docker logs iam-keycloak --tail 100
```

Promtail:

```bash
docker logs iam-promtail --tail 100
```

Loki:

```bash
docker logs iam-loki --tail 100
```

Grafana:

```bash
docker logs iam-grafana --tail 100
```

## Keycloak realm

```text
iam-in-practice
```

## Gitea OIDC

Expected redirect URI:

```text
http://localhost:3001/user/oauth2/Keycloak/callback
```

Web origin:

```text
http://localhost:3001
```

The browser-facing Keycloak URL uses `localhost`, while Docker services can communicate internally using the `keycloak` container hostname.

## Grafana OIDC

Expected redirect URI:

```text
http://localhost:3000/login/generic_oauth
```

Web origin:

```text
http://localhost:3000
```

## Successful Keycloak event logging

Successful events need to be written at a level collected by the container logs.

Environment setting used in the lab:

```text
KC_SPI_EVENTS_LISTENER__JBOSS_LOGGING__SUCCESS_LEVEL=info
```

The realm event listener includes:

```text
jboss-logging
```

Verify successful events:

```bash
docker logs iam-keycloak --since 2m 2>&1 | grep -i 'type="LOGIN'
```

Verify failed events:

```bash
docker logs iam-keycloak --since 2m 2>&1 | grep -i 'LOGIN_ERROR'
```

## Important Git Bash note

Git Bash may rewrite Linux paths passed to Docker containers.

For `kcadm.sh`, use:

```bash
MSYS_NO_PATHCONV=1 docker exec iam-keycloak /opt/keycloak/bin/kcadm.sh ...
```

Or for several commands:

```bash
export MSYS_NO_PATHCONV=1
```
