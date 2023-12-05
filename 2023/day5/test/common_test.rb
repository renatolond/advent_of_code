# frozen_string_literal: true

require_relative "../src/common"

require "minitest/autorun"

describe "common test" do
  describe "read maps" do
    it "reads map number 1" do
      expected_map = Map.new(destination: 52...100, source: 50...98)

      assert_equal expected_map, Common.read_map_line("52 50 48")
    end
    it "reads map number 2" do
      expected_map = Map.new(destination: 0...37, source: 15...(15 + 37))

      assert_equal expected_map, Common.read_map_line("0 15 37")
    end
  end
  describe "conversion" do
    it "converts seeds to soil" do
      maps = [Map.new(destination: 50...52, source: 98...100),
              Map.new(destination: 52...(52 + 48), source: 50...(50 + 48))]
      values = [79, 14, 55, 13]
      expected_values = [81, 14, 57, 13]

      assert_equal expected_values, Common.convert(maps, values)
    end
    it "converts with a map that says the same" do
      maps = [Map.new(destination: 50...52, source: 50...52)]
      values = [50, 60]
      expected_values = [50, 60]

      assert_equal expected_values, Common.convert(maps, values)
    end
    it "converts an edge case" do
      maps = [Map.new(destination: 10...11, source: 2...3),
              Map.new(destination: 2...3, source: 10...11)]

      values = [2, 10]
      expected_values = [10, 2]

      assert_equal expected_values, Common.convert(maps, values)
    end
  end

  describe "conversion ranges" do
    it "converts a range that does not fully fit" do
      maps = [Map.new(source: 50...51, destination: 98...99)]
      values = [49...52]
      expected_values = [49...50, 98...99, 51...52]

      assert_equal expected_values, Common.convert_ranges(maps, values)
    end
    it "converts a range that intersects" do
      maps = [Map.new(source: 98...100, destination: 50...52), Map.new(source: 50...98, destination: 52...100)]
      values = [79...93]
      expected_values = [81...95]

      assert_equal expected_values, Common.convert_ranges(maps, values)
    end
    it "converts an edge case" do
      maps = [Map.new(source: 77...100, destination: 45...68), Map.new(source: 45...64, destination: 81...100), Map.new(source: 64...77, destination: 68...81)]
      values = [74...88]
      expected_values = [78...81, 45...56]

      assert_equal expected_values, Common.convert_ranges(maps, values)
    end
  end

  describe "split ranges XXXXXX" do
    it "splits an edge case" do
      maps = [Map.new(source: 77...100, destination: 45...68), Map.new(source: 45...64, destination: 81...100), Map.new(source: 64...77, destination: 68...81)]
      values = [74...88]
      expected_values = [74...77, 77...88]

      assert_equal expected_values, Common.split_ranges(maps, values)
    end
    it "does not split" do
      maps = [Map.new(source: 1...2, destination: 2...3)]
      values = [74...88]
      expected_values = [74...88]

      assert_equal expected_values, Common.split_ranges(maps, values)
    end
    it "does not split" do
      maps = [Map.new(source: 1...2, destination: 2...3)]
      values = [1...2]
      expected_values = [1...2]

      assert_equal expected_values, Common.split_ranges(maps, values)
    end
    it "does not split" do
      maps = [Map.new(source: 1...10, destination: 2...12)]
      values = [4...5]
      expected_values = [4...5]

      assert_equal expected_values, Common.split_ranges(maps, values)
    end
    it "splits" do
      maps = [Map.new(source: 2...3, destination: 4...5)]
      values = [1...5]
      expected_values = [1...2, 2...3, 3...5]

      assert_equal expected_values, Common.split_ranges(maps, values)
    end
    it "splits" do
      maps = [Map.new(source: 2...3, destination: 4...5)]
      values = [1...3]
      expected_values = [1...2, 2...3]

      assert_equal expected_values, Common.split_ranges(maps, values)
    end
    it "splits" do
      maps = [Map.new(source: 2...3, destination: 4...5)]
      values = [2...5]
      expected_values = [2...3, 3...5]

      assert_equal expected_values, Common.split_ranges(maps, values)
    end
  end
end
