# TODO: Write documentation for `Day9`
module Day9
  VERSION = "0.1.0"

  class RiskMapper
    @heightmap : Array(Array(Int64))
    @touched : Array(Array(Bool))
    @low_points_tuple : Array(NamedTuple(i: Int32, j: Int32, v: Int64)) | Nil
    @basins : Array(Int64) | Nil
    @width : Nil | Int32
    def initialize
      @lines = 0
      @width = nil
      @heightmap = [] of Array(Int64)
      @touched = [] of Array(Bool)
    end

    def read(line)
      @heightmap << line.split("").map(&.to_i64)
      @width = @heightmap[@lines].size if @width.nil?
      raise "Wrong width!" if @width != @heightmap[@lines].size
      @touched << Array(Bool).new(@width.not_nil!, false)
      @lines += 1
    end

    def calculate_low_points
      low_points = [] of NamedTuple(i: Int32, j: Int32, v: Int64)
      raise "Read first" if @width.nil?

      @lines.times.each do |idx|
        @width.not_nil!.times.each do |jdx|
          value = @heightmap[idx][jdx]
          lower = true
          lower &= value < @heightmap[idx - 1][jdx] if idx > 0
          lower &= value < @heightmap[idx][jdx - 1] if jdx > 0
          lower &= value < @heightmap[idx + 1][jdx] if idx+1 < @lines
          lower &= value < @heightmap[idx][jdx + 1] if jdx+1 < @width.not_nil!
          low_points << { i: idx, j: jdx, v: value } if lower
        end
      end
      low_points
    end

    def reach_out(i, j)
      if i < 0 || j < 0 || i >= @lines || j >= @width.not_nil!
        return 0
      end
      if @touched[i][j] || @heightmap[i][j] == 9
        return 0
      end
      basin_size = 1
      @touched[i][j] = true
      basin_size += reach_out(i - 1, j)
      basin_size += reach_out(i, j - 1)
      basin_size += reach_out(i + 1, j)
      basin_size += reach_out(i, j + 1)
      basin_size
    end

    def calculate_basins
      basins = [] of Int64
      low_points_tuple.each do |low_point|
        basin_size = 1_i64
        @touched[low_point[:i]][low_point[:j]] = true
        basin_size += reach_out(low_point[:i] - 1, low_point[:j])
        basin_size += reach_out(low_point[:i], low_point[:j] - 1)
        basin_size += reach_out(low_point[:i] + 1, low_point[:j])
        basin_size += reach_out(low_point[:i], low_point[:j] + 1)
        basins << basin_size
      end
      basins
    end

    def low_points_tuple
      @low_points_tuple ||= calculate_low_points
    end

    def low_points
      low_points_tuple.map { |v| v[:v] }
    end

    def risk_sum
      low_points_tuple.map { |v| v[:v] + 1 }.sum
    end

    def basins
      @basins ||= calculate_basins
    end

    def largest_basins
      basins.sort.last(3)
    end

    def basin_result
      largest_basins.product(1)
    end
  end

  def self.part_1()
    rm = RiskMapper.new
    while (line = gets())
      rm.read(line)
    end
    puts rm.risk_sum
  end

  def self.part_2()
    rm = RiskMapper.new
    while (line = gets())
      rm.read(line)
    end
    puts rm.basin_result
  end
end
