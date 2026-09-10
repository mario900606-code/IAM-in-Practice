# Troubleshooting

This file records important problems encountered during the project and how they were solved.

Documenting the problems is useful because the integration work was one of the most valuable parts of the project.

## Gitea: SSO redirects but authentication fails

### Symptoms

Examples included:

```text
client not found
Failed to get token
invalid redirect URI
browser reaches Keycloak but container-to-container calls fail
```

### Solution

The working design separates browser-facing and Docker-internal communication.

Keycloak hostname configuration:

```text
KC_HOSTNAME=http://localhost:8080
KC_HOSTNAME_BACKCHANNEL_DYNAMIC=true
```

Gitea can use the internal discovery endpoint:

```text
http://keycloak:8080/realms/iam-in-practice/.well-known/openid-configuration
```

Redirect URI:

```text
http://localhost:3001/user/oauth2/Keycloak/callback
```

## Keycloak configuration disappears after restart

### Cause

Keycloak data was not persisted correctly.

### Solution

Persist `/opt/keycloak/data` outside the container.

Current project location:

```text
D:\IAM-in-Practice\data\keycloak
```

## Grafana failed-login counter increases on refresh

### Symptom

The failed-login number increases even though no new failed authentication was performed.

### Cause

The first Promtail configuration collected logs from every Docker container. Grafana, Loki and Promtail could themselves contain the string `LOGIN_ERROR`, creating noisy/duplicated ingestion.

### Solution

Promtail was changed to Docker service discovery and configured to keep only:

```text
iam-keycloak
```

Grafana queries now use:

```logql
{job="keycloak"}
```

instead of a generic Docker log job.

## Failed logins appear but successful logins do not

### Symptom

`LOGIN_ERROR` events are visible but successful `LOGIN` events are absent from `docker logs`.

### Solution

Enable the `jboss-logging` realm event listener and configure successful events at `info` level:

```text
KC_SPI_EVENTS_LISTENER__JBOSS_LOGGING__SUCCESS_LEVEL=info
```

After recreation/restart, successful events can appear as:

```text
type="LOGIN"
```

## Git Bash changes paths passed to containers

### Symptom

`kcadm.sh` receives an unexpected Windows path even though a Linux container path was entered.

### Cause

MSYS path conversion in Git Bash.

### Solution

```bash
MSYS_NO_PATHCONV=1 docker exec ...
```

Or:

```bash
export MSYS_NO_PATHCONV=1
```

## YAML / Docker Compose errors

### Symptom

Docker Compose rejects the configuration after an edit.

### Solution

Validate the complete Compose file before recreating services:

```bash
docker compose config
```

YAML is indentation-sensitive, so incorrect indentation or placing a field under the wrong section can invalidate the configuration.

Visual Studio Code is useful here because the complete file structure can be inspected before running the Compose command.

## Docker storage fills the Windows C: drive

The project stores persistent application data on the `D:` drive to reduce pressure on the system disk.

Docker Desktop's own data location should also be checked after resets or reconfiguration so that large Docker disk images do not unexpectedly return to `C:`.

Do not blindly delete unrelated WSL data. First identify what is actually using the disk space.
