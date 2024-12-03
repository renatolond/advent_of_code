# frozen_string_literal: true

require_relative "../src/common"

require "minitest/autorun"

describe "common test" do
  it "pairs the smallest values on both lists" do
    assert_equal [[1, 1], [2, 2]], Common.paired_values([1, 2], [2, 1])
  end

  it "sums the distance of paired values" do
    assert_equal 3, Common.distance_of_paired_values([1, 2], [3, 3])
  end
end
