# Changelog

All notable changes to Fuchikoma are recorded in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and the project follows [Semantic Versioning](https://semver.org/). Before
1.0.0, a minor release may change the API, with a note in this file.

## [Unreleased]

## [0.0.2] - 2026-11-25

Supply chain and release automation. There is still no framework code.

### Added

- `DEPENDENCIES.md`, the policy of fewer than 15 runtime gems, each justified.
- Dependabot for Bundler and GitHub Actions, and a `bundler-audit` workflow
  that runs on every pull request, on `main` and every week.
- A tag-triggered release workflow that publishes to RubyGems.org with trusted
  publishing. Running it by hand is a dry run that publishes nothing.
- Release tag checks (`.github/scripts/check-release-tag.sh`): tag name,
  version, changelog section, signature verified by GitHub and tagged commit
  on `main`.
- A reproducible gem build, with build provenance attestations for the gem and
  its SBOM, and a `SHA256SUMS` file.
- A CycloneDX 1.6 SBOM of the gem and its runtime dependencies
  (`.github/scripts/generate-sbom.sh`), attached to every GitHub release.
- Release notes taken from this changelog, and 0.x releases marked as
  pre-releases.
- The release manager rules in `GOVERNANCE.md`: multi-factor authentication
  and signed tags are required.
- `RELEASING.md`, the release runbook.

### Changed

- The repository moved to `KevinSaison/fuchikoma`, and its links were updated.
- The development dependency on minitest moved to 6.1.

## [0.0.1] - 2026-11-24

First release: the repository skeleton. There is no framework code yet.

### Added

- MIT licence, Contributor Covenant 2.1 code of conduct and a security policy
  with a private disclosure address.
- An empty gem (`fuchikoma.gemspec`, `Gemfile`, `Rakefile`, `.ruby-version` and
  `bin/setup`) that exposes `Fuchikoma::VERSION`.
- A GitHub Actions workflow running RuboCop, Steep and the tests on Ruby 3.4
  and 4.0.
- `CONTRIBUTING.md` with the Developer Certificate of Origin sign-off, and a
  pull request check that enforces it.
- `GOVERNANCE.md` describing the steering group, the RFC process and the
  maintainer ladder.
- Issue templates, a pull request template and `CODEOWNERS`.
- A README with the vision, a status banner and the non-goals.

[Unreleased]: https://github.com/KevinSaison/fuchikoma/compare/v0.0.2...HEAD
[0.0.2]: https://github.com/KevinSaison/fuchikoma/compare/v0.0.1...v0.0.2
[0.0.1]: https://github.com/KevinSaison/fuchikoma/releases/tag/v0.0.1
