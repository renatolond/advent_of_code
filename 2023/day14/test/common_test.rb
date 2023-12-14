# frozen_string_literal: true

require_relative "../src/common"

require "minitest/autorun"

describe "common test" do
  describe "tick" do
    it "ticks north and does not changes the map" do
      input_map = ["..", ".."]
      expected_result = ["..", ".."]

      result, changed = Common.tick(input_map)

      refute changed
      assert_equal expected_result, result
    end
    it "ticks north and does not change the map" do
      input_map = %w[O.OO.#....
                     O...#....#]
      expected_result = ["..", ".."]

      result, changed = Common.tick(input_map)

      refute changed
      assert_equal expected_result, result
    end
    it "ticks north and does not changes the map because rocks are in the way" do
      input_map = ["#.", "O."]
      expected_result = ["#.", "O."]

      result, changed = Common.tick(input_map)

      refute changed
      assert_equal expected_result, result
    end
    it "ticks north and changes the map" do
      input_map = ["..", "OO"]
      expected_result = ["OO", ".."]

      result, changed = Common.tick(input_map)

      assert changed
      assert_equal expected_result, result
    end
    it "ticks north and changes the map" do
      input_map = ["#.", "..", "O."]
      expected_result = ["#.", "O.", ".."]

      result, changed = Common.tick(input_map)

      assert changed
      assert_equal expected_result, result
    end
    it "ticks north and changes the map" do
      input_map = ["#.", "..", "..", "O."]
      expected_result = ["#.", "O.", "..", ".."]

      result, changed = Common.tick(input_map)

      assert changed

      result, changed = Common.tick(result)

      assert changed
      assert_equal expected_result, result
    end
  end
end
