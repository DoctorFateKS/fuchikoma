# Fuchikoma

[![CI](https://github.com/KevinSaison/fuchikoma/actions/workflows/ci.yml/badge.svg)](https://github.com/KevinSaison/fuchikoma/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
![Ruby 3.4+](https://img.shields.io/badge/ruby-3.4%2B-red.svg)

**The Ruby framework for one-process, fiber-native web applications with typed
boundaries, secure-by-default data access and first-class agent support.**

> [!WARNING]
> **Status: pre-alpha, version 0.0.1. There is no framework code yet.**
> The repository currently holds an empty gem, the project's governance and
> its continuous integration. Nothing here is usable for an application, and
> nothing is stable. The name "Fuchikoma" is a working name and may change
> before 1.0. Follow the progress, join the discussion, and see
> [Contributing](#contributing) if you want to help build it.

## Why Fuchikoma

Ruby has one dominant full-stack framework, one serious architectural
alternative and several small or API-focused tools. None combines
fiber-native concurrency, an integrated front-end story and a typed,
agent-ready surface.

Fuchikoma keeps what Rails taught the world (conventions, generators, one-person
productivity) and changes four defaults:

| Default | Rails-style today | Fuchikoma |
|---------|-------------------|---------|
| **Concurrency** | Threads and processes | Every request, job and socket runs in its own fiber, on the Ruby fiber scheduler |
| **Contracts** | Implicit, checked at runtime | Request, response and view props are declared once as schemas; validation, OpenAPI 3.1 and RBS signatures come from them |
| **Tenancy** | Each query must remember to scope itself | A scope object travels through every request, query and job; unscoped access is explicit and logged |
| **AI** | A library you bolt on | Tools, agents, streaming and evals are framework concepts, and any route can be exposed as an MCP tool |

## Who it is for

1. **Solo developers and small teams** building SaaS products who want a single
   deployable unit. This is the primary audience.
2. **Rails teams** that want a lighter, typed service for a new bounded
   context, running as a *sidecar* beside the existing app and sharing its
   database, session and scope.
3. **Teams building AI-enabled backends** in Ruby, without adding a Python or
   Node service.

## Design principles

1. **Boring by default, explicit when it matters.** Generated code is plain
   Ruby that you own; no hidden metaprogramming in the core flow.
2. **One process first.** Web, jobs, real-time and scheduled work run in one
   process on one machine. Scaling out is configuration, not a rewrite.
3. **Schema once, everywhere.** One declaration yields validation,
   serialization, OpenAPI, RBS and test fixtures.
4. **Secure by construction.** The scope is part of every request, query and
   job; leaving it out is a deliberate, logged act.
5. **Small core, honest dependencies.** Fewer than 15 runtime gems, each pinned
   and justified. Everything else is a plugin.
6. **Agents are users too.** Every convention is documented in
   machine-readable form (`AGENTS.md`, MCP descriptors) from the first
   generated app.

## Non-goals

Fuchikoma deliberately does **not** try to be:

- **A Rails clone or drop-in replacement.** A compatibility layer is a plugin,
  not the core.
- **A JavaScript front-end framework.** Fuchikoma renders on the server and
  supports islands for the parts that need client-side code.
- **A new ORM.** Version 1 integrates Sequel and ActiveRecord through one
  adapter interface.
- **A hosting product.** Deployment targets are a plain VM, containers and
  Kamal-style tools.

## Roadmap

The project advances in four phases, each closed by a gate that must be
passed before the next phase starts.

| Phase | Versions | Goal |
|-------|----------|------|
| Foundation | 0.0.x | Governance, supply chain, RFCs and a public benchmark harness. Ends at gate A: three maintainers and a fiscal host |
| Walking skeleton | 0.1.x to 0.2.x | A fiber server, a router, schemas, a CLI, data and scopes, and a first sidecar demo beside Rails |
| Public beta | 0.3.x to 0.5.x | Views, real-time, jobs, authentication, observability, testing, and real users |
| Release 1.0 | 0.6.x to 1.0.0 | AI agents and MCP, islands, upgrade tool, deployment, performance and API freeze |

Claims about speed will be backed by published, reproducible benchmarks, and
the benchmark harness is built before the framework itself. The detailed
release-by-release roadmap will be published in this repository.

## Contributing

Contributions of every kind are welcome: code, tests, documentation,
benchmarks, bug reports and reviews.

- Read [CONTRIBUTING.md](CONTRIBUTING.md) for the workflow, the commit format
  and the Developer Certificate of Origin sign-off required on every commit.
- Read [GOVERNANCE.md](GOVERNANCE.md) to learn how decisions are made, how the
  RFC process works and how to become a committer or maintainer.
- Follow the [Code of Conduct](CODE_OF_CONDUCT.md) in every project space.

To set up a development environment you need Ruby 3.4 or later:

```sh
git clone https://github.com/KevinSaison/fuchikoma.git
cd fuchikoma
bin/setup
bundle exec rake   # tests, RuboCop and Steep
```

## Security

Please do not report vulnerabilities in public issues. Follow
[SECURITY.md](SECURITY.md) to report them privately.

## Licence

Fuchikoma is released under the [MIT licence](LICENSE). There is no contributor
licence agreement: contributors keep their copyright and certify their work
with the Developer Certificate of Origin.
