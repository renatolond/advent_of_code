# frozen_string_literal: true

module Common
  class << self
    # @param line [String] A line
    # @return [Integer]
    def calibration_value(line)
      chars = line.chars
      numbers = chars.select { |c| c.between?("0", "9") }
      Integer("#{numbers.first}#{numbers.last}")
    end

    ONE = "one"
    TWO = "two"
    THREE = "three"
    FOUR = "four"
    FIVE = "five"
    SIX = "six"
    SEVEN = "seven"
    EIGHT = "eight"
    NINE = "nine"

    # @param line [String] A line
    # @return [String] preprocessed line
    def preprocessor(line)
      new_line = +""
      line.size.times do |idx|
        new_line += if line[idx...idx + ONE.size] == ONE
          "1"
        elsif line[idx...idx + TWO.size] == TWO
          "2"
        elsif line[idx...idx + THREE.size] == THREE
          "3"
        elsif line[idx...idx + FOUR.size] == FOUR
          "4"
        elsif line[idx...idx + FIVE.size] == FIVE
          "5"
        elsif line[idx...idx + SIX.size] == SIX
          "6"
        elsif line[idx...idx + SEVEN.size] == SEVEN
          "7"
        elsif line[idx...idx + EIGHT.size] == EIGHT
          "8"
        elsif line[idx...idx + NINE.size] == NINE
          "9"
        else
          line[idx]
        end
      end
      new_line.freeze
    end
  end
end
