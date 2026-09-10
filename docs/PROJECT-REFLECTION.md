# Project Reflection

## Why I built the project

The main reason for building this lab was to understand IAM beyond definitions and diagrams.

I wanted to see what actually happens when an identity is created, assigned to a group or role, authenticated into an application, moved to another function, disabled and then represented in security logs.

Building the environment made the concepts much easier to understand because I could test the full chain instead of only reading about it.

## IAM became more than login

At the beginning it is easy to associate IAM mainly with usernames, passwords and SSO.

During the project it became clearer that the more important questions are often:

```text
Why does this person have access?
Does the person still need it?
What happens when the role changes?
Who removes the old access?
Can we see what happened afterwards?
```

That is why Joiner, Mover and Leaver and access governance became important parts of the project.

## Roles should not contain everything

One important lesson was that a business role should not automatically include every entitlement a person could possibly need.

It makes more sense to separate:

- birthright access
- additional/requested access
- temporary access

This keeps access easier to understand and supports Least Privilege.

## The development workflow saved time

Another part of the learning was the way the environment was built.

I used **Visual Studio Code** as the main editor for YAML files, shell scripts and documentation. This gave me a clear view of the complete repository and made configuration changes easier to track.

I created `docker-compose.yml` to define the full lab instead of installing each service directly in Windows. Together with the Loki, Promtail and Grafana YAML configuration, this made the infrastructure more repeatable and easier to explain.

**Git Bash saved a significant amount of time.** Many actions that would otherwise require repeated navigation through interfaces could be performed with short commands. I could start or recreate containers, inspect logs, run Keycloak administration commands and use Git from the same terminal.

The commands could also be reused during troubleshooting instead of repeating the same manual steps.

This showed me the value of combining security knowledge with practical command-line and configuration skills.

## Monitoring made the project more realistic

Connecting Keycloak to Promtail, Loki and Grafana made the project feel more like a real security environment.

The final dashboard can show:

```text
User: david.developer | Application: gitea | SUCCESS
User: david.developer | Application: gitea | FAILED
```

This creates traceability between identity activity and security monitoring.

## Technical challenges

The main challenges were integrations rather than basic definitions.

Examples included:

- OIDC redirect URLs
- browser URLs versus Docker-internal hostnames
- persistent Keycloak data
- Grafana role mapping
- successful Keycloak event logging
- duplicated/noisy logs in Loki
- Git Bash path conversion
- YAML/Compose structure
- Docker storage and resource limitations

Solving these problems was valuable because real IAM work often involves making different systems trust and communicate with the same identity platform.

## Scope decisions

The original project idea contained more applications and heavier components, including GLPI and Splunk.

They were removed because they increased resource usage and complexity without improving the core IAM demonstration enough.

The final runtime stack is intentionally focused:

```text
Keycloak
Gitea
Grafana
Loki
Promtail
Docker Compose
```

The main supporting tools are:

```text
Visual Studio Code
Git Bash
Git / GitHub
YAML
FigJam
```

Reducing the scope made the environment more stable and kept the project focused on identity, access, lifecycle and traceability.

## What I would add next

Possible future improvements include:

- automated Joiner/Mover/Leaver workflows
- access request and approval processes
- periodic access reviews
- temporary access with expiration
- stronger MFA policies
- Privileged Access Management (PAM)
- Identity Governance and Administration (IGA)
- automated provisioning through APIs or SCIM
- more advanced monitoring and alerting

## Final conclusion

The project now demonstrates the relationship between:

```text
Identity
  -> Group / Role
  -> Authentication
  -> Authorization
  -> Application Access
  -> Logging / Monitoring
  -> Review / Change / Removal
```

The biggest value for me was turning IAM from theory into something visible and testable. I could see not only whether a user could log in, but also how identity configuration, application trust, lifecycle changes and monitoring fit together.
