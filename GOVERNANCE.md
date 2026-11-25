# Fuchikoma Governance

The 2025 RubyGems dispute showed what happens when control, money and access
rules are left implicit. Fuchikoma writes them down before the first release.
This document says who decides, how decisions are made, how people gain and
lose responsibility, and where the project's assets live.

It applies to the code, the documentation, the infrastructure and the
community spaces of the project.

## Principles

1. **Public by default.** Decisions, discussions and votes happen in public
   places and are recorded in the repository.
2. **No single point of control.** No individual and no company can decide
   alone, relicense the code or take over the project's assets.
3. **Money buys no votes.** Sponsors and employers have no say in technical
   decisions.
4. **Written rules.** Roles, powers and procedures are documented here, and
   changing them follows a documented process.

## Roles

### Contributor

Anyone who takes part in the project: opening issues, reviewing, writing code,
tests, documentation or benchmarks. A contributor with at least one merged pull
request is listed as such. Every contributor follows the
[Code of Conduct](CODE_OF_CONDUCT.md) and signs off their commits as described
in [CONTRIBUTING.md](CONTRIBUTING.md).

### Committer

A contributor trusted with write access to the repository. Committers review
and merge pull requests, triage issues and help newcomers. They do not publish
releases and do not sit on the steering group by virtue of that role alone.

### Maintainer

