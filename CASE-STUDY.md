# IAM in Practice – Portfolio Case Study

## From Identity to Access

**IAM in Practice** is an individual cybersecurity project created during my Cybersecurity Officer education.

The project was completed during a four-week project period and was designed to turn Identity and Access Management concepts into something practical, visible and testable.

My career direction is toward entry-level roles such as **IAM Engineer, Security Engineer or Security Analyst**, where I can continue developing my practical security knowledge in a professional environment.

> **Important:** This is a local learning and demonstration environment, not a production deployment. NIS2 and ISO/IEC 27001 are used as security context and inspiration, not as a compliance claim.

---

# 1. Problem & Purpose

When I started learning about Identity and Access Management, many concepts were understandable individually but harder to connect into one complete flow.

Examples include:

- Identity
- Authentication
- Authorization
- Role-Based Access Control
- Single Sign-On
- Joiner / Mover / Leaver
- Least Privilege
- Access Governance

It is easy to associate IAM mainly with usernames, passwords and logging in. However, authentication is only one part of the problem.

An organization also needs to understand:

- Who is the user?
- What should the user have access to?
- Why should that access exist?
- What happens when the user's responsibilities change?
- When should access be removed?
- Can the activity be traced afterwards?

The central question for the project therefore became:

> **How do we make sure that the right person has the right access to the right resource at the right time — and that we can trace what happens?**

The purpose was to build a practical environment where I could follow the relationship between identity and access through the complete chain:

```text
Identity
   ↓
Group / Role
   ↓
Authentication
   ↓
Authorization
   ↓
Application Access
   ↓
Logging / Monitoring
   ↓
Review / Change / Removal
```

This made it possible to study IAM as a complete process rather than as isolated concepts.

---

# 2. My Role

This was an **individual project**, which meant I was responsible for the complete process from planning to final demonstration.

My responsibilities included:

- defining the purpose and scope
- planning the architecture
- selecting the technologies
- building the Docker-based environment
- configuring Keycloak as the central Identity Provider
- integrating Gitea and Grafana through OpenID Connect
- configuring users, groups and roles
- working with RBAC and Least Privilege
- creating Joiner, Mover and Leaver scenarios
- configuring centralized logging
- building an IAM security monitoring dashboard
- testing authentication and authorization
- troubleshooting integrations
- documenting architecture and design decisions in GitHub
- preparing and presenting the final practical demonstration

Although the project itself was individual, I had two feedback sessions with Tim during the project.

The feedback helped me challenge some of my original decisions and reconsider the size and focus of the environment.

One important lesson was that feedback does not always mean adding more functionality. In some cases, the better engineering decision is to remove unnecessary complexity.

---

# 3. Method & Tools

## Working method

I worked iteratively during the four-week project.

The project was divided into:

- **Must Have**
- **Nice to Have**
- **Future Development**

I also used a backlog and weekly planning in FigJam.

The original idea was significantly larger than the final implementation. It included additional applications and heavier components such as:

- Splunk
- GLPI

During implementation I realized that these components increased resource consumption, troubleshooting time, integration complexity and the risk of instability during the final demonstration.

They did not add enough value to the core IAM question to justify the additional complexity within four weeks.

I therefore changed the scope.

Instead of trying to demonstrate as many technologies as possible, I focused on building a stable end-to-end IAM flow.

## Final runtime architecture

```text
Keycloak
Gitea
Grafana
Promtail
Loki
Docker Compose
```

## Technology stack

| Technology | Purpose |
|---|---|
| **Keycloak** | Central Identity Provider and IAM platform |
| **Gitea** | Protected application for demonstrating SSO and application access |
| **Grafana** | SSO-enabled application and security monitoring |
| **Loki** | Central log storage and querying |
| **Promtail** | Log collection |
| **Docker Desktop** | Local container runtime |
| **Docker Compose** | Orchestration of the complete lab |
| **YAML** | Service and infrastructure configuration |
| **Visual Studio Code** | Main configuration and documentation environment |
| **Git Bash** | Command-line administration and troubleshooting |
| **Git / GitHub** | Version control and documentation |
| **FigJam** | Planning, backlog and process visualization |

## IAM concepts

The lab demonstrates or explores:

- Identity Management
- Authentication
- Authorization
- OpenID Connect
- Single Sign-On
- Role-Based Access Control
- Least Privilege
- Separation of Duties
- Joiner / Mover / Leaver
- Birthright access
- Additional access
- Temporary access
- Logging and traceability
- Access Governance principles

## Standards and security context

The project was also related to principles found in:

- ISO/IEC 27001
- NIS2

These were used as security context rather than as a claim that the lab itself is compliant.

---

# 4. Results

The result was a working practical IAM environment rather than only a theoretical design.

## Central Identity Provider

I configured **Keycloak** as the central Identity Provider.

Connected applications rely on Keycloak for authentication instead of maintaining completely separate authentication flows.

## Two connected applications

Two applications were integrated into the identity environment:

1. **Gitea**
2. **Grafana**

Both were connected to Keycloak using OpenID Connect.

This made it possible to demonstrate Single Sign-On and centralized authentication.

## Role-Based Access Control

The environment uses users, groups and roles to demonstrate Role-Based Access Control and Least Privilege.

A particularly important result was being able to demonstrate that:

> **A valid identity and successful authentication do not automatically mean that a user should be authorized to access every application.**

That made the difference between authentication and authorization much clearer in practice.

## Identity lifecycle

The project demonstrates the three main identity lifecycle scenarios:

```text
Joiner
Mover
Leaver
```

The Mover scenario was especially useful because it showed that IAM is not only about granting new access.

Old access must also be removed when a person's responsibilities change. Otherwise, permissions can accumulate over time.

## Security monitoring

Identity and access-related activity was connected to a central monitoring flow:

