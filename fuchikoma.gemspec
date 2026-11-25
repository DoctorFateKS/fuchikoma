# frozen_string_literal: true

require_relative "lib/fuchikoma/version"

Gem::Specification.new do |spec|
  spec.name = "fuchikoma"
  spec.version = Fuchikoma::VERSION
  spec.authors = ["Kevin Saison"]
  spec.email = ["saisonkevin@protonmail.com"]

  spec.summary = "Fiber-native, typed, one-process Ruby web framework."
  spec.description = "Fuchikoma is a Ruby framework for one-process web applications: " \
                     "every request, job and socket runs in a fiber, contracts are " \
                     "declared once as schemas, data access is scoped by default, " \
                     "and AI agents are a framework concept."
  spec.homepage = "https://github.com/KevinSaison/fuchikoma"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.4"

  spec.metadata = {
    "homepage_uri" => spec.homepage,
    "source_code_uri" => spec.homepage,
    "changelog_uri" => "#{spec.homepage}/blob/main/CHANGELOG.md",
    "bug_tracker_uri" => "#{spec.homepage}/issues",
    "rubygems_mfa_required" => "true"
  }

  spec.files = Dir["lib/**/*.rb", "sig/**/*.rbs", "LICENSE", "README.md", "CHANGELOG.md"]
  spec.require_paths = ["lib"]

  # No runtime dependencies yet. Policy: fewer than 15 runtime gems,
  # each justified in DEPENDENCIES.md.
end
