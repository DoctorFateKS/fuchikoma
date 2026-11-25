# Dependencies

Fuchikoma keeps a small core and honest dependencies. This document states the
policy, lists every runtime dependency with the reason it exists, and explains
how to add or remove one.

## Policy

1. **Fewer than 15 runtime gems.** The count covers every gem that
   `fuchikoma.gemspec` declares with `add_dependency`, direct dependencies
   only. The limit applies to the core gem; optional adapters and plugins ship
   as separate gems with their own lists.
2. **Each one is justified.** A runtime dependency has an entry in this file
   before it is merged. No entry, no merge.
3. **Everything else is a plugin.** If a feature can live in a separate gem
   behind a published interface, it does.
4. **Pinned and compatible.** Every dependency uses a pessimistic version
   constraint (`~>`), and its licence must be compatible with the project's
   MIT licence.
5. **Maintained and auditable.** A dependency must have a public source
   repository, recent maintenance activity and a way to report vulnerabilities.
   Dependabot and `bundler-audit` watch for known issues in CI.
6. **Prefer the standard library and default gems** when they do the job well
   enough.
7. **Adding one is a public decision.** A new runtime dependency needs an RFC
   (see [GOVERNANCE.md](GOVERNANCE.md#the-rfc-process)) and a commit that
   links it, as [CONTRIBUTING.md](CONTRIBUTING.md#definition-of-done-for-a-commit)
   requires.

## Current status

| Kind | Count | Limit |
|------|-------|-------|
| Runtime dependencies | 0 | fewer than 15 |

Version 0.0.1 is an empty gem and declares no runtime dependency.

## Runtime dependencies

None yet.

Each future entry uses the template below.

### Entry template

```markdown
### gem-name

- **Used for:** what Fuchikoma needs it for, in one sentence.
- **Why not the standard library or our own code:** the reason this is a
  dependency.
- **Alternatives considered:** other gems or approaches, and why they lost.
- **Licence:** SPDX identifier, which must be MIT-compatible.
- **Maintenance:** maintainers, last release, how vulnerabilities are reported.
- **Version constraint:** the constraint used in the gemspec.
- **Added in:** release and RFC or commit that introduced it.
- **Removal plan:** how Fuchikoma would stop using it if it were abandoned.
```

## Development dependencies

These gems are used to build, test and check the project. They are not
installed by people who use Fuchikoma, so they do not count toward the limit.
They are declared in the `Gemfile`.

| Gem | Purpose |
|-----|---------|
| `minitest` | Test framework for the project's own suite |
| `rake` | Task runner for tests, RuboCop and Steep |
| `rbs` | Type signatures for the public API |
| `steep` | Type checker run in CI |
| `rubocop` | Style checks run in CI |

## Anticipated needs

The roadmap points to areas where a dependency is likely. This list is a
reminder, not a decision: each item still needs its own RFC and entry, and
the alternative of writing the code in the core stays open.

- Fiber scheduler backend (`io-event` is the candidate).
- Code reloading (Zeitwerk).
- Persistence (Sequel first, ActiveRecord through a separate adapter).
- MCP server (the official MCP Ruby SDK, in the separate AI gem).
- Password hashing and passkeys (Argon2 and WebAuthn libraries).
- Telemetry (OpenTelemetry gems, which may be optional).

If these all landed in the core, the count would approach the limit. Where
possible they move to optional gems, so that the core stays under 15.

## Reviewing the list

- Every release re-checks this file against the gemspec. The definition of
  done for a release includes it.
- Dependabot and `bundler-audit` report outdated or vulnerable gems.
- A dependency that is abandoned, relicensed incompatibly or repeatedly
  vulnerable is replaced or removed. The removal follows the same RFC process
  as an addition.
