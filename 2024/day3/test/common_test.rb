# frozen_string_literal: true

require_relative "../src/common"

require "minitest/autorun"

describe "common test" do
  describe "find_instructions" do
    it "finds the right instructions" do
      expected_instructions = [
        { instruction: :mul, values: [2, 4] },
        { instruction: :mul, values: [5, 5] },
        { instruction: :mul, values: [11, 8] },
        { instruction: :mul, values: [8, 5] }
      ]

      assert_equal expected_instructions, Common.find_instructions("xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))")
    end
  end
  describe "find_instructions_with_conditionals" do
    it "finds the right instructions" do
      expected_instructions = [
        { instruction: :mul, values: [2, 4] },
        { instruction: :mul, values: [8, 5] }
      ]

      instructions, multiplication_enabled = Common.find_instructions_with_conditions("xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))")

      assert_equal expected_instructions, instructions
      assert multiplication_enabled
    end
  end

  describe "sum_of_instructions" do
    it "finds the right value" do
      instructions = [
        { instruction: :mul, values: [2, 4] },
        { instruction: :mul, values: [5, 5] },
        { instruction: :mul, values: [11, 8] },
        { instruction: :mul, values: [8, 5] }
      ]

      assert_equal 161, Common.sum_of_instructions(instructions)
    end
  end
end
