# frozen_string_literal: true

require_relative "../src/common"

require "minitest/autorun"

describe "common test" do
  describe "game reading" do
    it "reads the a correctly" do
      line = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"
      expected_game = Game.new(id: 1, sets: [Handful.new(blue: 3, red: 4), Handful.new(red: 1, green: 2, blue: 6), Handful.new(green: 2)])

      assert_equal expected_game, Common.parse_game(line)
    end
    it "reads a game with a single handful correctly" do
      line = "Game 999: 1000 blue, -1 red"
      expected_game = Game.new(id: 999, sets: [Handful.new(blue: 1000, red: -1)])

      assert_equal expected_game, Common.parse_game(line)
    end
  end

  describe "game validation" do
    it "returns true for a valid game" do
      assert Common.valid_game?(Game.new(id: 2, sets: [Handful.new(green: 2, blue: 1), Handful.new(blue: 4, red: 1, green: 3), Handful.new(green: 1, blue: 1)]))
    end

    it "returns false for an invalid game" do
      refute Common.valid_game?(Game.new(id: 3, sets: [Handful.new(green: 8, blue: 6, red: 20), Handful.new(blue: 5, red: 4, green: 13), Handful.new(green: 5, red: 1)]))
    end
  end

  describe "Fewest cubes" do
    it "calculates the fewest cubes for game 2" do
      assert_equal Handful.new(red: 1, green: 3, blue: 4), Common.fewest_cubes(Game.new(id: 2, sets: [Handful.new(green: 2, blue: 1), Handful.new(blue: 4, red: 1, green: 3), Handful.new(green: 1, blue: 1)]))
    end
    it "calculates the fewest cubes for gmae 3" do
      assert_equal Handful.new(red: 20, green: 13, blue: 6), Common.fewest_cubes(Game.new(id: 3, sets: [Handful.new(green: 8, blue: 6, red: 20), Handful.new(blue: 5, red: 4, green: 13), Handful.new(green: 5, red: 1)]))
    end
  end

  describe "Handful power" do
    it "calculates the power for the smallest cubes for game 2" do
      assert_equal 12, Common.handful_power(Handful.new(red: 1, green: 3, blue: 4))
    end
    it "calculates the power for the smallest cubes for game 3" do
      assert_equal 1560, Common.handful_power(Handful.new(red: 20, green: 13, blue: 6))
    end
  end
end
