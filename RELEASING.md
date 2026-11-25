# Releasing Fuchikoma

This runbook describes how a release manager ships a version of Fuchikoma, from
the pull request that prepares it to the checks that prove it worked. It
follows the rules in [GOVERNANCE.md](GOVERNANCE.md#release-managers) and the
automation in [`.github/workflows/release.yml`](.github/workflows/release.yml).

Only a release manager may publish a release. If you are not one, you can still
help by preparing the release pull request (step 1) and by reviewing it.

## How a release works

A release is started by pushing a signed tag named `vX.Y.Z`. The release
workflow then runs these jobs in order:

| Job | What it does |
|-----|--------------|
| `verify` | Checks the tag (name, version, changelog, signature, commit on `main`), then runs RuboCop, Steep, the tests and `bundler-audit` |
| `build` | Builds the gem twice and checks that both builds are identical, writes a CycloneDX SBOM and the checksums, and attests the gem and the SBOM |
| `publish` | Publishes the gem to RubyGems.org through trusted publishing, after a release manager approves the `release` environment, then checks that the published gem is the attested one |
| `github-release` | Creates the GitHub release with the gem, the SBOM and `SHA256SUMS` attached |

Starting the workflow by hand (**Actions → Release → Run workflow**) is a **dry
run**: it runs `verify` and `build` and uploads the result as a workflow
artifact, but publishes nothing.

Nothing is stored on a personal machine: no RubyGems API key, no signing key
for the gem. The only secret a release manager holds is the key that signs the
tag.

## One-time setup

Do this once, before the first release.

**GitHub**

1. Enable multi-factor authentication on your account, with a passkey or a
   security key if possible.
2. Add your SSH or GPG key as a **Signing Key** (Settings → SSH and GPG keys),
   and check that the email you use in Git is verified on your account.
3. Configure Git to sign tags:
   ```sh
   git config --global gpg.format ssh
   git config --global user.signingkey ~/.ssh/id_ed25519.pub
   git config --global tag.gpgSign true
   ```
4. Create the environment **`release`** (Settings → Environments). Add the
   release managers as required reviewers, and limit deployments to tags
   matching `v*`. While there is a single release manager, leave "Prevent
   self-review" off; turn it on once there are two.
5. Create a tag ruleset for `v*` (Settings → Rules → Rulesets) that restricts
   creation, updates and deletion, with the release managers as the only
   bypass actors.

**RubyGems.org**

1. Enable multi-factor authentication on your account, at the "UI and API"
   level.
2. For the first release, create a **pending trusted publisher** (your profile →
   Trusted publishers) with the gem name `fuchikoma`, the repository owner and
   name (`KevinSaison/fuchikoma`), the workflow file `release.yml` and the
   environment `release`. After the first push, RubyGems turns it into a
   regular trusted publisher. A pending trusted publisher expires after a
   short delay, so create it just before you push the first tag.
3. Note the numeric **account ID** shown on the Pending Trusted Publishers
   page, and save it as the repository variable `RUBYGEMS_OWNER` (Settings →
   Secrets and variables → Actions → Variables). RubyGems.org lets trusted
   publishing create a new gem only if the workflow names the account that
   will own it, and the release workflow does so while this variable is set.
   **Delete the variable after the first release**: from then on the gem
   exists and the variable is no longer needed.
4. Check that the release managers are the only owners of the gem.

## Releasing

### 1. Prepare the release

On a branch, in one pull request:

1. Set the new version in `lib/fuchikoma/version.rb`.
2. In `CHANGELOG.md`, move the entries from `[Unreleased]` into a new section
   titled `## [X.Y.Z] - YYYY-MM-DD`, and update the links at the bottom of the
   file. The release workflow refuses a version with no dated section.
3. Check `DEPENDENCIES.md` against the gemspec: every runtime dependency needs
   an entry, and there must be fewer than 15.
4. Tick the roadmap checkboxes that this release delivers, and complete the
   rest of the definition of done (see the checklist at the end of this file).
5. Run the checks locally:
   ```sh
   bundle exec rake
   .github/scripts/check-release-tag.sh --dry-run
   ```
6. Sign off every commit (`git commit -s`), open the pull request and merge it
   once CI and the DCO check pass and it has been reviewed as GOVERNANCE.md
   requires.

### 2. Run the dry run

After the pull request is merged, run **Actions → Release → Run workflow** on
`main`. The `verify` and `build` jobs must pass; `publish` and `github-release`
are skipped.

Download the `release-dist` artifact and check it:

```sh
sha256sum -c SHA256SUMS
gh attestation verify fuchikoma-X.Y.Z.gem --repo KevinSaison/fuchikoma
gh attestation verify fuchikoma-X.Y.Z.cdx.json --repo KevinSaison/fuchikoma
```

Open the SBOM and check that the gem is the main component and that the
runtime dependencies are the ones you expect. A gem with no runtime
dependencies has an empty `components` list.

The dry run does not check the tag signature, since there is no tag yet. That
check runs in step 3.

### 3. Tag the release

On an up-to-date `main`:

```sh
git switch main
git pull --ff-only
git tag -s vX.Y.Z -m "Fuchikoma X.Y.Z"
.github/scripts/check-release-tag.sh --offline vX.Y.Z
```

Check that the tag is signed (`git cat-file -p vX.Y.Z` shows a signature block).
Then push it. **This starts the real release.**

```sh
git push origin vX.Y.Z
```

Publishing is irreversible: a version number published on RubyGems.org can be
yanked but never reused. Be sure of the version before you push.

### 4. Approve the publication

The workflow runs `verify` and `build`, then waits at `publish` for your
approval of the `release` environment. Before you approve, look at the
`verify` and `build` logs. Approve in the Actions page. The workflow then
publishes the gem and creates the GitHub release.

### 5. Check the result

1. The workflow run is green, and the GitHub release has three assets: the gem,
   the `.cdx.json` SBOM and `SHA256SUMS`.
2. The version appears on rubygems.org/gems/fuchikoma.
3. The published gem is the attested gem. In an empty directory:
   ```sh
   gh release download vX.Y.Z --repo KevinSaison/fuchikoma
   sha256sum -c SHA256SUMS
   gh attestation verify fuchikoma-X.Y.Z.gem --repo KevinSaison/fuchikoma
   mkdir from-rubygems && (cd from-rubygems && gem fetch fuchikoma -v X.Y.Z)
   cmp fuchikoma-X.Y.Z.gem from-rubygems/fuchikoma-X.Y.Z.gem && echo "identical"
   ```
4. The gem installs in a clean environment: `gem install fuchikoma -v X.Y.Z`.
5. Announce the release where the project communicates (see
   [GOVERNANCE.md](GOVERNANCE.md#communication)).

## When something goes wrong

The rule that governs every case: **a tag can be deleted and recreated only
while nothing has been published for it.** Once the gem is on RubyGems.org, the
version is final, and a fix is a new version.

| Symptom | What it means | What to do |
|---------|---------------|------------|
| `verify` fails on the tag check | The tag is unsigned, lightweight, mismatched with the version, or not on `main` | Nothing was published. Delete the tag (you are a bypass actor), fix the cause, create a new signed tag and push it |
| `verify` or `build` fails on tests, audit, SBOM or the reproducibility check | The commit is not releasable | Nothing was published. Fix it on `main` through a pull request, then delete and recreate the tag on the new commit, or release the next patch version |
| `publish` is rejected by RubyGems.org | The trusted publisher does not match the run, has expired, or (first release) the workflow did not name the gem owner | Check the owner, repository, workflow file name (`release.yml`) and environment (`release`) on RubyGems.org, that the pending trusted publisher still exists, and that the `RUBYGEMS_OWNER` variable holds the account ID. If the workflow file had to change, nothing is published yet: delete and recreate the tag on the fixed commit. Otherwise use "Re-run failed jobs" |
| `publish` succeeds but the check "published gem is the attested gem" fails | The gem is public but its bytes differ from the attested build | Do not publish again. Find the cause, and treat the version as suspect: yank it and release the next patch if the difference cannot be explained. The GitHub release is not created |
| `github-release` fails | The gem is published but the release page is missing | Use "Re-run failed jobs". Otherwise download the `release-dist` artifact and run `gh release create vX.Y.Z <files> --verify-tag --generate-notes` |
| A released gem is broken | A bad version is public | Yank it with `gem yank fuchikoma -v X.Y.Z` (this needs MFA), release the next patch version, and say so in the changelog |
| A released gem has a security flaw | A vulnerability is public | Follow [SECURITY.md](SECURITY.md): private handling, a security advisory and a CVE where relevant |

### A lost or compromised signing key

Report it to the other maintainers at once, as GOVERNANCE.md requires. Remove
the key from your GitHub account, create a new one, register it as a signing
key, and have your release rights reviewed. Release rights stay suspended
until that is done.

## Definition of done for a release

Copy this checklist into the release pull request.

- [ ] Changelog written, with a dated section for the version
- [ ] `DEPENDENCIES.md` matches the gemspec and the count is below 15
- [ ] Benchmarks re-run and published (once the benchmark harness exists)
- [ ] Security checklist ticked
- [ ] Upgrade notes tested on the previous example app (once example apps exist)
- [ ] Roadmap checkboxes ticked for the commits this release delivers
- [ ] `bundle exec rake` passes locally
- [ ] Dry run green, checksums and attestations verified
- [ ] Tag signed and pushed by a release manager
- [ ] Gem published, and identical to the attested gem
- [ ] GitHub release created with the gem, the SBOM and `SHA256SUMS`
