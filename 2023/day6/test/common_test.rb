# frozen_string_literal: true

require_relative "../src/common"

require "minitest/autorun"

describe "common test" do
  describe "solves for x" do
    it "solves for the first equation" do
      assert_equal [2, 5], Common.solve_for_x(7, 9)
    end
    it "solves for the second equation" do
      assert_equal [4, 11], Common.solve_for_x(15, 40)
    end
    it "solves for the third equation" do
      assert_equal [11, 19], Common.solve_for_x(30, 200)
    end
  end
end
