# frozen_string_literal: true

module Common
  GUARD_RE = /(?<guard>[<>v^])/
  class Guard
    def initialize(x, y, direction) # rubocop:disable Naming/MethodParameterName
      @x = x
      @y = y
      @direction = case direction
                   when "^"
                     :up
                   when ">"
                     :right
                   when "<"
                     :left
                   when "v"
                     :down
                   else
                     raise "Unknown direction"
      end
    end
    attr_accessor :x, :y, :direction

    # @param other [Guard]
    # @return [Boolean]
    def ==(other)
      x == other.x &&
        y == other.y &&
        direction == other.direction
    end

    def binary_direction
      case direction
      when :up
        1
      when :down
        1 << 1
      when :left
        1 << 2
      when :right
        1 << 3
      end
    end

    class << self
      # @param line [String]
      # @param y [Integer]
      # @return [Guard,nil] returns a guard if finds one, otherwise returns nil
      def find(line, y) # rubocop:disable Naming/MethodParameterName
        match = Common::GUARD_RE.match(line)
        return nil unless match

        Guard.new(match.pre_match.size, y, match[:guard])
      end
    end
  end
  class << self
    ALLOWED_CHARS = ["X", "."].freeze
    # @param guard [Guard]
    # @param maze [Array<String>]
    def maze_walk!(maze, guard)
      maze_length = maze.first.size
      maze[guard.y][guard.x] = "."
      loop do
        raise "Weird situation here #{maze[guard.y][guard.x]}" unless ALLOWED_CHARS.include?(maze[guard.y][guard.x])

        maze[guard.y][guard.x] = "X"
        case guard.direction
        when :up
          return if (guard.y - 1).negative?

          if maze[guard.y - 1][guard.x] == "#"
            guard.direction = :right
            next
          end

          guard.y -= 1
        when :down
          return if guard.y + 1 >= maze.size

          if maze[guard.y + 1][guard.x] == "#"
            guard.direction = :left
            next
          end

          guard.y = guard.y.succ
        when :left
          return if (guard.x - 1).negative?

          if maze[guard.y][guard.x - 1] == "#"
            guard.direction = :up
            next
          end

          guard.x -= 1
        when :right
          return if guard.x + 1 >= maze_length

          if maze[guard.y][guard.x + 1] == "#"
            guard.direction = :down
            next
          end

          guard.x = guard.x.succ
        end
      end
    end

    # @param guard [Guard]
    # @param maze [Array<String>]
    def maze_walk_did_i_loop(maze, guard)
      maze_length = maze.first.size
      maze[guard.y][guard.x] = "."
      walked_direction_map = Array.new(maze.size) { Array.new(maze_length, 0) }
      loop do
        raise "Loop at #{maze[guard.y][guard.x]}" if walked_direction_map[guard.y][guard.x].anybits?(guard.binary_direction)

        maze[guard.y][guard.x] = "X"
        walked_direction_map[guard.y][guard.x] = walked_direction_map[guard.y][guard.x] | guard.binary_direction
        case guard.direction
        when :up
          return if (guard.y - 1).negative?

          if maze[guard.y - 1][guard.x] == "#"
            guard.direction = :right
            next
          end

          guard.y -= 1
        when :down
          return if guard.y + 1 >= maze.size

          if maze[guard.y + 1][guard.x] == "#"
            guard.direction = :left
            next
          end

          guard.y = guard.y.succ
        when :left
          return if (guard.x - 1).negative?

          if maze[guard.y][guard.x - 1] == "#"
            guard.direction = :up
            next
          end

          guard.x -= 1
        when :right
          return if guard.x + 1 >= maze_length

          if maze[guard.y][guard.x + 1] == "#"
            guard.direction = :down
            next
          end

          guard.x = guard.x.succ
        end
      end
    end

    # @param guard [Guard]
    # @param maze [Array<String>]
    def loop_detecting_maze_walk(maze, guard)
      idx = 0
      jdx = 0
      possible_loops = []
      while idx < maze.size
        while jdx < maze[idx].size
          unless maze[idx][jdx] == "X"
            jdx = jdx.succ
            next
          end

          possible_loops << [idx, jdx]
          jdx = jdx.succ
        end
        jdx = 0
        idx = idx.succ
      end
      return possible_loops

      # I was trying to do a smarter maze walk, but it was not getting all cases.
      # possible_loops_maze = maze.dup
      # possible_loops_maze.map!(&:dup)
      # maze = maze.dup
      # maze.map!(&:dup)

      # maze_length = maze.first.size
      # original_guard = guard
      # guard = guard.dup
      # maze[guard.y][guard.x] = "."
      # possible_loops = Set.new
      # loop do
      #   raise "Weird situation here #{maze[guard.y][guard.x]}" unless ALLOWED_CHARS.include?(maze[guard.y][guard.x])

      #   maze[guard.y][guard.x] = "X"
      #   case guard.direction
      #   when :up
      #     break if (guard.y - 1).negative?

      #     if guard.x + 1 < maze_length && # walking right is still allowed
      #        maze[guard.y - 1][guard.x] != "#" && # up is not blocked
      #        maze[guard.y][guard.x + 1] == "X" # right is visited
      #       possible_loops << [guard.y - 1, guard.x]
      #       possible_loops_maze[guard.y - 1][guard.x] = "O"
      #     end

      #     if maze[guard.y - 1][guard.x] == "#"
      #       guard.direction = :right
      #       next
      #     end

      #     guard.y -= 1
      #   when :down
      #     break if guard.y + 1 >= maze.size

      #     if (guard.x - 1 >= 0) && # walking left is stil allowed
      #        maze[guard.y + 1][guard.x] != "#" && # down is not blocked
      #        maze[guard.y][guard.x - 1] == "X" # left is visited
      #       possible_loops << [guard.y + 1, guard.x]
      #       possible_loops_maze[guard.y + 1][guard.x] = "O"
      #     end

      #     if maze[guard.y + 1][guard.x] == "#"
      #       guard.direction = :left
      #       next
      #     end

      #     guard.y = guard.y.succ
      #   when :left
      #     break if (guard.x - 1).negative?

      #     if (guard.y - 1 >= 0) && # walking up is still allowed
      #        maze[guard.y][guard.x - 1] != "#" && # left is not blocked
      #        maze[guard.y - 1][guard.x] == "X" # up is visited
      #       possible_loops << [guard.y, guard.x - 1]
      #       possible_loops_maze[guard.y][guard.x - 1] = "O"
      #     end

      #     if maze[guard.y][guard.x - 1] == "#"
      #       guard.direction = :up
      #       next
      #     end

      #     guard.x -= 1
      #   when :right
      #     break if guard.x + 1 >= maze_length

      #     if guard.y + 1 < maze_length && # walking down is still allowed
      #        maze[guard.y][guard.x + 1] != "#" && # right is not blocked
      #        maze[guard.y + 1][guard.x] == "X" # down is visited
      #       possible_loops << [guard.y, guard.x + 1]
      #       possible_loops_maze[guard.y][guard.x + 1] = "O"
      #     end
      #     if maze[guard.y][guard.x + 1] == "#"
      #       guard.direction = :down
      #       next
      #     end

      #     guard.x = guard.x.succ
      #   end
      # end

      # possible_loops << [guard.y, guard.x]
      # maze.each { |m| puts m }
      # puts "==="
      # possible_loops_maze.each { |m| puts m }
      # possible_loops = possible_loops.to_a
      # possible_loops.delete_if { |v| original_guard.y == v[0] && original_guard.x == v[1] }
      # possible_loops
    end
  end
end