A committer who is also responsible for the direction and health of the
project. Maintainers vote on RFCs and are eligible for the steering group.
A maintainer can also become a release manager, the only role that may publish
releases (see [Release managers](#release-managers)).

## Maintainer ladder

The path from contributor to maintainer is written down so that nobody has to
guess what is expected.

| Step | Typical expectations | Decided by |
|------|----------------------|------------|
| Contributor to committer | Several merged pull requests over at least three months, good reviews, respectful behaviour, knowledge of one area of the code | Nomination by a maintainer, then approval by a majority of maintainers after seven days of public comment |
| Committer to maintainer | At least six months as a committer, a record of reviewing across several areas, involvement in at least one RFC, willingness to share the maintenance load | Nomination by a maintainer, then approval by a two-thirds majority of maintainers |

These expectations are guidelines, not a checklist: the judgement of the
maintainers, given in public and with reasons, is what counts.

### Stepping down and inactivity

Anyone can step down at any time. A committer or maintainer with no activity
for twelve months is asked whether they wish to continue; if not, they move to
**emeritus** status, keep the thanks of the project and can return through a
simple request to the maintainers.

### Removal

Removing a committer or a maintainer against their will requires a **public
vote** of the maintainers and a **stated reason**, recorded in the repository.
The person concerned can answer before the vote and does not vote. Conduct
cases follow the Code of Conduct enforcement process instead.

### Access reviews

Write access, release rights and administrative access to the repository, the
package registry and the infrastructure are reviewed **twice a year**. Access
that is no longer needed is removed, and the result of each review is recorded.
The review also checks that every release manager still meets the
[requirements](#requirements-for-every-release-manager) below.

## Release managers

A release manager is a maintainer who may publish a release. Pushing a release
tag and publishing to the package registry are limited to release managers, so
that a stolen account or a mistaken push cannot ship code to every user.

### Requirements for every release manager

Every release manager must:

1. **Use multi-factor authentication** on their GitHub account and on their
   RubyGems.org account. A passkey or a hardware security key is preferred. A
   code sent by SMS is not accepted.
2. **Sign every release tag.** Tags are created with `git tag -s`, using an SSH
   or GPG key that is registered as a signing key on the release manager's
   GitHub account, so that GitHub shows the tag as verified.
3. **Keep the keys safe.** Signing keys are protected by a passphrase or held
   on a hardware device, and are never shared.
4. **Report a loss at once.** A lost device, a lost key or a suspected
   compromise is reported to the other maintainers without delay. The key is
   revoked and replaced.

Releases are published by the release workflow through RubyGems trusted
publishing, so no long-lived API key is stored in the repository or on a
personal machine. The gemspec also sets `rubygems_mfa_required`, so that any
manual operation on the gem requires MFA.

### How the requirements are enforced

- **Tags.** Creating, moving or deleting a `v*` tag is restricted to release
  managers by a repository rule. The release workflow publishes only a tag that
  GitHub reports as verified, and refuses an unsigned one.
- **Accounts.** The owners of the gem on RubyGems.org are the release managers
  and nobody else, and each of them has MFA enabled.
- **Reviews.** The twice-yearly access review checks both points.

### Appointing and suspending release managers

The steering group appoints release managers among the maintainers and lists
them in `MAINTAINERS.md`, published when the project passes gate A. Until then,
the founding maintainer is the only release manager.

Release rights are suspended without delay when a requirement stops being met,
for example when MFA is disabled or a tag is pushed unsigned, and are restored
as soon as it is met again. A suspension is not a removal: removing a
maintainer follows the [removal rules](#removal).

## Steering group

The steering group is the body that arbitrates when consensus cannot be
reached and that looks after the project as a whole: roadmap, budget, releases
calendar, governance changes and relations with the fiscal host.

- It has **three to five maintainers**.
- **No more than two members** may work for the same employer (or be
  contractors of it).
- Members act in the interest of the project, not of their employer.
- Its current members are listed in `MAINTAINERS.md`, published when the
  project passes its first gate (see [Releases and gates](#releases-and-gates)).

### Membership and vacancies

The first steering group is formed by the founding maintainers. Afterwards, a
vacancy is filled by a vote of the existing steering group among maintainers
who have declared their candidacy in public, while keeping the employer limit.
A member who leaves a company that is already represented twice does not
cause a vacancy: the group simply re-balances at the next appointment.

### Conflicts of interest

A member declares any personal or employer interest in a topic and does not
vote on it when the interest is direct. If the employer limit would be broken
by a change of job, the group has three months to restore the balance.

## How decisions are made

### Everyday changes: lazy consensus

Bug fixes, small features, refactorings and documentation changes are decided
in the pull request. A change can be merged when a committer other than the
author approves it, CI is green and no maintainer has raised a reasoned
objection. Authors do not merge their own work without a review.

### Substantial changes: RFCs

Anything that changes the project's public surface or its direction needs a
public **RFC** (Request for Comments) first. This includes:

- a new public concept or a breaking change to the API;
- a new runtime dependency;
- a change to the roadmap, the release policy or the supported Ruby versions;
- a change to this governance document.

If you are unsure whether something needs an RFC, ask in an issue.

### The RFC process

1. **Draft.** The author copies the RFC template into `rfcs/` as a pull
   request, with the next free number and a short title (for example
   `rfcs/001-fiber-runtime.md`).
2. **Public comment period of 14 days.** The pull request stays open for at
   least 14 calendar days so that everyone has time to comment. The period
   restarts if the proposal changes in a significant way.
3. **Discussion and revision.** The author answers comments and updates the
   text. Unresolved objections are summarised in the RFC.
4. **Decision.** After the comment period, a maintainer proposes to accept,
   reject or postpone the RFC. It is **accepted** when a majority of the
   steering group agrees and no unresolved blocking objection remains; blocking
   objections are decided by the steering group's vote. Votes and reasons are
   public.
5. **Recording.** The RFC is merged with its final status (accepted, rejected,
   postponed or withdrawn). Accepted RFCs are linked from the commits that
   implement them.
6. **Implementation and changes.** Implementation follows the normal pull
   request flow. A later change to an accepted decision needs a new RFC.

Smaller architectural decisions that do not need a full RFC are recorded as
architecture decision records (ADRs) in the repository.

### Voting

When a vote is needed, it is held in public, lasts at least seven days
(except for urgent security matters), and counts the votes of the people
entitled to vote on that topic. Unless this document says otherwise, a
majority of the votes cast decides, and a tie means the proposal is not
adopted. A quorum of more than half of the eligible voters is required.

## Conduct and enforcement

The [Code of Conduct](CODE_OF_CONDUCT.md) applies to everyone, including
maintainers. Reports go to the named enforcement contacts, who must not have
a conflict of interest in the case. Contacts report to the steering group in
anonymised form at least once a year. A report that concerns a member of the
steering group is handled without that member.

## Security

Vulnerabilities are handled privately following [SECURITY.md](SECURITY.md),
with a 90-day target for fixing confirmed issues. The private disclosure
address is monitored by at least two maintainers.

## Releases and gates

- Releases follow Semantic Versioning: two minor releases a year, and at most
  one major release a year.
- The last minor release of each major version receives fixes for 18 months,
  and security fixes cover the two most recent majors.
- Releases are published to RubyGems.org with trusted publishing and
  multi-factor authentication, by a release manager who meets the
  [requirements](#requirements-for-every-release-manager). Every release is
  tagged with a signed tag, and an SBOM is attached.
- Each phase of the roadmap ends with a **gate** that must be passed before the
  next phase starts. If a gate slips by more than one quarter, the steering
  group cuts scope rather than lowering the gate.
- **Gate A** requires three maintainers from at least two employers and a
  fiscal host to be published.

## Assets, money and neutrality

- The **repository, the trademark and the domain names** are held by a
  non-profit host or fiscal sponsor, never by an individual or a company. Until
  the host is in place (gate A), the founding maintainers hold them in trust
  for the project and transfer them as soon as it is.
- There is **no contributor licence agreement**. Contributors keep their
  copyright and certify their work with the Developer Certificate of Origin,
  so no single company can relicense the code.
- Funding comes from sponsorship and donations through the fiscal host. The
  **budget is published**. Sponsors may be thanked and listed, but **no sponsor
  gets a vote** on technical decisions or on the composition of the steering
  group.
- The name and logo may be used for compatible plugins and community
  meetups, following a trademark policy published at launch.

## Communication

Discussions take place in public: issues, pull requests, the project forum and
chat. Decisions that matter are written down in RFCs, ADRs or pull request
comments, not left to private conversations.

## Changing this document

This document can be changed through the RFC process. Changes that touch the
steering group's composition, the voting rules, the neutrality of the project
or the removal rules need approval by a **two-thirds majority** of the
steering group, after the full public comment period.
