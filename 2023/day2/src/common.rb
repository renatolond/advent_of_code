# frozen_string_literal: true

require_relative "handful"
require_relative "game"

require "scanf"

module Common
  class << self
    # @param line [String] A line read from the terminal
    # @return [Game]
    def parse_game(line)
      game_id, line = line.split(/\s*:\s*/, 2)
      game_id, = game_id.scanf("Game %d")
      handfuls = line.split(/\s*;\s*/)
      handfuls.map! do |handful|
        colors = handful.split(/\s*,\s*/)
        blue = 0
        red = 0
        green = 0
        colors.each do |color|
          quantity, color = color.scanf("%d %s")
          case color
          when "blue"
            blue = quantity
          when "green"
            green = quantity
          when "red"
            red = quantity
          else
            raise "wrong color value"
          end
        end
        Handful.new(blue:, green:, red:)
      end
      Game.new(game_id, handfuls)
    end

    # @param game [Game] A game to be validated
    # @param compare_hand [Handful] A handful to be compared to
    # @return [Boolean]
    def valid_game?(game, compare_hand: Handful.new(red: 12, green: 13, blue: 14))
      game.sets.each do |handful|
        return false if handful.green > compare_hand.green ||
                        handful.blue > compare_hand.blue ||
                        handful.red > compare_hand.red
      end
      true
    end

    # @param game [Game] The game to calculate the min cubes for
    # @return [Handful] the set
    def fewest_cubes(game)
      red = game.sets.map(&:red).max
      blue = game.sets.map(&:blue).max
      green = game.sets.map(&:green).max
      Handful.new(red:, green:, blue:)
    end

    # @param handful [Handful] the set to calculate the power for
    # @return [Integer]
    def handful_power(handful)
      handful.red * handful.blue * handful.green
    end
  end
end
