# IAM Design

## Core IAM question

The project is built around four questions:

- Who is the user?
- What should the user have access to?
- Why should the user have that access?
- When should that access be changed or removed?

A useful summary is:

> Right person, right access, right resource, right time — with traceability.

## Identity model

Each test identity represents a separate business function.

| Identity | Business function | Intended access |
|---|---|---|
| Emma | HR | Normal business access relevant to HR |
| David | Developer | Development/application access |
| Hanna | Helpdesk | Support-related access without IAM administration |
| Simon | Security | Security monitoring access |
| Adam | IAM Administrator | Identity and access administration |

Using separate identities makes the effect of roles, groups and Least Privilege visible during the demo.

## Groups

Groups represent organizational or functional membership:

```text
HR
Developers
Helpdesk
Security
IAM-Admins
```

Groups are easier to govern than assigning every permission individually to every person.

## Roles

Roles represent permissions or access functions.

Examples in the current lab include:

```text
hr-user
gitea-developer
iam-admin
```

The current environment still contains the older role name `splunk-analyst` for Simon's Grafana Editor mapping. Splunk is no longer part of the architecture. The name is kept temporarily to avoid changing a working demo configuration and can later be renamed to something such as `security-analyst`.

## Birthright access

Birthright access is basic access that follows a person's employment or normal function.

Example:

```text
Developer -> normal developer account/application access
```

## Additional access

Not every entitlement should be included in the business role.

Additional access should be granted when a specific task or responsibility requires it.

Example:

```text
Developer -> access to a sensitive repository after approval
```

## Temporary access

Some access should exist only for a limited period.

A more mature IAM design would attach an expiry date or review requirement to temporary access.

## Least Privilege

Users should only receive permissions necessary for their current responsibilities.

Examples:

- Helpdesk should not automatically be a Keycloak administrator.
- A developer should not automatically receive security administration rights.
- An IAM administrator should not automatically be administrator in every connected application.
- A security analyst can view/operate monitoring without automatically being able to redesign IAM policy.

## Separation of Duties

High-impact capabilities should not automatically be concentrated in one identity.

Separating IAM administration from application and security operations reduces the risk associated with one compromised or misused account.

## Authentication vs authorization

### Authentication

Authentication verifies **who the user is**.

Keycloak performs this function in the lab.

### Authorization

Authorization determines **what the authenticated user is allowed to do**.

Groups, roles and application mappings influence authorization.

## Access management vs governance

### Access management

Operational actions such as:

- grant access
- modify access
- revoke access
- disable identity

### Access governance

The decisions and oversight around the access:

- Why does the person need it?
- Who approved it?
- Is it still appropriate?
- Does it create a conflict?
- Should it have expired?

The lab implements the technical management layer directly and uses the demo/documentation to show the governance questions around it.
