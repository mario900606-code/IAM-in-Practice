# Joiner, Mover, Leaver (JML)

Joiner, Mover and Leaver is one of the central lifecycle concepts in IAM.

The goal is not only to create accounts. Access should follow a person's current relationship with the organization and change when their role changes.

## Joiner

A Joiner is a new employee or user entering the organization.

### Demo flow

1. Create the identity in Keycloak.
2. Add basic user information and credentials.
3. Add the user to the appropriate business group.
4. Assign the required birthright role/access.
5. Test authentication to the relevant application.
6. Verify the authentication event in Grafana.

### Example

```text
User: david.developer
Group: Developers
Role: gitea-developer
Application: Gitea
```

The principle is that access should follow a defined function rather than being assigned randomly without structure.

## Mover

A Mover changes team, role or responsibility.

### Demo flow

1. Open the existing identity in Keycloak.
2. Remove group/role assignments that are no longer justified.
3. Add the new required assignment.
4. Test the new access state.
5. Explain why the previous entitlement should not remain.

### Main risk: access accumulation

A common IAM problem is that users receive new access when they move but old permissions are never removed.

This creates privilege accumulation over time.

A correct Mover process therefore needs to perform both actions:

```text
Grant new required access
+
Remove obsolete access
```

## Leaver

A Leaver leaves the organization or otherwise loses the right to access company resources.

### Demo flow

1. Disable the identity in Keycloak.
2. Attempt a new login through the connected application.
3. Show that central authentication is no longer available.
4. Explain that application sessions, tokens and application-specific accounts would also need to be considered in a production process.

## Why central identity matters

Without centralized identity management, offboarding can require separate manual actions in many applications.

A central Identity Provider creates a common control point for authentication, although complete enterprise deprovisioning would normally include provisioning/deprovisioning integrations and application session handling as well.

## Governance questions for JML

For every lifecycle stage, an organization should be able to answer:

- Who requested the access?
- Who approved it?
- What access is birthright?
- What access is additional?
- When should temporary access expire?
- What must be removed when the person moves?
- How quickly is access removed when the person leaves?
