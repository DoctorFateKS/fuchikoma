#!/usr/bin/env bash
# Generate a CycloneDX 1.6 SBOM (JSON) that describes what the gem ships: the
# gem itself and its runtime dependencies, without the development tools that
# the Gemfile lists.
#
# Usage: .github/scripts/generate-sbom.sh <output-file> [<gem-file>]
#
# If <gem-file> is given, its SHA-256 digest is recorded in the SBOM so that
# the document is tied to that exact build. Set SOURCE_DATE_EPOCH to make the
# timestamp, and so the whole document, reproducible.
#
# It needs network access to RubyGems.org to resolve the dependencies, and no
# tool beyond Ruby and Bundler.
#
# How it works: the project Gemfile.lock also lists the development gems, so
# Bundler resolves a throwaway Gemfile that holds only the gemspec. The
# resulting lockfile contains the gem and its runtime dependencies and
# nothing else, and the SBOM is written from it.
set -euo pipefail

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  echo "Usage: $0 <output-file> [<gem-file>]" >&2
  exit 2
fi

repo="$(cd "$(dirname "$0")/../.." && pwd)"

# Resolve the paths before changing directory.
case "$1" in
  /*) output="$1" ;;
  *) output="$PWD/$1" ;;
esac
mkdir -p "$(dirname "$output")"

gem_file=""
if [ "$#" -eq 2 ]; then
  case "$2" in
    /*) gem_file="$2" ;;
    *) gem_file="$PWD/$2" ;;
  esac
fi

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

cat > "$work/Gemfile" <<EOF
source "https://rubygems.org"
gemspec path: "${repo}"
EOF

(cd "$work" && BUNDLE_GEMFILE="$work/Gemfile" bundle lock >&2)

ruby -rjson -rtime -rdigest -rbundler -rrubygems - "$output" "$repo" "$work/Gemfile.lock" "$gem_file" <<'RUBY'
output, repo, lockfile, gem_file = ARGV

spec = Dir.chdir(repo) { Gem::Specification.load("fuchikoma.gemspec") }
abort "SBOM error: could not load fuchikoma.gemspec" unless spec

purl = ->(name, version) { "pkg:gem/#{name}@#{version}" }

locked = Bundler::LockfileParser.new(File.read(lockfile)).specs.uniq { |s| [s.name, s.version.to_s] }
by_name = locked.to_h { |s| [s.name, s] }
main = by_name[spec.name]
abort "SBOM error: #{spec.name} is not in the resolved lockfile" unless main

main_ref = purl.call(main.name, main.version)

main_component = {
  "type" => "library",
  "bom-ref" => main_ref,
  "name" => spec.name,
  "version" => spec.version.to_s,
  "description" => spec.summary,
  "purl" => main_ref
}
main_component["licenses"] = spec.licenses.map { |id| { "license" => { "id" => id } } } unless spec.licenses.empty?
main_component["hashes"] = [{ "alg" => "SHA-256", "content" => Digest::SHA256.file(gem_file).hexdigest }] unless gem_file.empty?

references = []
references << { "type" => "website", "url" => spec.homepage } if spec.homepage
references << { "type" => "vcs", "url" => spec.metadata["source_code_uri"] } if spec.metadata["source_code_uri"]
references << { "type" => "issue-tracker", "url" => spec.metadata["bug_tracker_uri"] } if spec.metadata["bug_tracker_uri"]
main_component["externalReferences"] = references unless references.empty?

others = locked.reject { |s| s.name == spec.name }.sort_by { |s| [s.name, s.version.to_s] }
components = others.map do |s|
  ref = purl.call(s.name, s.version)
  { "type" => "library", "bom-ref" => ref, "name" => s.name, "version" => s.version.to_s, "purl" => ref }
end

dependencies = locked.sort_by { |s| [s.name, s.version.to_s] }.map do |s|
  depends_on = s.dependencies.filter_map { |d| by_name[d.name] }.map { |d| purl.call(d.name, d.version) }.uniq.sort
  { "ref" => purl.call(s.name, s.version), "dependsOn" => depends_on }
end

timestamp = Time.at(Integer(ENV.fetch("SOURCE_DATE_EPOCH") { Time.now.to_i })).utc.iso8601

bom = {
  "$schema" => "http://cyclonedx.org/schema/bom-1.6.schema.json",
  "bomFormat" => "CycloneDX",
  "specVersion" => "1.6",
  "version" => 1,
  "metadata" => {
    "timestamp" => timestamp,
    "tools" => { "components" => [{ "type" => "application", "name" => "generate-sbom.sh" }] },
    "component" => main_component
  },
  "components" => components,
  "dependencies" => dependencies
}

File.write(output, "#{JSON.pretty_generate(bom)}\n")

# Sanity checks: a wrong SBOM is worse than none.
written = JSON.parse(File.read(output))
abort "SBOM check failed: not a CycloneDX document" unless written["bomFormat"] == "CycloneDX"
abort "SBOM check failed: the gem is not the main component" unless written.dig("metadata", "component", "name") == spec.name
abort "SBOM check failed: wrong version for the gem" unless written.dig("metadata", "component", "version") == spec.version.to_s

names = written["components"].map { |c| c["name"] }
runtime = spec.runtime_dependencies.map(&:name)
dev_tools = File.read(File.join(repo, "Gemfile")).scan(/^\s*gem "([^"]+)"/).flatten - runtime
leaked = dev_tools & names
abort "SBOM check failed: development gems leaked into the SBOM: #{leaked.join(", ")}" unless leaked.empty?

refs = [main_ref] + written["components"].map { |c| c["bom-ref"] }
written["dependencies"].each do |dep|
  missing = ([dep["ref"]] + dep["dependsOn"]) - refs
  abort "SBOM check failed: dangling reference(s): #{missing.join(", ")}" unless missing.empty?
end

puts "SBOM ok: #{spec.name} #{spec.version} and #{names.size} runtime dependenc#{names.size == 1 ? "y" : "ies"}#{names.empty? ? "" : " (#{names.join(", ")})"}"
RUBY
