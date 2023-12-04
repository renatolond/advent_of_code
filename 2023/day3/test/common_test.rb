# frozen_string_literal: true

require_relative "../src/common"

require "minitest/autorun"

describe "common test" do
  describe "number detector" do
    it "detects number positions in a line" do
      assert_empty Common.number_detector(".")
    end

    it "detects number positions in a line that has numbers" do
      assert_equal [Interval.new(start: 1, end: 3, number: 123)], Common.number_detector(".123.")
    end

    it "detects number positions in a line that has multiple numbers" do
      assert_equal [Interval.new(start: 2, end: 3, number: 35), Interval.new(start: 6, end: 8, number: 633)], Common.number_detector("..35..633.")
    end

    it "detects number positions in the end of the line that has numbers" do
      assert_equal [Interval.new(start: 2, end: 4, number: 123)], Common.number_detector("..123")
    end
  end
end
