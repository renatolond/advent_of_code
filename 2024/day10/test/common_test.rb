# frozen_string_literal: true

require_relative "../src/common"

require "minitest/autorun"

describe "common test" do
  describe "find_trailends" do
    it "finds one trailends" do
      idy = 0
      expected_trailheads = [Common::Point.new(idy, 1)]

      assert_equal expected_trailheads, Common.find_trailends("89010123".chars.map(&:to_i), idy)
    end
  end
end
