# Security Policy

Fuchikoma is a web framework: security reports are taken seriously and handled
privately until a fix is available.

## Reporting a vulnerability

**Do not open a public issue, pull request or discussion for a security problem.**

Report it privately by either of these routes:

1. Email **saisonkevin@protonmail.com**.
2. Use GitHub's "Report a vulnerability" button in the repository's *Security*
   tab.

If you want to encrypt your report, ask for a PGP key at the address above and
we will send one before you share any details.

Please include:

- the affected version or commit;
- a description of the issue and its impact;
- steps or a minimal proof of concept to reproduce it;
- any suggested fix, if you have one.

## What to expect

| Step | Target |
|------|--------|
| Acknowledgement of your report | within 3 working days |
| First assessment (severity, affected versions) | within 10 working days |
| Fix released for a confirmed issue | within 90 days |

We keep you informed at each step. If a fix needs more than 90 days, we will
explain why and agree a disclosure date with you.

## Coordinated disclosure

- We ask that you keep the report private until a fix is released or the
  agreed disclosure date is reached.
- Confirmed issues receive a GitHub Security Advisory and, where relevant, a
  CVE identifier.
- Reporters are credited in the advisory unless they prefer to stay anonymous.

## Supported versions

Fuchikoma is pre-1.0 and under active development.

| Version | Supported |
|---------|-----------|
| Latest 0.x minor release | Yes |
| Older 0.x releases | No |

From 1.0.0, security fixes are provided for the two most recent major versions,
and the last minor of each major receives fixes for 18 months.

## Scope

In scope: the code in this repository, the published gems, and the release
process (workflows, signing, SBOM).

Out of scope: vulnerabilities in third-party dependencies that are not
exploitable through Fuchikoma (please report those upstream), social engineering,
and denial of service through unrealistic resource exhaustion.

## Safe harbour

We will not pursue legal action against people who report vulnerabilities in
good faith, avoid privacy violations and data destruction, and follow this
policy.
