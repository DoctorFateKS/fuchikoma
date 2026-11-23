#!/usr/bin/env bash
# Verify that every commit in a range carries a valid DCO sign-off.
#
# Usage: .github/scripts/check-dco.sh <base-sha> <head-sha>
#
# A commit passes when it has a "Signed-off-by: Name <email>" trailer whose
# email matches the commit's author or committer email (case-insensitive).
# Merge commits are skipped, and so are commits authored by dependabot[bot].
set -euo pipefail

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <base-sha> <head-sha>" >&2
  exit 2
fi

base="$1"
head="$2"
failures=0
checked=0

lower() { printf '%s' "$1" | tr '[:upper:]' '[:lower:]'; }

fail() {
  local sha="$1" reason="$2"
  failures=$((failures + 1))
  echo "::error title=DCO sign-off missing::${sha:0:12}: ${reason}"
  echo "  FAIL ${sha:0:12} $(git log -1 --format=%s "$sha")"
  echo "       ${reason}"
}

while read -r sha; do
  [ -n "$sha" ] || continue
  checked=$((checked + 1))

  author_name="$(git log -1 --format=%an "$sha")"
  author_email="$(lower "$(git log -1 --format=%ae "$sha")")"
  committer_email="$(lower "$(git log -1 --format=%ce "$sha")")"

  if [ "$author_name" = "dependabot[bot]" ]; then
    echo "  skip ${sha:0:12} (dependabot[bot])"
    continue
  fi

  signoffs="$(git log -1 --format='%(trailers:key=Signed-off-by,valueonly,unfold)' "$sha" | sed '/^$/d')"

  if [ -z "$signoffs" ]; then
    fail "$sha" "no Signed-off-by line"
    continue
  fi

  matched=0
  while IFS= read -r line; do
    if [[ "$line" =~ ^.+\ \<([^\<\>[:space:]]+@[^\<\>[:space:]]+)\>$ ]]; then
      email="$(lower "${BASH_REMATCH[1]}")"
      if [ "$email" = "$author_email" ] || [ "$email" = "$committer_email" ]; then
        matched=1
        break
      fi
    fi
  done <<< "$signoffs"

  if [ "$matched" -eq 1 ]; then
    echo "  ok   ${sha:0:12} $(git log -1 --format=%s "$sha")"
  else
    fail "$sha" "Signed-off-by does not match the commit author or committer email"
  fi
done < <(git rev-list --no-merges --reverse "${base}..${head}")

echo
echo "Checked ${checked} commit(s): ${failures} problem(s)."

if [ "$failures" -gt 0 ]; then
  cat <<'EOF'

Every commit must be signed off to certify the Developer Certificate of Origin.
See CONTRIBUTING.md ("Developer Certificate of Origin") for details.

To fix the last commit:
    git commit --amend --signoff --no-edit
    git push --force-with-lease

To fix every commit on your branch:
    git rebase --signoff origin/main
    git push --force-with-lease

The Signed-off-by email must match your Git author email (git config user.email).
EOF
  exit 1
fi
