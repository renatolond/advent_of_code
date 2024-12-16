# frozen_string_literal: true

module Common
  Point = Data.define(:y, :x, :direction) do
    def left
      Point.new(y, x, :left)
    end

    def right
      Point.new(y, x, :right)
    end

    def down
      Point.new(y, x, :down)
    end

    def up
      Point.new(y, x, :up)
    end

    def non_directed
      Point.new(y, x, nil)
    end
  end

  class << self
    # @param start_pos [Point]
    # @param maze [Array<String>]
    def min_path(start_pos, maze)
      queue = []

      cost = Float::INFINITY

      visited = Array.new(maze.size) { Array.new(maze.first.size) { Hash.new(Float::INFINITY) } }

      queue << [start_pos, 0]
      while (curr_node = queue.shift)
        curr_pos, current_cost = curr_node
        next if maze[curr_pos.y][curr_pos.x] == "#"
        next if visited[curr_pos.y][curr_pos.x][curr_pos.direction] <= current_cost

        if maze[curr_pos.y][curr_pos.x] == "E"
          cost = current_cost if cost > current_cost
          next
        end
        visited[curr_pos.y][curr_pos.x][curr_pos.direction] = current_cost

        queue << [curr_pos.left, current_cost + 1000] if curr_pos.direction != :left
        queue << [curr_pos.right, current_cost + 1000] if curr_pos.direction != :right
        queue << [curr_pos.up, current_cost + 1000] if curr_pos.direction != :up
        queue << [curr_pos.down, current_cost + 1000] if curr_pos.direction != :down
        queue << [Point.new(curr_pos.y - 1, curr_pos.x, curr_pos.direction), current_cost + 1] if curr_pos.direction == :up
        queue << [Point.new(curr_pos.y, curr_pos.x - 1, curr_pos.direction), current_cost + 1] if curr_pos.direction == :left
        queue << [Point.new(curr_pos.y + 1, curr_pos.x, curr_pos.direction), current_cost + 1] if curr_pos.direction == :down
        queue << [Point.new(curr_pos.y, curr_pos.x + 1, curr_pos.direction), current_cost + 1] if curr_pos.direction == :right
      end

      cost
    end

    # @param start_pos (see .min_path)
    # @param maze (see .min_path)
    # @param min_cost [Integer]
    def best_places(start_pos, maze, min_cost)
      queue = []

      visited = Array.new(maze.size) { Array.new(maze.first.size) { Hash.new(Float::INFINITY) } }

      visited_points = Set.new
      visited_points << start_pos.non_directed
      queue << [start_pos, 0, visited_points]
      best_places = Set.new
      while (curr_node = queue.shift)
        curr_pos, current_cost, visited_points = curr_node
        next if maze[curr_pos.y][curr_pos.x] == "#"
        next if current_cost > min_cost
        next if visited[curr_pos.y][curr_pos.x][curr_pos.direction] < current_cost

        visited[curr_pos.y][curr_pos.x][curr_pos.direction] = current_cost
        visited_points << curr_pos.non_directed
        if maze[curr_pos.y][curr_pos.x] == "E"
          best_places += visited_points if current_cost == min_cost

          next
        end

        queue << [curr_pos.left, current_cost + 1000, visited_points.dup] if curr_pos.direction != :left
        queue << [curr_pos.right, current_cost + 1000, visited_points.dup] if curr_pos.direction != :right
        queue << [curr_pos.up, current_cost + 1000, visited_points.dup] if curr_pos.direction != :up
        queue << [curr_pos.down, current_cost + 1000, visited_points.dup] if curr_pos.direction != :down
        queue << [Point.new(curr_pos.y - 1, curr_pos.x, curr_pos.direction), current_cost + 1, visited_points.dup] if curr_pos.direction == :up
        queue << [Point.new(curr_pos.y, curr_pos.x - 1, curr_pos.direction), current_cost + 1, visited_points.dup] if curr_pos.direction == :left
        queue << [Point.new(curr_pos.y + 1, curr_pos.x, curr_pos.direction), current_cost + 1, visited_points.dup] if curr_pos.direction == :down
        queue << [Point.new(curr_pos.y, curr_pos.x + 1, curr_pos.direction), current_cost + 1, visited_points.dup] if curr_pos.direction == :right
      end

      best_places.size
    end
  end
end
