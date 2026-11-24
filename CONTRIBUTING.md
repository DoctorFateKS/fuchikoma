# Contributing to Fuchikoma

Thank you for your interest in Fuchikoma. This project is built in the open, and
every contribution is welcome: code, tests, documentation, benchmarks, bug
reports and reviews.

By taking part, you agree to follow our [Code of Conduct](CODE_OF_CONDUCT.md).
To report a security problem, **do not open a public issue**: follow
[SECURITY.md](SECURITY.md) instead.

## Ways to contribute

- **Report a bug or suggest an improvement** by opening an issue. Search the
  existing issues first.
- **Pick a task from the roadmap.** Releases are listed with their tasks as
  checkboxes: take the next unchecked one and say so in an issue before you
  start, so nobody duplicates the work.
- **Propose a larger change** through an RFC (see below).
- **Review pull requests.** Reading and commenting on other people's work is a
  real contribution.
## Setting up your environment

You need Ruby 3.4 or later.

```sh
git clone https://github.com/DoctorFateKS/fuchikoma.git
cd fuchikoma
bin/setup
```

`bin/setup` checks your Ruby version, installs Bundler if it is missing and
runs `bundle install`. Then check that everything works:

```sh
bundle exec rake            # tests, RuboCop and Steep
bundle exec rake test       # tests only
bundle exec rubocop         # style only
bundle exec steep check     # types only
```

The same three checks run in CI on Ruby 3.4 and 4.0 for every pull request.

## Making a change

1. Fork the repository and create a branch from `main`.
2. Make **one logical change** with its own tests. Aim for fewer than 400
   changed lines per commit.
3. Run `bundle exec rake` and fix what it reports.
4. Commit with a sign-off (see [Developer Certificate of Origin](#developer-certificate-of-origin)).
5. Open a pull request and describe what changed and why.
### Commit messages

We use [Conventional Commits](https://www.conventionalcommits.org/):

```
type(scope): subject
```

- **type** is one of `feat`, `fix`, `perf`, `refactor`, `test`, `docs`,
  `build`, `ci` or `chore`.
- **scope** is one of `runtime`, `router`, `schema`, `data`, `scope`, `view`,
  `front`, `realtime`, `jobs`, `auth`, `ai`, `cli`, `test`, `obs`, `deploy`,
  `i18n`, `gov`, `docs` or `ci`. It can be omitted for changes that touch the
  whole project.
- The subject is short, in the imperative mood, and has no final full stop.
Example: `feat(router): add 404 and 405 handling with Allow header`

### Definition of done for a commit

A change is ready to merge when:

- tests pass in CI on every supported Ruby version;
- the public API is typed in RBS and Steep passes;
- public methods are documented, with a runnable example;
- no new runtime dependency is added without an entry in [`DEPENDENCIES.md`](DEPENDENCIES.md)
  explaining why it is needed. The project aims for fewer than 15 runtime gems.
A change that needs a design decision links the RFC that records it.

### RFCs

Substantial changes (a new public concept, an API change, a new dependency, a
change of governance) go through a public RFC with a fixed comment period.
[GOVERNANCE.md](GOVERNANCE.md) describes the process. If you are unsure whether
your idea needs an RFC, open an issue and ask.

## Developer Certificate of Origin

Fuchikoma uses the Developer Certificate of Origin (DCO) instead of a contributor
licence agreement. You keep the copyright on your contribution, and no single
company can relicense the project.

To certify the DCO, **sign off every commit** by adding a line like this at
the end of the commit message:

```
Signed-off-by: Your Name <you@example.com>
```

Git adds it for you with the `-s` flag:

```sh
git commit -s -m "docs: fix a typo in the README"
```

The name and email must match your Git identity (`git config user.name` and
`git config user.email`), and the name should be the one you use publicly.
Pull requests with unsigned commits cannot be merged: an automated check
verifies the sign-off on every commit.

### Fixing a missing sign-off

For the last commit:

```sh
git commit --amend --signoff --no-edit
git push --force-with-lease
```

For several commits on your branch:

```sh
git rebase --signoff origin/main
git push --force-with-lease
```

### What you certify

The full text of the DCO, version 1.1, is reproduced below. It is
the same certificate used by the Linux kernel and many other projects.

> Developer Certificate of Origin
> Version 1.1
>
> Copyright (C) 2004, 2006 The Linux Foundation and its contributors.
>
> Everyone is permitted to copy and distribute verbatim copies of this
> license document, but changing it is not allowed.
>
> Developer's Certificate of Origin 1.1
>
> By making a contribution to this project, I certify that:
>
> (a) The contribution was created in whole or in part by me and I
>     have the right to submit it under the open source license
>     indicated in the file; or
>
> (b) The contribution is based upon previous work that, to the best
>     of my knowledge, is covered under an appropriate open source
>     license and I have the right under that license to submit that
>     work with modifications, whether created in whole or in part
>     by me, under the same open source license (unless I am
>     permitted to submit under a different license), as indicated
>     in the file; or
>
> (c) The contribution was provided directly to me by some other
>     person who certified (a), (b) or (c) and I have not modified
>     it.
>
> (d) I understand and agree that this project and the contribution
>     are public and that a record of the contribution (including all
>     personal information I submit with it, including my sign-off) is
>     maintained indefinitely and may be redistributed consistent with
>     this project or the open source license(s) involved.

## Licence

Code contributions are released under the [MIT licence](LICENSE). Documentation
text is released under CC BY 4.0, and code examples inside it under MIT.

## Getting help

Questions are welcome. Open a discussion or an issue, and mention what you
tried and what you expected. A mentoring programme and a monthly contributor
call are planned: they will be announced here once they exist.

