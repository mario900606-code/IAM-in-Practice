# IAM Security Monitoring

## Goal

The monitoring part of the project makes identity activity visible.

The complete flow is:

```text
Keycloak -> Promtail -> Loki -> Grafana
```

## Keycloak events

Keycloak writes authentication events to its container output.

Examples include:

```text
type="LOGIN"
type="LOGIN_ERROR"
```

Useful event fields include:

- `username`
- `clientId`
- `ipAddress`
- authentication result
- error reason
- session information

## Successful event logging

Failed events were visible first, while successful events were not being written at the required log level.

Successful event output was enabled using the Keycloak `jboss-logging` event listener and:

```text
KC_SPI_EVENTS_LISTENER__JBOSS_LOGGING__SUCCESS_LEVEL=info
```

A successful event can then be verified from Git Bash:

```bash
docker logs iam-keycloak --since 2m 2>&1 | grep -i 'type="LOGIN'
```

## Promtail

Promtail collects Keycloak logs and pushes them to Loki.

The final design uses Docker service discovery and keeps only the Keycloak container.

Conceptually:

```yaml
scrape_configs:
  - job_name: keycloak
    docker_sd_configs:
      - host: unix:///var/run/docker.sock
    relabel_configs:
      - source_labels: [__meta_docker_container_name]
        regex: /iam-keycloak
        action: keep
```

This was an important change. An earlier configuration scraped every Docker container and created noisy/duplicated login counts.

## Loki

Loki stores the collected logs and exposes them to Grafana through a Loki datasource.

## Grafana dashboard

Dashboard name:

```text
IAM Security Monitoring
```

### Failed Logins

Visualization: Stat/Gauge  
Query type: Instant

```logql
sum(count_over_time({job="keycloak"} |= "LOGIN_ERROR" |= "invalid_user_credentials" [$__range]))
```

### Successful Logins

Visualization: Stat/Gauge  
Query type: Instant

```logql
sum(count_over_time({job="keycloak"} |= "type=\"LOGIN\"" [$__range]))
```

### Failed Login Events

Visualization: Logs

```logql
{job="keycloak"} |= "LOGIN_ERROR"
| regexp `clientId="(?P<application>[^"]+)".*username="(?P<username>[^"]+)"`
| line_format `User: {{.username}} | Application: {{.application}} | FAILED`
```

### Successful Login Events

Visualization: Logs

```logql
{job="keycloak"} |= "type=\"LOGIN\""
| regexp `clientId="(?P<application>[^"]+)".*username="(?P<username>[^"]+)"`
| line_format `User: {{.username}} | Application: {{.application}} | SUCCESS`
```

## Dynamic dashboard time range

The counters use Grafana's `$__range` variable instead of a hard-coded window such as five minutes.

This means the same dashboard works for:

```text
Last 15 minutes
Last 1 hour
Last 6 hours
Last 24 hours
Custom ranges
```

The presenter can control the time range directly from Grafana.

## What the monitoring proves

The dashboard demonstrates that identity activity is not invisible after authentication is configured.

It is possible to show:

- who attempted to authenticate
- which connected application was involved
- whether the attempt succeeded or failed
- how many events occurred during the selected time range

This provides useful traceability and connects IAM with security monitoring.
