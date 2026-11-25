## Summary

<!-- What does this change do, and why? Keep it to one logical change. -->

## Related issue, roadmap item or RFC

<!-- Closes #123 · Roadmap: v0.X.Y · RFC 00N (required when a design decision is involved) -->

## Type of change

<!-- Keep the one that applies. -->

- [ ] `feat`: new capability
- [ ] `fix`: bug fix
- [ ] `perf`: performance improvement
- [ ] `refactor`: no behaviour change
- [ ] `test`, `docs`, `build`, `ci` or `chore`

## Checklist

Please read [CONTRIBUTING.md](https://github.com/KevinSaison/fuchikoma/blob/main/CONTRIBUTING.md) first.

- [ ] **Every commit is signed off** (`git commit -s`) to certify the
      [Developer Certificate of Origin](https://github.com/KevinSaison/fuchikoma/blob/main/CONTRIBUTING.md#developer-certificate-of-origin).
      The DCO check fails otherwise.
- [ ] Commit messages follow Conventional Commits: `type(scope): subject`.
- [ ] The change is one logical change, usually under 400 changed lines.
- [ ] Tests cover the change and `bundle exec rake` passes locally.
- [ ] Public API is typed in RBS and `bundle exec steep check` passes.
- [ ] Public methods are documented with a runnable example.
- [ ] No new runtime dependency, or it is justified in `DEPENDENCIES.md`.
- [ ] The roadmap checkbox is ticked, if this delivers one.

## Notes for reviewers

<!-- Anything that needs attention: trade-offs, follow-ups, screenshots, benchmark results. -->