```text
Identity / Application activity
            ↓
         Promtail
            ↓
           Loki
            ↓
         Grafana
```

The Grafana dashboard was designed to make authentication activity easier to understand than reading raw log lines.

The main dashboard views included:

- Failed Logins
- Failed Login Events
- Successful Logins
- Successful Login Events

The environment could therefore demonstrate not only identity and access configuration but also traceability.

## Final delivery

Instead of delivering a larger but less reliable architecture, I delivered a smaller environment where the main IAM concepts could be demonstrated from identity creation through application access and monitoring.

That scope decision became one of the most important results of the project.

---

# 5. Lessons Learned

## IAM is more than authentication

One of the largest changes in my understanding was realizing that IAM is much broader than logging users into systems.

Authentication answers:

> **Who are you?**

Authorization answers:

> **What are you allowed to do?**

But IAM also requires questions such as:

- Why does this person have access?
- Is the access still required?
- What happens when the person's role changes?
- Who removes obsolete access?
- Can we trace what happened?

This changed the way I looked at the entire project.

## SSO does not automatically solve authorization

Single Sign-On centralizes authentication and can improve the user experience.

However, successful authentication should not automatically provide access to every application.

A user may successfully authenticate through the Identity Provider and still be denied access because the required authorization is missing.

This became one of the clearest practical examples in the project of the difference between authentication and authorization.

## Roles should not contain every possible permission

Another important lesson was related to role design.

It may initially seem convenient to give a business role every permission that a person might eventually need. However, this creates unnecessary access.

A more controlled model separates:

```text
Birthright access
Additional / requested access
Temporary access
```

This supports Least Privilege and makes access easier to understand and govern.

## Integration problems were more difficult than the definitions

Many of the hardest problems in the project were not understanding IAM terminology. They were integration problems.

Examples included:

- OIDC redirect URLs
- browser URLs versus Docker-internal hostnames
- persistent Keycloak data
- application role mapping
- authentication events
- log parsing
- YAML structure
- Docker networking
- Git Bash path conversion
- storage and resource limitations

This taught me that practical IAM work requires a combination of security knowledge, system understanding, troubleshooting, patience and structured testing.

My previous experience from test and verification was useful because I was already used to isolating problems, reproducing behaviour and analysing possible root causes.

## Scope management is a technical skill

My original project idea was too large for the available time and hardware.

Instead of continuing to add systems because they were part of the original plan, I evaluated which components actually supported the central project question.

Splunk and GLPI were removed from the final scope.

The result was a more stable and understandable environment.

This taught me an important lesson:

> **More technology does not automatically create a better solution.**

A good solution should support the purpose and constraints of the project.

## Feedback is input, not an automatic instruction

Because the project was individual, I was responsible for the final decisions.

However, the feedback sessions helped me reconsider assumptions and improve the project.

I learned that feedback still needs to be evaluated.

For each suggestion I needed to consider:

- Does this support the purpose?
- Is it realistic within four weeks?
- Does it improve the IAM demonstration?
- Does it create unnecessary complexity?

This is relevant to professional security work because technical decisions often need to balance security, business needs, resources and practical feasibility.

## Connection to my future role

The project strengthened my interest in roles such as:

- IAM Engineer
- Security Engineer
- Security Analyst

I am still at the beginning of my professional cybersecurity career and need experience from real production environments.

However, the project gave me practical experience with concepts such as:

- identity lifecycle
- SSO
- OIDC
- RBAC
- authentication
- authorization
- Least Privilege
- access control
- logging
- troubleshooting
- security monitoring

It gave me a practical foundation that I can now continue developing in a professional environment.

---

# 6. Next Steps

The project was deliberately limited to a four-week educational scope.

If I continued developing the environment, I would focus more heavily on automation and governance.

## Automated Joiner / Mover / Leaver

Connect the IAM environment to an authoritative identity source such as an HR system.

Identity changes could then trigger automatic lifecycle actions.

## Automated provisioning

Use APIs or SCIM to automatically create, update and remove accounts in connected applications.

## Access requests and approvals

Introduce workflows where users can request additional access that requires justification and approval.

## Periodic access reviews

Allow managers or application owners to periodically verify whether access is still appropriate.

## Temporary access

Introduce time-limited permissions that automatically expire.

## Identity Governance and Administration

As the number of users, applications and access relationships grows, an IGA layer could provide stronger governance, access reviews and lifecycle automation.

## Privileged Access Management

Privileged administrative identities could be protected and managed separately from normal user accounts.

## Context-aware access

Future development could include stronger MFA requirements and contextual access decisions.

## Larger open-source learning environment

The project I delivered during the course was a deliberately reduced version of my original idea.

I would like to continue developing the larger version in the future.

The goal could be to create an open-source IAM learning environment for people who, like me when I started, are new to IAM and want to understand the basic principles by actually testing them.

Instead of only reading about users, groups, roles, SSO, RBAC, lifecycle, governance and monitoring, a learner could interact with the environment and see how the components affect each other.

That would turn the project from an educational assignment into a reusable practical learning environment.

---

# Conclusion

IAM in Practice started as a way for me to understand Identity and Access Management beyond definitions and diagrams.

The most valuable result was not one specific application or technology.

It was understanding how the different parts connect:

```text
Identity
   ↓
Group / Role
   ↓
Authentication
   ↓
Authorization
   ↓
Application Access
   ↓
Logging / Monitoring
   ↓
Review / Change / Removal
```

Building, breaking, troubleshooting and simplifying the environment made those relationships visible.

It also confirmed that Identity and Access Management is an area I want to continue developing within as I move from cybersecurity education into professional security work.

---

## Main project repository

**IAM in Practice – From Identity to Access**

https://github.com/mario900606-code/IAM-in-Practice
