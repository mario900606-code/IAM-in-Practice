# Practical Demo Plan

## Goal

Demonstrate the complete journey from identity to access, lifecycle change and security monitoring.

A suitable demo length is approximately 10–15 minutes.

## 1. Introduce the problem

Start with the central IAM question:

> How do we make sure that the right person has the right access to the right resource at the right time — and that we can see what happens?

## 2. Briefly show how the lab was built

Show the repository in Visual Studio Code.

Point out:

```text
docker-compose.yml
loki-config.yml
promtail-config.yml
grafana/provisioning/
docs/
```

Explain that YAML configuration defines the environment and that Docker Compose starts the services.

Mention that Git Bash was used heavily to run repeatable Docker, Keycloak and Git commands. This reduced the amount of repetitive manual work during setup and troubleshooting.

## 3. Show the architecture

Explain the components in one sentence each:

```text
Keycloak = identity and authentication
Gitea = protected business application
Grafana = security monitoring + protected application
Promtail = log collection
Loki = log storage
Docker Compose = runs the environment
```

## 4. Show identities in Keycloak

Show the test users:

```text
emma.hr
david.developer
hanna.helpdesk
simon.security
adam.iamadmin
```

Show groups and roles.

Explain that each identity represents a different business responsibility and should not automatically receive all permissions.

## 5. Demonstrate SSO

Use `david.developer`.

1. Open Gitea.
2. Choose **Sign in with Keycloak**.
3. Authenticate in Keycloak.
4. Show that David enters the application through the central Identity Provider.

Explain:

> Gitea trusts Keycloak for authentication through OpenID Connect. The identity is centralized instead of creating a separate authentication solution for every application.

## 6. Demonstrate a failed login

1. Log out.
2. Attempt authentication with an incorrect password.
3. Open Grafana.
4. Show the Failed Logins counter.
5. Show Failed Login Events.

Example output:

```text
User: david.developer | Application: gitea | FAILED
```

## 7. Demonstrate successful login monitoring

Perform a correct authentication.

Show:

```text
User: david.developer | Application: gitea | SUCCESS
```

Explain that both successful and failed authentication activity is visible centrally.

## 8. Demonstrate Mover

Scenario:

> David changes responsibility and should no longer retain an old entitlement.

1. Open David in Keycloak.
2. Remove the old group/role assignment.
3. Add the new required assignment.
4. Explain that IAM must remove obsolete access as well as grant new access.

Main risk:

```text
Access accumulation
```

## 9. Demonstrate Leaver

1. Disable a test identity in Keycloak.
2. Attempt a new authentication.
3. Explain that the central identity can no longer authenticate to connected services.

## 10. Explain Least Privilege

Use Hanna Helpdesk as the example.

Scenario:

> Someone contacts Helpdesk and attempts social engineering to obtain privileged access.

Hanna may have the access needed for normal support tasks, but she should not automatically have IAM administration rights.

The point is that a compromised or manipulated Helpdesk account should not automatically provide control over the identity platform.

## 11. Close with governance

Explain that the lab demonstrates the technical **management** of access while governance answers questions such as:

- Why does the user need this access?
- Who approved it?
- Is it still appropriate?
- Should temporary access have expired?
- Does the access conflict with another responsibility?

## Final message

The complete project can be summarized as:

```text
Identity
   -> Group / Role
   -> Authentication
   -> Authorization
   -> Application Access
   -> Monitoring
   -> Review / Change / Removal
```
