# frozen_string_literal: true

require_relative "../src/common"

require "minitest/autorun"

describe "common test" do
  describe "level_safe? without dampener" do
    it "they are not safe" do
      refute Common.level_safe?([1, 2, 7, 8, 9])
      refute Common.level_safe?([9, 7, 6, 2, 1])
      refute Common.level_safe?([1, 3, 2, 4, 5])
      refute Common.level_safe?([8, 6, 4, 4, 1])
    end

    it "they are safe" do
      assert Common.level_safe?([7, 6, 4, 2, 1])
      assert Common.level_safe?([1, 3, 6, 7, 9])
    end
  end
  describe "level_safe? with dampener" do
    it "they are not safe" do
      refute Common.problem_dampened_level_safe?([1, 2, 7, 8, 9])
      refute Common.problem_dampened_level_safe?([9, 7, 6, 2, 1])
    end

    it "they are safe" do
      assert Common.problem_dampened_level_safe?([7, 6, 4, 2, 1])
      assert Common.problem_dampened_level_safe?([1, 3, 6, 7, 9])
      assert Common.problem_dampened_level_safe?([1, 3, 2, 4, 5])
      assert Common.problem_dampened_level_safe?([8, 6, 4, 4, 1])
    end
  end
end
