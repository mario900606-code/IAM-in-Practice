# Security Considerations

This repository represents a local learning lab and should not be treated as a production deployment.

## Secrets

Never commit real passwords, OAuth client secrets or administrator credentials to GitHub.

Sensitive values should be stored using environment variables, a local `.env` file excluded from Git or a dedicated secrets-management solution.

Examples:

```text
Grafana OAuth client secret
Keycloak administrator password
Application credentials
```

Recommended `.gitignore` entries:

```gitignore
.env
*.secret
*-client-secret.txt
```

If a real secret has already been committed to a public repository, deleting it from the current file is not sufficient. The secret should be rotated.

## Demo credentials

Simple lab credentials are appropriate only for an isolated demonstration environment and must never be reused in production.

## Development mode

Keycloak currently runs with:

```text
start-dev
```

This is convenient for the local lab but is not a production configuration.

## HTTP

The project uses local HTTP addresses.

A production architecture should use TLS/HTTPS and suitable certificate management.

## Least Privilege

Administrative privileges should remain separated.

Examples:

- Helpdesk should not automatically be IAM admin.
- IAM administrators should not automatically receive administrator rights in every application.
- Security monitoring roles should not automatically be able to modify IAM configuration.

## Logging

Authentication logs can contain security-relevant metadata such as:

- usernames
- client/application names
- IP addresses
- session identifiers
- authentication results

Access to logs should therefore also be controlled.

## Repository hygiene

The repository should contain configuration, scripts and documentation but should not contain:

- runtime databases
- Docker data directories
- generated secrets
- local `.env` files
- exported credentials
- unnecessary log files

## Production improvements

A production-grade design would additionally consider:

- TLS everywhere
- strong MFA
- dedicated secrets management
- hardened databases
- backup and restore procedures
- log retention and integrity
- alerting
- high availability
- regular access reviews
- automated deprovisioning
- privileged access controls
