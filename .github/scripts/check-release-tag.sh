#!/usr/bin/env bash
# Check that a release is safe to publish.
#
# Usage:
#   .github/scripts/check-release-tag.sh <tag>             full check
#   .github/scripts/check-release-tag.sh --offline <tag>   skip the GitHub checks
#   .github/scripts/check-release-tag.sh --dry-run         version and changelog only
#
# Every mode checks that:
#   - the tag is named vX.Y.Z;
#   - the tag matches Fuchikoma::VERSION;
#   - CHANGELOG.md has a dated section for that version.
#
# The other modes also check that:
#   - the tagged commit is on origin/main;
#   - (full mode only) the tag is annotated, GitHub reports its signature as
#     verified, and it points to the same commit as the local tag. This needs
#     the gh CLI and a token in GH_TOKEN.
set -euo pipefail

usage() {
  echo "Usage: $0 [--offline] <tag> | $0 --dry-run" >&2
  exit 2
}

mode="full"
case "${1:-}" in
  --offline) mode="offline"; shift ;;
  --dry-run) mode="dry-run"; shift ;;
esac

if [ "$mode" = "dry-run" ]; then
  [ "$#" -eq 0 ] || usage
else
  [ "$#" -eq 1 ] || usage
  tag="$1"
fi

cd "$(dirname "$0")/../.."

failures=0

ok() { echo "  ok   $1"; }

fail() {
  failures=$((failures + 1))
  echo "::error title=Release check failed::$1"
  echo "  FAIL $1"
}

version="$(ruby -Ilib -e 'require "fuchikoma/version"; print Fuchikoma::VERSION')"

if [ "$mode" = "dry-run" ]; then
  tag="v${version}"
  echo "Dry run: checking version ${version} without a tag."
fi

if [[ "$tag" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  ok "tag name ${tag} has the form vX.Y.Z"
else
  fail "tag name ${tag} does not have the form vX.Y.Z"
fi

if [ "$tag" = "v${version}" ]; then
  ok "tag ${tag} matches Fuchikoma::VERSION ${version}"
else
  fail "tag ${tag} does not match Fuchikoma::VERSION ${version}"
fi

escaped_version="${version//./\\.}"
if grep -Eq "^## \[${escaped_version}\] - [0-9]{4}-[0-9]{2}-[0-9]{2}$" CHANGELOG.md; then
  ok "CHANGELOG.md has a dated section for ${version}"
else
  fail "CHANGELOG.md has no dated section '## [${version}] - YYYY-MM-DD'"
fi

if [ "$mode" != "dry-run" ]; then
  commit=""
  if commit="$(git rev-parse --verify --quiet "refs/tags/${tag}^{commit}")"; then
    ok "tag ${tag} exists and points to ${commit:0:12}"
  else
    commit=""
    fail "tag ${tag} was not found in this clone"
  fi

  if [ -n "$commit" ]; then
    if git merge-base --is-ancestor "$commit" origin/main 2>/dev/null; then
      ok "tagged commit is on origin/main"
    else
      fail "tagged commit ${commit:0:12} is not on origin/main"
    fi
  fi
fi

if [ "$mode" = "full" ]; then
  repo="${GITHUB_REPOSITORY:-}"
  if [ -z "$repo" ]; then
    repo="$(gh repo view --json nameWithOwner --jq .nameWithOwner)"
  fi

  if ref_info="$(gh api "repos/${repo}/git/ref/tags/${tag}" \
    --jq '[.object.type, .object.sha] | @tsv' 2>/dev/null)"; then
    object_type="${ref_info%%$'\t'*}"
    object_sha="${ref_info##*$'\t'}"

    if [ "$object_type" = "tag" ]; then
      ok "tag ${tag} is an annotated tag"

      if tag_info="$(gh api "repos/${repo}/git/tags/${object_sha}" \
        --jq '[.verification.verified, .verification.reason, .object.sha] | @tsv' 2>/dev/null)"; then
        IFS=$'\t' read -r verified reason target <<< "$tag_info"

        if [ "$verified" = "true" ]; then
          ok "GitHub reports the signature of ${tag} as verified"
        else
          fail "GitHub does not verify the signature of ${tag} (reason: ${reason})"
        fi

        if [ -n "$commit" ] && [ "$target" != "$commit" ]; then
          fail "tag ${tag} on GitHub points to ${target:0:12}, not to ${commit:0:12}"
        fi
      else
        fail "could not read the tag object of ${tag} from the GitHub API"
      fi
    else
      fail "tag ${tag} is a lightweight tag: release tags must be signed with git tag -s"
    fi
  else
    fail "tag ${tag} was not found on GitHub (is it pushed, and is GH_TOKEN set?)"
  fi
fi

echo
if [ "$failures" -gt 0 ]; then
  echo "${failures} check(s) failed: this release must not be published."
  exit 1
fi

echo "All checks passed."
