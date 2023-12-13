# frozen_string_literal: true

require_relative "../src/common"

require "minitest/autorun"

describe "common test" do
  describe "read lines" do
    it "transforms into numbers" do
      assert_equal 1_020_020, Common.read_line("#.##..##.")
    end
    it "transforms into numbers" do
      assert_equal 20_000_001, Common.read_line("##......#")
    end
  end
end
