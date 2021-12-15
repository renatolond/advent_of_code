# TODO: Write documentation for `Day9`
module Day15
  VERSION = "0.1.0"

  class CaveNavigator
    @cave_layout : Array(Array(Int64))
    @width : Nil | Int32
    @lowest_risk_path : Nil | Int64
    def initialize(multiply_input = false)
      @lines = 0
      @width = nil
      @cave_layout = [] of Array(Int64)
      @multiply_input = multiply_input
    end


    def cave_layout
      output = @cave_layout.map { |line| line.map(&.to_s).join }
    end
    def read(line)
      @cave_layout << line.split("").map(&.to_i64)
      @width = @cave_layout[@lines].size if @width.nil?
      raise "Wrong width!" if @width != @cave_layout[@lines].size
      @lines += 1
    end

    def redimension_cave
      raise "oh no" unless @width
      @lines.times do |idx|
        4.times do |v|
          v += 1
          @width.not_nil!.times do |jdx|
            new_risk = (@cave_layout[idx][jdx] + v)
            new_risk -= 9 if new_risk >= 10
            @cave_layout[idx] << new_risk
          end
        end
      end
      4.times do |v|
        v = v + 1
        @lines.times do |idx|
          new_line = [] of Int64
          @cave_layout[idx].size.times do |jdx|
            new_risk = (@cave_layout[idx][jdx] + v)
            new_risk -= 9 if new_risk >= 10
            new_line << new_risk
          end
          @cave_layout << new_line
        end
      end
      @multiply_input = false
      @width = @cave_layout.first.size
      @lines = @cave_layout.size
    end

    def calculate_path : Int64 | Nil
      raise "oh no" unless @width
      redimension_cave if @multiply_input
      dist = Array(Array(Int64 | Float32)).new(@lines) { Array(Int64 | Float32).new(@width.not_nil!, Float32::INFINITY) }
      prev = Array(Array(NamedTuple(i: Int32, j: Int32) | Nil)).new(@lines) { Array(NamedTuple(i: Int32, j: Int32) | Nil).new(@width.not_nil!, nil) }
      visited = Array(Array(Bool)).new(@lines) { Array(Bool).new(@width.not_nil!, false) }

      visit_set = [] of NamedTuple(i: Int32, j: Int32, dist: Int64)
      dist[0][0] = 0_i64 # start point
      visit_set << {i: 0, j: 0, dist: 0_i64}

      while !visit_set.empty?
        current_node = visit_set.shift
        next if visited[current_node[:i]][current_node[:j]]
        visited[current_node[:i]][current_node[:j]] = true

        [[-1, 0], [0, -1], [0, 1], [1, 0]].each do |pair|
          idx = current_node[:i] + pair.first
          jdx = current_node[:j] + pair.last
          next if idx < 0 || jdx < 0 || idx >= @lines || jdx >= @width.not_nil!

          new_dist = dist[current_node[:i]][current_node[:j]] + @cave_layout[idx][jdx]
          if new_dist < dist[idx][jdx]
            dist[idx][jdx] = new_dist
            prev[idx][jdx] = { i: current_node[:i], j: current_node[:j] }
          end
          unless visited[idx][jdx]
            inserted = false
            visit_set.each_with_index do |v, i|
              if v[:dist] > new_dist.to_i64
                visit_set.insert(i, {i: idx, j: jdx, dist: new_dist.to_i64})
                inserted = true
                break
              end
            end
            visit_set << {i: idx, j: jdx, dist: new_dist.to_i64} unless inserted
          end
        end
      end

      ret_values = nil
      if dist[@lines-1][@width.not_nil! - 1].is_a? Int64
        ret_values = dist[@lines-1][@width.not_nil! - 1].to_i64
      end
      ret_values
    end

    def lowest_risk_path
      @lowest_risk_path ||= calculate_path
    end
  end

  def self.part_1()
    gps = Day15::CaveNavigator.new
    while (line = gets())
      gps.read(line)
    end

    puts gps.lowest_risk_path
  end

  def self.part_2()
    gps = Day15::CaveNavigator.new(multiply_input: true)
    while (line = gets())
      gps.read(line)
    end

    puts gps.lowest_risk_path
  end
end
