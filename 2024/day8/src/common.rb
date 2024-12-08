# frozen_string_literal: true

module Common
  Point = Data.define(:y, :x)
  class << self
    # @param antenas [Array<Array<Point>>]
    # @param max_y [Integer]
    # @param max_x [Integer]
    # @return [Array<Point>]
    def calculate_antinodes(antenas, max_y, max_x)
      antinodes = Set.new
      antenas.each_value do |v|
        v.combination(2) do |a, b|
          distance = Point.new((a.y - b.y), (a.x - b.x))
          antinode = Point.new(a.y + distance.y, a.x + distance.x)
          antinodes << antinode if antinode.y >= 0 && antinode.y < max_y && antinode.x >= 0 && antinode.x < max_x
          antinode = Point.new(b.y - distance.y, b.x - distance.x)
          antinodes << antinode if antinode.y >= 0 && antinode.y < max_y && antinode.x >= 0 && antinode.x < max_x
        end
      end
      antinodes
    end

    # @param antenas [Array<Array<Point>>]
    # @param max_y [Integer]
    # @param max_x [Integer]
    # @return [Array<Point>]
    def calculate_resonant_antinodes(antenas, max_y, max_x)
      antinodes = Set.new
      antenas.each_value do |v|
        v.combination(2) do |a, b|
          distance = Point.new((a.y - b.y), (a.x - b.x))
          antinode = a
          loop do
            antinode = Point.new(antinode.y + distance.y, antinode.x + distance.x)
            break unless antinode.y >= 0 && antinode.y < max_y && antinode.x >= 0 && antinode.x < max_x

            antinodes << antinode
          end
          antinode = a
          loop do
            antinode = Point.new(antinode.y - distance.y, antinode.x - distance.x)
            break unless antinode.y >= 0 && antinode.y < max_y && antinode.x >= 0 && antinode.x < max_x

            antinodes << antinode
          end
          antinode = b
          loop do
            antinode = Point.new(antinode.y - distance.y, antinode.x - distance.x)
            break unless antinode.y >= 0 && antinode.y < max_y && antinode.x >= 0 && antinode.x < max_x

            antinodes << antinode
          end
          antinode = b
          loop do
            antinode = Point.new(antinode.y + distance.y, antinode.x + distance.x)
            break unless antinode.y >= 0 && antinode.y < max_y && antinode.x >= 0 && antinode.x < max_x

            antinodes << antinode
          end
        end
      end
      antinodes
    end
  end
end
