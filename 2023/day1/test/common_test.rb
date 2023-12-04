# frozen_string_literal: true

require_relative "../src/common"

require "minitest/autorun"

describe "common test" do
  describe "Calibration value" do
    it "gets the calibration value for a line with only two numbers" do
      assert_equal 12, Common.calibration_value("1abc2")
    end
    it "gets the calibration value for a line with multiple numbers" do
      assert_equal 15, Common.calibration_value("a1b2c3d4e5f")
    end
    it "gets the calibration value for a line with a single number" do
      assert_equal 77, Common.calibration_value("treb7uchet")
    end
  end

  describe "preprocessor" do
    it "preprocesses digits into numbers with numbers in the string" do
      assert_equal "2wo19ine", Common.preprocessor("two1nine")
    end
    it "preprocesses digits into numbers only strings" do
      assert_equal "8igh2wo3hree", Common.preprocessor("eightwothree")
    end
    it "preprocesses digits into numbers with overlap" do
      assert_equal "z1n8ight234", Common.preprocessor("zoneight234")
    end
  end
end
