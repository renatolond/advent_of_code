# frozen_string_literal: true

module Common
  Point = Data.define(:y, :x)

  class << self
    # @param start_pos [Point]
    # @param maze [Array<String>]
    def min_path(start_pos, maze)
      queue = []

      cost = Float::INFINITY

      visited = Array.new(maze.size) { Array.new(maze.first.size) { Float::INFINITY } }

      queue << [start_pos, 0]
      while (curr_node = queue.shift)
        curr_pos, current_cost = curr_node
        next if maze[curr_pos.y][curr_pos.x] == "#"
        next if visited[curr_pos.y][curr_pos.x] <= current_cost

        if curr_pos.y == (maze.size - 1) && curr_pos.x == (maze.size - 1)
          cost = current_cost if cost > current_cost
          next
        end
        visited[curr_pos.y][curr_pos.x] = current_cost

        queue << [Point.new(curr_pos.y - 1, curr_pos.x), current_cost + 1] if curr_pos.y - 1 >= 0
        queue << [Point.new(curr_pos.y, curr_pos.x - 1), current_cost + 1] if curr_pos.x - 1 >= 0
        queue << [Point.new(curr_pos.y + 1, curr_pos.x), current_cost + 1] if curr_pos.y + 1 < maze.size
        queue << [Point.new(curr_pos.y, curr_pos.x + 1), current_cost + 1] if curr_pos.x + 1 < maze.size
      end

      # visited.each { |v| v.each { |vv| vv == Float::INFINITY ? print("∞") : print(vv) }; puts "" }
      cost
    end

    # @param maze (see .min_path)
    # @param n [Integer] number of bytes that fell
    # @param falling_bytes [Array<Point>] All bytes that could fall, in order
    def bytes_have_fallen!(n, falling_bytes, maze)
      falling_bytes.first(n).each do |byte|
        maze[byte.y][byte.x] = "#"
      end
    end
  end
end
