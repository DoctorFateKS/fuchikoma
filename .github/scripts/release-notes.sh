#!/usr/bin/env bash
# Print the changelog section of a release, to use as the release notes.
#
# Usage: .github/scripts/release-notes.sh <tag>
#
# The section starts at the heading "## [X.Y.Z] - YYYY-MM-DD" of CHANGELOG.md
# and ends at the next heading or at the link definitions at the bottom of the
# file. The script fails if the section is missing or empty.
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <tag>" >&2
  exit 2
fi

version="${1#v}"

cd "$(dirname "$0")/../.."

notes="$(awk -v header="## [${version}]" '
  index($0, header) == 1 { found = 1; next }
  found && /^## / { exit }
  found && /^\[[^]]+\]: / { exit }
  found { print }
' CHANGELOG.md | sed '/./,$!d')"

if [ -z "$notes" ]; then
  echo "No release notes found for ${version} in CHANGELOG.md" >&2
  exit 1
fi

printf '%s\n' "$notes"
