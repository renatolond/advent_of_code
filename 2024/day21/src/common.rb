# frozen_string_literal: true

module Common
  Point = Data.define(:y, :x)

  NUMERIC_KEYPAD = [
    %w[7 8 9],
    %w[4 5 6],
    %w[1 2 3],
    %w[# 0 A]
  ].freeze

  # NUMERIC_KEYPAD_START_POS = Point.new(2, 1)

  DIRECTIONAL_KEYPAD = [
    %w[# ^ A],
    %w[< v >]
  ].freeze

  # DIRECTIONAL_KEYPAD_START_POS = Point.new(0, 1)

  class << self
    def numeric_find_pos(el)
      @numeric_points ||= {}
      @numeric_points[el] ||= begin
        found = false
        idy = 0
        while idy < NUMERIC_KEYPAD.size
          idx = 0
          while idx < NUMERIC_KEYPAD[idy].size
            if NUMERIC_KEYPAD[idy][idx] == el
              found = true
              break
            end

            idx = idx.succ
          end
          break if found

          idy = idy.succ
        end
        Point.new(idy, idx)
      end
    end

    # @param start_pos [Point]
    # @param points [String]
    def numeric_min_paths
      @numeric_min_paths = {}
      NUMERIC_KEYPAD.flatten.sort.permutation(2) do |a, b|
        next if a == "#" || b == "#"

        start_pos = numeric_find_pos(a)
        end_pos = numeric_find_pos(b)

        cost = Float::INFINITY

        visited = Array.new(NUMERIC_KEYPAD.size) { Array.new(NUMERIC_KEYPAD.first.size) { Float::INFINITY } }

        final_paths = []
        visited_path = []
        queue = []
        queue << [start_pos, 0, visited_path]
        while (curr_node = queue.shift)
          curr_pos, current_cost, visited_path = curr_node

          next if NUMERIC_KEYPAD[curr_pos.y][curr_pos.x] == "#"
          next if visited[curr_pos.y][curr_pos.x] < current_cost

          visited[curr_pos.y][curr_pos.x] = current_cost

          if curr_pos == end_pos
            if cost >= current_cost
              cost = current_cost
              visited_path << "A"
              final_paths << visited_path.join
            end
            next
          end

          if curr_pos.y - 1 >= 0
            new_visited_path = visited_path.dup
            new_visited_path << "^"
            queue << [Point.new(curr_pos.y - 1, curr_pos.x), current_cost + 1, new_visited_path]
          end
          if curr_pos.x - 1 >= 0
            new_visited_path = visited_path.dup
            new_visited_path << "<"
            queue << [Point.new(curr_pos.y, curr_pos.x - 1), current_cost + 1, new_visited_path]
          end
          if curr_pos.y + 1 < NUMERIC_KEYPAD.size
            new_visited_path = visited_path.dup
            new_visited_path << "v"
            queue << [Point.new(curr_pos.y + 1, curr_pos.x), current_cost + 1, new_visited_path]
          end
          if curr_pos.x + 1 < NUMERIC_KEYPAD.first.size # rubocop:disable Style/Next
            new_visited_path = visited_path.dup
            new_visited_path << ">"
            queue << [Point.new(curr_pos.y, curr_pos.x + 1), current_cost + 1, new_visited_path]
          end
        end

        @numeric_min_paths[[a, b]] = {
          cost:,
          paths: final_paths
        }
      end
      # pp @numeric_min_paths
    end

    def optimized_numeric_path
      @numeric_min_paths = { %w[0 1] => { cost: 2, paths: ["^<A"] },
                             %w[0 2] => { cost: 1, paths: ["^A"] },
                             %w[0 3] => { cost: 2, paths: ["^>A", ">^A"] },
                             %w[0 4] => { cost: 3, paths: ["^^<A"] },
                             %w[0 5] => { cost: 2, paths: ["^^A"] },
                             %w[0 6] => { cost: 3, paths: ["^^>A", ">^^A"] },
                             %w[0 7] => { cost: 4, paths: ["^^^<A"] },
                             %w[0 8] => { cost: 3, paths: ["^^^A"] },
                             %w[0 9] => { cost: 4, paths: ["^^^>A", ">^^^A"] },
                             %w[0 A] => { cost: 1, paths: [">A"] },
                             %w[1 0] => { cost: 2, paths: [">vA"] },
                             %w[1 2] => { cost: 1, paths: [">A"] },
                             %w[1 3] => { cost: 2, paths: [">>A"] },
                             %w[1 4] => { cost: 1, paths: ["^A"] },
                             %w[1 5] => { cost: 2, paths: ["^>A", ">^A"] },
                             %w[1 6] => { cost: 3, paths: ["^>>A", ">>^A"] },
                             %w[1 7] => { cost: 2, paths: ["^^A"] },
                             %w[1 8] => { cost: 3, paths: ["^^>A", ">^^A"] },
                             %w[1 9] => { cost: 4, paths: ["^^>>A", ">>^^A"] },
                             %w[1 A] => { cost: 3, paths: [">v>A", ">>vA"] },
                             %w[2 0] => { cost: 1, paths: ["vA"] },
                             %w[2 1] => { cost: 1, paths: ["<A"] },
                             %w[2 3] => { cost: 1, paths: [">A"] },
                             %w[2 4] => { cost: 2, paths: ["^<A", "<^A"] },
                             %w[2 5] => { cost: 1, paths: ["^A"] },
                             %w[2 6] => { cost: 2, paths: ["^>A", ">^A"] },
                             %w[2 7] => { cost: 3, paths: ["^^<A", "<^^A"] },
                             %w[2 8] => { cost: 2, paths: ["^^A"] },
                             %w[2 9] => { cost: 3, paths: ["^^>A", ">^^A"] },
                             %w[2 A] => { cost: 2, paths: ["v>A", ">vA"] },
                             %w[3 0] => { cost: 2, paths: ["<vA", "v<A"] },
                             %w[3 1] => { cost: 2, paths: ["<<A"] },
                             %w[3 2] => { cost: 1, paths: ["<A"] },
                             %w[3 4] => { cost: 3, paths: ["^<<A", "<<^A"] },
                             %w[3 5] => { cost: 2, paths: ["^<A", "<^A"] },
                             %w[3 6] => { cost: 1, paths: ["^A"] },
                             %w[3 7] => { cost: 4, paths: ["^^<<A", "<<^^A"] },
                             %w[3 8] => { cost: 3, paths: ["^^<A", "<^^A"] },
                             %w[3 9] => { cost: 2, paths: ["^^A"] },
                             %w[3 A] => { cost: 1, paths: ["vA"] },
                             %w[4 0] => { cost: 3, paths: ["v>vA", ">vvA"] },
                             %w[4 1] => { cost: 1, paths: ["vA"] },
                             %w[4 2] => { cost: 2, paths: ["v>A", ">vA"] },
                             %w[4 3] => { cost: 3, paths: ["v>>A", ">>vA"] },
                             %w[4 5] => { cost: 1, paths: [">A"] },
                             %w[4 6] => { cost: 2, paths: [">>A"] },
                             %w[4 7] => { cost: 1, paths: ["^A"] },
                             %w[4 8] => { cost: 2, paths: ["^>A", ">^A"] },
                             %w[4 9] => { cost: 3, paths: ["^>>A", ">>^A"] },
                             %w[4 A] => { cost: 4, paths: [">>vvA"] },
                             %w[5 0] => { cost: 2, paths: ["vvA"] },
                             %w[5 1] => { cost: 2, paths: ["<vA", "v<A"] },
                             %w[5 2] => { cost: 1, paths: ["vA"] },
                             %w[5 3] => { cost: 2, paths: ["v>A", ">vA"] },
                             %w[5 4] => { cost: 1, paths: ["<A"] },
                             %w[5 6] => { cost: 1, paths: [">A"] },
                             %w[5 7] => { cost: 2, paths: ["^<A", "<^A"] },
                             %w[5 8] => { cost: 1, paths: ["^A"] },
                             %w[5 9] => { cost: 2, paths: ["^>A", ">^A"] },
                             %w[5 A] => { cost: 3, paths: ["vv>A", ">vvA"] },
                             %w[6 0] => { cost: 3, paths: ["<vvA", "vv<A"] },
                             %w[6 1] => { cost: 3, paths: ["<<vA", "v<<A"] },
                             %w[6 2] => { cost: 2, paths: ["<vA", "v<A"] },
                             %w[6 3] => { cost: 1, paths: ["vA"] },
                             %w[6 4] => { cost: 2, paths: ["<<A"] },
                             %w[6 5] => { cost: 1, paths: ["<A"] },
                             %w[6 7] => { cost: 3, paths: ["^<<A", "<<^A"] },
                             %w[6 8] => { cost: 2, paths: ["^<A", "<^A"] },
                             %w[6 9] => { cost: 1, paths: ["^A"] },
                             %w[6 A] => { cost: 2, paths: ["vvA"] },
                             %w[7 0] => { cost: 4, paths: ["vv>vA", ">vvvA"] },
                             %w[7 1] => { cost: 2, paths: ["vvA"] },
                             %w[7 2] => { cost: 3, paths: ["vv>A", ">vvA"] },
                             %w[7 3] => { cost: 4, paths: ["vv>>A", ">>vvA"] },
                             %w[7 4] => { cost: 1, paths: ["vA"] },
                             %w[7 5] => { cost: 2, paths: ["v>A", ">vA"] },
                             %w[7 6] => { cost: 3, paths: ["v>>A", ">>vA"] },
                             %w[7 8] => { cost: 1, paths: [">A"] },
                             %w[7 9] => { cost: 2, paths: [">>A"] },
                             %w[7 A] => { cost: 5, paths: [">>vvvA"] },
                             %w[8 0] => { cost: 3, paths: ["vvvA"] },
                             %w[8 1] => { cost: 3, paths: ["<vvA", "vv<A"] },
                             %w[8 2] => { cost: 2, paths: ["vvA"] },
                             %w[8 3] => { cost: 3, paths: ["vv>A", ">vvA"] },
                             %w[8 4] => { cost: 2, paths: ["<vA", "v<A"] },
                             %w[8 5] => { cost: 1, paths: ["vA"] },
                             %w[8 6] => { cost: 2, paths: ["v>A", ">vA"] },
                             %w[8 7] => { cost: 1, paths: ["<A"] },
                             %w[8 9] => { cost: 1, paths: [">A"] },
                             %w[8 A] => { cost: 4, paths: ["vvv>A", ">vvvA"] },
                             %w[9 0] => { cost: 4, paths: ["<vvvA", "vvv<A"] },
                             %w[9 1] => { cost: 4, paths: ["<<vvA", "vv<<A"] },
                             %w[9 2] => { cost: 3, paths: ["<vvA", "vv<A"] },
                             %w[9 3] => { cost: 2, paths: ["vvA"] },
                             %w[9 4] => { cost: 3, paths: ["<<vA", "v<<A"] },
                             %w[9 5] => { cost: 2, paths: ["<vA", "v<A"] },
                             %w[9 6] => { cost: 1, paths: ["vA"] },
                             %w[9 7] => { cost: 2, paths: ["<<A"] },
                             %w[9 8] => { cost: 1, paths: ["<A"] },
                             %w[9 A] => { cost: 3, paths: ["vvvA"] },
                             %w[A 0] => { cost: 1, paths: ["<A"] },
                             %w[A 1] => { cost: 3, paths: ["^<<A"] },
                             %w[A 2] => { cost: 2, paths: ["^<A", "<^A"] },
                             %w[A 3] => { cost: 1, paths: ["^A"] },
                             %w[A 4] => { cost: 4, paths: ["^^<<A"] },
                             %w[A 5] => { cost: 3, paths: ["^^<A", "<^^A"] },
                             %w[A 6] => { cost: 2, paths: ["^^A"] },
                             %w[A 7] => { cost: 5, paths: ["^^^<<A"] },
                             %w[A 8] => { cost: 4, paths: ["^^^<A", "<^^^A"] },
                             %w[A 9] => { cost: 3, paths: ["^^^A"] } }
    end

    def optimized_directional_path
      @directional_min_paths = {
        "<" => {
          ">" => { cost: 3, paths: [">>A"], path: ">>A" },
          "A" => { cost: 4, paths: [">>^A"], path: ">>^A" },
          "^" => { cost: 3, paths: [">^A"], path: ">^A" },
          "v" => { cost: 2, paths: [">A"], path: ">A" }
        },
        ">" => {
          "<" => { cost: 3, paths: ["<<A"], path: "<<A" },
          "A" => { cost: 2, paths: ["^A"], path: "^A" },
          "^" => { cost: 3, paths: ["^<A", "<^A"], path: "<^A" },
          "v" => { cost: 2, paths: ["<A"], path: "<A" }
        },
        "A" => {
          "<" => { cost: 4, paths: ["v<<A"], path: "v<<A" },
          ">" => { cost: 2, paths: ["vA"], path: "vA" },
          "^" => { cost: 2, paths: ["<A"], path: "<A" },
          "v" => { cost: 3, paths: ["<vA", "v<A"], path: "<vA" }
        },
        "^" => {
          "<" => { cost: 3, paths: ["v<A"], path: "v<A" },
          ">" => { cost: 3, paths: ["v>A", ">vA"], path: "v>A" },
          "A" => { cost: 2, paths: [">A"], path: ">A" },
          "v" => { cost: 2, paths: ["vA"], path: "vA" }
        },
        "v" => {
          "<" => { cost: 2, paths: ["<A"], path: "<A" },
          ">" => { cost: 2, paths: [">A"], path: ">A" },
          "A" => { cost: 3, paths: ["^>A", ">^A"], path: "^>A" },
          "^" => { cost: 2, paths: ["^A"], path: "^A" }
        }
      }

      # @directional_min_paths.each_value do |vv|
      #   vv.each_value do |v|
      #     costs = Array.new(v[:paths].size, 0)
      #     idx = 0
      #     v[:paths].each do |path|
      #       path.chars.each_cons(2) do |a, b|
      #         costs[idx] += if a == b
      #           1
      #         else
      #           v[:cost]
      #         end
      #       end
      #       idx += 1
      #     end
      #     v[:path] = v[:paths].zip(costs).min_by { |vv| vv[1] }[0]
      #     v[:cost] = v[:path].size
      #   end
      # end
    end

    def directional_find_pos(el)
      @directional_points ||= {}
      @directional_points[el] ||= begin
        found = false
        idy = 0
        while idy < DIRECTIONAL_KEYPAD.size
          idx = 0
          while idx < DIRECTIONAL_KEYPAD[idy].size
            if DIRECTIONAL_KEYPAD[idy][idx] == el
              found = true
              break
            end

            idx = idx.succ
          end
          break if found

          idy = idy.succ
        end
        Point.new(idy, idx)
      end
    end

    # @param start_pos [Point]
    # @param points [String]
    def directional_min_paths
      @directional_min_paths = {}
      DIRECTIONAL_KEYPAD.flatten.sort.permutation(2) do |a, b|
        next if a == "#" || b == "#"

        start_pos = directional_find_pos(a)
        end_pos = directional_find_pos(b)

        cost = Float::INFINITY

        visited = Array.new(DIRECTIONAL_KEYPAD.size) { Array.new(DIRECTIONAL_KEYPAD.first.size) { Float::INFINITY } }

        final_paths = []
        visited_path = []
        queue = []
        queue << [start_pos, 0, visited_path]
        while (curr_node = queue.shift)
          curr_pos, current_cost, visited_path = curr_node

          next if DIRECTIONAL_KEYPAD[curr_pos.y][curr_pos.x] == "#"
          next if visited[curr_pos.y][curr_pos.x] < current_cost

          visited[curr_pos.y][curr_pos.x] = current_cost

          if curr_pos == end_pos
            if cost >= current_cost
              cost = current_cost
              visited_path << "A"
              final_paths << visited_path.join
            end
            next
          end

          if curr_pos.y - 1 >= 0
            new_visited_path = visited_path.dup
            new_visited_path << "^"
            queue << [Point.new(curr_pos.y - 1, curr_pos.x), current_cost + 1, new_visited_path]
          end
          if curr_pos.x - 1 >= 0
            new_visited_path = visited_path.dup
            new_visited_path << "<"
            queue << [Point.new(curr_pos.y, curr_pos.x - 1), current_cost + 1, new_visited_path]
          end
          if curr_pos.y + 1 < DIRECTIONAL_KEYPAD.size
            new_visited_path = visited_path.dup
            new_visited_path << "v"
            queue << [Point.new(curr_pos.y + 1, curr_pos.x), current_cost + 1, new_visited_path]
          end
          if curr_pos.x + 1 < DIRECTIONAL_KEYPAD.first.size # rubocop:disable Style/Next
            new_visited_path = visited_path.dup
            new_visited_path << ">"
            queue << [Point.new(curr_pos.y, curr_pos.x + 1), current_cost + 1, new_visited_path]
          end
        end

        @directional_min_paths[[a, b]] = {
          cost:,
          paths: final_paths
        }
      end
      # pp @directional_min_paths
    end

    def recursive_convert(a, b, depth:)
      if depth == max_depth - 1
        return 1 if a == b

        return @directional_min_paths[a][b][:cost]
      end

      @memoization ||= Hash.new { |h, k| h[k] = Hash.new { |hh, kk| hh[kk] = {} } }
      return @memoization[depth][a][b] unless @memoization[depth][a][b].nil?

      best = Float::INFINITY
      if depth.zero?
        @numeric_min_paths[[a, b]][:paths].each do |path|
          idx = 0
          len = 0
          while idx < path.size
            p1 = if idx.zero?
              "A"
            else
              path[idx.pred]
            end
            p2 = path[idx]
            len += recursive_convert(p1, p2, depth: depth.succ)
            idx = idx.succ
          end
          best = len if best > len
        end
      else
        path = if a == b
          "A"
        else
          @directional_min_paths[a][b][:path]
        end
        idx = 0
        len = 0
        while idx < path.size
          p1 = if idx.zero?
            "A"
          else
            path[idx.pred]
          end
          p2 = path[idx]
          len += recursive_convert(p1, p2, depth: depth.succ)
          idx = idx.succ
        end
        best = len if best > len
      end
      @memoization[depth][a][b] = best
    end

    def print_memoize
      pp @memoization
    end
    attr_accessor :max_depth

    def convert_from_numeric(orig_path)
      orig_path = "A#{orig_path}"
      new_paths = [+""]
      orig_path.chars.each_cons(2) do |a, b|
        if a == b
          new_path << "A"
          next
        end
        new_new_paths = []
        @numeric_min_paths[[a, b]][:paths].each do |path|
          new_paths.each do |old_path|
            new_new_paths << (old_path + path)
          end
        end
        new_paths = new_new_paths
      end
      new_paths
    end

    def convert_from_directional(paths)
      paths.map! do |orig_path|
        new_path = String.new("", encoding: orig_path.encoding, capacity: orig_path.size * 3)
        jdx = 0

        a = "A"
        b = orig_path[0]
        if a.ord == b.ord
          new_path[jdx] = "A"
          jdx += 1
        else
          new_path[jdx..jdx + @directional_min_paths[a][b][:cost]] = @directional_min_paths[a][b][:path]
          jdx += @directional_min_paths[a][b][:cost]
        end

        idx = 1
        while idx < orig_path.size
          a = orig_path[idx - 1]
          b = orig_path[idx]
          if a.ord == b.ord
            new_path[jdx] = "A"
            jdx += 1
            idx = idx.succ
            next
          end
          @directional_min_paths[a][b][:cost].times do |i|
            new_path[jdx] = @directional_min_paths[a][b][:path][i]
            jdx = jdx.succ
          end
          idx = idx.succ
        end
        new_path
      end
    end
  end
end
