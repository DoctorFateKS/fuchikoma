# frozen_string_literal: true

require "test_helper"

class SaitamaTest < Minitest::Test
  def test_version_is_a_semantic_version
    assert_match(/\A\d+\.\d+\.\d+\z/, Saitama::VERSION)
  end
end
