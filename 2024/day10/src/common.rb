# frozen_string_literal: true

module Common
  Point = Data.define(:y, :x)
  class << self
    # @param line [String]
    # @param idy [Integer]
    # @return [Array<Point>]
    def find_trailends(line, idy)
      trailheads = []
      idx = 0
      line.each do |c|
        trailheads << Point.new(idy, idx) if c == 9
        idx = idx.succ
      end
      trailheads
    end

    # @param trailends [Array<Point>]
    # @param trail [Array<Array<Integer>>]
    # @return [Array<Array<Integer>>]
    def traverse_peaks(trailends, trail)
      queue = trailends.map { |v| { p: v, trailend: v } }
      score_map = Array.new(trail.size) { Array.new(trail.first.size) { Set.new } }
      ratings_map = Array.new(trail.size) { Array.new(trail.first.size, 0) }

      while (curr = queue.pop)
        p = curr[:p]
        trailend = curr[:trailend]
        score_map[p.y][p.x] << trailend
        ratings_map[p.y][p.x] += 1

        queue << { p: Point.new(p.y - 1, p.x), trailend: } if p.y - 1 >= 0 && trail[p.y - 1][p.x] == trail[p.y][p.x] - 1
        queue << { p: Point.new(p.y + 1, p.x), trailend: } if p.y + 1 < trail.size && trail[p.y + 1][p.x] == trail[p.y][p.x] - 1
        queue << { p: Point.new(p.y, p.x - 1), trailend: } if p.x - 1 >= 0 && trail[p.y][p.x - 1] == trail[p.y][p.x] - 1
        queue << { p: Point.new(p.y, p.x + 1), trailend: } if p.x + 1 < trail.first.size && trail[p.y][p.x + 1] == trail[p.y][p.x] - 1
      end
      score_map.each { |s| s.map!(&:size) }
      # score_map.each do |l|
      #   pp l
      # end
      # ratings_map.each do |l|
      #   pp l
      # end
      return score_map, ratings_map
    end
  end
end
