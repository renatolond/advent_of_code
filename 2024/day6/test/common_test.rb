# frozen_string_literal: true

require_relative "../src/common"

require "minitest/autorun"

describe "common test" do
  describe "guard" do
    it "find guard position" do
      line = ".#..^....."
      idx = 0
      guard = Common::Guard.find(line, idx)

      expected_guard = Common::Guard.new(4, idx, "^")

      assert_equal expected_guard, guard
    end
  end
end
