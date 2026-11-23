# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"
require "rubocop/rake_task"

Minitest::TestTask.create

RuboCop::RakeTask.new

desc "Type-check the code with Steep"
task :steep do
  sh "bundle exec steep check"
end

task default: %i[test rubocop steep]
