# frozen_string_literal: true

require_relative "../src/common"

require "minitest/autorun"

describe "common test" do
  describe "read line" do
    it "reads the first line" do
      expected_record = Record.new("???.###", [1, 1, 3])

      assert_equal expected_record, Common.read_line("???.### 1,1,3")
    end
    it "reads another line" do
      expected_record = Record.new("?#?#?#?#?#?#?#?", [1, 3, 1, 6])

      assert_equal expected_record, Common.read_line("?#?#?#?#?#?#?#? 1,3,1,6")
    end
  end

  describe "damaged check" do
    it "counts the last spots" do
      expected_response = [-3, 0, 3]

      assert_equal expected_response, Common.damaged_check(Record.new("???.###", [1, 1, 3]))
    end
    it "counts only damaged spots, ignoring ?" do
      expected_response = [-1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1]

      assert_equal expected_response, Common.damaged_check(Record.new("?#?#?#?#?#?#?#?", [1, 3, 1, 6]))
    end
  end

  describe "calculate permutations" do
    it "raises an error if its impossible to calculate" do
      assert_raises RuntimeError do
        Common.calculate_permutations(Record.new(".", [1]))
      end
    end

    it "returns the permutations for a simple case" do
      assert_equal 1, Common.calculate_permutations(Record.new("??", [2]))
    end

    it "calculates permutations for one of the test cases" do
      assert_equal 1, Common.calculate_permutations(Record.new("?#?#?#?#?#?#?#?", [1, 3, 1, 6]))
    end
    it "calculates permutations for another of the test cases" do
      assert_equal 10, Common.calculate_permutations(Record.new("?###????????", [3, 2, 1]))
    end
    it "calculates permutations for another of the test cases" do
      assert_equal 4, Common.calculate_permutations(Record.new(".??..??...?##.", [1, 1, 3]))
    end
    it "calculates permutations for a test case that can be cut-off early" do
      assert_equal 1, Common.calculate_permutations(Record.new("?.??...??#", [2, 3]))
    end
  end

  describe "expands record" do
    it "expands a simple record" do
      assert_equal Record.new(".#?.#?.#?.#?.#", [1,1,1,1,1]), Common.expand_record(Record.new(".#", [1]))
    end
  end
end
