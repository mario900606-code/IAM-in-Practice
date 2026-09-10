# Development Workflow

## Overview

This project was not built only through graphical interfaces. A large part of the work was done through configuration files and repeatable terminal commands.

The main working environment consisted of:

```text
Windows 11
Visual Studio Code
Git Bash
Git / GitHub
Docker Desktop
Docker Compose
YAML
```

This workflow made the lab faster to rebuild, easier to troubleshoot and easier to document.

## Visual Studio Code

Visual Studio Code was used as the main editor for the project.

It was used to work with:

- `docker-compose.yml`
- Loki configuration
- Promtail configuration
- Grafana provisioning files
- Keycloak shell scripts
- Markdown documentation
- Git repository files

Using one editor made it easier to understand how the different parts of the environment were connected.

## Why YAML was used

YAML is used by several components in the project because it provides a readable way to describe configuration.

### `docker-compose.yml`

This is the main infrastructure definition for the lab.

It describes:

- which containers should run
- images used by each service
- container names
- ports
- persistent volumes
- environment variables
- service dependencies
- Docker networks

Instead of manually recreating the environment every time, Docker Compose can read the file and start the defined services.

### `loki-config.yml`

Defines Loki's local storage and schema configuration.

### `promtail-config.yml`

Defines how Promtail discovers Docker containers, filters the collection target to Keycloak and forwards logs to Loki.

### Grafana provisioning

YAML is also used to provision the Loki datasource in Grafana automatically.

## Why Git Bash was useful

Git Bash became one of the most useful tools during implementation.

Many actions were faster to perform as commands than through graphical interfaces. Commands could also be copied, reused and documented when a problem had to be reproduced.

Typical tasks included:

```bash
# Move to the Docker directory
cd /d/IAM-in-Practice/project/docker

# Start all services
docker compose up -d

# Check service state
docker compose ps

# Recreate one service
docker compose up -d --force-recreate keycloak

# Inspect Keycloak logs
docker logs iam-keycloak --tail 100

# Search for failed authentication events
docker logs iam-keycloak --since 2m 2>&1 | grep -i 'LOGIN_ERROR'

# Search for successful authentication events
docker logs iam-keycloak --since 2m 2>&1 | grep -i 'type="LOGIN'
```

Git Bash also provided access to Git commands from the same terminal:

```bash
git status
git add .
git commit -m "Update IAM monitoring documentation"
git push
```

## Git Bash and Docker path conversion

One issue discovered during the project was that Git Bash/MSYS can automatically rewrite Linux-style paths passed into Docker containers.

This affected Keycloak administration commands using `kcadm.sh`.

The solution was to disable path conversion for those commands:

```bash
MSYS_NO_PATHCONV=1 docker exec iam-keycloak /opt/keycloak/bin/kcadm.sh ...
```

For several commands in the same session:

```bash
export MSYS_NO_PATHCONV=1
```

This became an important troubleshooting lesson because the command itself could be correct while the shell silently changed the path.

## Git and GitHub

Git was used to track changes to configuration and documentation.

GitHub is used as the project documentation and version-control platform. This makes it possible to show not only the final result but also how the project is structured.

The repository should contain configuration and documentation, but not runtime data or secrets.

## Why this workflow mattered

Using configuration files and terminal commands created several benefits:

- faster repeated setup
- easier troubleshooting
- commands could be reused instead of repeated manually
- configuration changes were visible and reviewable
- the architecture became easier to explain
- Git could track changes over time
- the lab became more reproducible

For this project, the tooling was therefore part of the learning process, not only a way to launch the applications.
