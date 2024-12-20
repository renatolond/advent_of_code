# frozen_string_literal: true

module Common
  Point = Data.define(:y, :x)
  class << self
    # @param start_pos [Point]
    # @param maze [Array<String>]
    def min_path(start_pos, maze)
      queue = []

      cost = Float::INFINITY
      final_points = nil

      visited = Array.new(maze.size) { Array.new(maze.first.size) { Float::INFINITY } }
      visited_points = []

      queue << [start_pos, 0, visited_points]
      while (curr_node = queue.shift)
        curr_pos, current_cost, visited_points = curr_node

        next if maze[curr_pos.y][curr_pos.x] == "#"
        next if visited[curr_pos.y][curr_pos.x] <= current_cost

        visited[curr_pos.y][curr_pos.x] = current_cost
        visited_points = visited_points.dup
        visited_points << curr_pos

        if maze[curr_pos.y][curr_pos.x] == "E"
          if cost > current_cost
            cost = current_cost
            final_points = visited_points
          end
          next
        end

        queue << [Point.new(curr_pos.y - 1, curr_pos.x), current_cost + 1, visited_points] if curr_pos.y - 1 >= 0
        queue << [Point.new(curr_pos.y, curr_pos.x - 1), current_cost + 1, visited_points] if curr_pos.x - 1 >= 0
        queue << [Point.new(curr_pos.y + 1, curr_pos.x), current_cost + 1, visited_points] if curr_pos.y + 1 < maze.size
        queue << [Point.new(curr_pos.y, curr_pos.x + 1), current_cost + 1, visited_points] if curr_pos.x + 1 < maze.size
      end

      # @visited.each { |v| v.each { |vv| vv[true] == Float::INFINITY ? print("∞".rjust(5)) : print(format("%5d", vv[true])) }; puts "" }
      # puts ""
      # @visited.each { |v| v.each { |vv| vv[false] == Float::INFINITY ? print("∞".rjust(5)) : print(format("%5d", vv[false])) }; puts "" }
      return cost, final_points
    end
    attr_accessor :cheat_picoseconds

    def find_cheats(path)
      idy = 0
      cheats = {}
      while idy < path.size
        idx = 0
        while idx < idy
          manhattan_distance = (path[idy].x - path[idx].x).abs + (path[idy].y - path[idx].y).abs
          if manhattan_distance <= cheat_picoseconds
            delta = (idy - idx) - manhattan_distance
            cheats[[idx, idy]] = delta if cheats[[idx, idy]].nil? || cheats[[idx, idy]] > delta
          end
          idx = idx.succ
        end
        idy = idy.succ
      end
      cheats
    end
  end
end
