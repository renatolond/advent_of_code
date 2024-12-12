# frozen_string_literal: true

module Common
  Point = Data.define(:y, :x)
  class Garden
    def initialize
      @plots = []
      @visited_plots = []
    end

    def add_line(line)
      @plots << line
      @visited_plots << Array.new(line.size, false)
    end

    def fence_cost
      cost = 0
      @region_map = Array.new(y_size + 2) { Array.new(x_size + 2, -1) }

      region_label = 0
      y_size.times do |idx|
        x_size.times do |jdx|
          next if @visited_plots[idx][jdx]

          area =  calculate_area_for(idx, jdx, region_label)
          perimeter = perimeter_of_region(region_label)
          cost += (area * perimeter)
          region_label = region_label += 1
        end
      end

      # @region_map.each do |r|
      #   r.each do |rr|
      #     print(format("%3d", rr))
      #   end
      #   puts ""
      # end
      cost
    end

    def fence_cost_bulk
      cost = 0
      @region_map = Array.new(y_size + 2) { Array.new(x_size + 2, -1) }

      region_label = 0
      y_size.times do |idx|
        x_size.times do |jdx|
          next if @visited_plots[idx][jdx]

          area =  calculate_area_for(idx, jdx, region_label)
          sides = sides_of_region(region_label)
          p "#{@plots[idx][jdx]}: A=#{area}, S=#{sides}"
          cost += (area * sides)
          region_label = region_label += 1
        end
      end

      @region_map.each do |r|
        r.each do |rr|
          print(format("%3d", rr))
        end
        puts ""
      end
      cost
    end

    def calculate_area_for(start_y, start_x, region_label)
      plant_type = @plots[start_y][start_x]

      doubled_plot = Array.new(y_size) { "." * x_size }
      area = 0

      queue = []
      queue << Point.new(start_y, start_x)
      while (curr = queue.pop)
        next unless @plots[curr.y][curr.x] == plant_type && !@visited_plots[curr.y][curr.x]

        doubled_plot[curr.y][curr.x] = plant_type
        @region_map[curr.y + 1][curr.x + 1] = region_label

        area += 1
        @visited_plots[curr.y][curr.x] = true

        queue << Point.new(curr.y - 1, curr.x) if curr.y - 1 >= 0
        queue << Point.new(curr.y + 1, curr.x) if curr.y + 1 < y_size
        queue << Point.new(curr.y, curr.x - 1) if curr.x - 1 >= 0
        queue << Point.new(curr.y, curr.x + 1) if curr.x + 1 < x_size
      end

      area
    end

    def perimeter_of_region(region_label)
      perimeter = 0
      y_size.times do |idy|
        idy += 1 # start off 1
        x_size.times do |idx|
          idx += 1 # start off 1

          next unless @region_map[idy][idx] == region_label

          perimeter += 1 if @region_map[idy - 1][idx] != region_label
          perimeter += 1 if @region_map[idy + 1][idx] != region_label
          perimeter += 1 if @region_map[idy][idx - 1] != region_label
          perimeter += 1 if @region_map[idy][idx + 1] != region_label
        end
      end
      perimeter
    end

    def sides_of_region(region_label)
      sides = 0
      y_size.times do |idy|
        idy += 1 # start off 1
        x_size.times do |idx|
          idx += 1 # start off 1

          next unless @region_map[idy][idx] == region_label

          sides += 1 if @region_map[idy - 1][idx] != region_label && @region_map[idy][idx - 1] != region_label # .- corner
          sides += 1 if @region_map[idy - 1][idx] != region_label && @region_map[idy][idx + 1] != region_label # -. corner
          sides += 1 if @region_map[idy + 1][idx] != region_label && @region_map[idy][idx + 1] != region_label # _| corner
          sides += 1 if @region_map[idy + 1][idx] != region_label && @region_map[idy][idx - 1] != region_label # |_ corner
          sides += 1 if @region_map[idy - 1][idx] == region_label && @region_map[idy][idx + 1] == region_label && @region_map[idy - 1][idx + 1] != region_label # |_ corner, inside
          sides += 1 if @region_map[idy - 1][idx] == region_label && @region_map[idy][idx - 1] == region_label && @region_map[idy - 1][idx - 1] != region_label # _| corner, inside
          sides += 1 if @region_map[idy + 1][idx] == region_label && @region_map[idy][idx - 1] == region_label && @region_map[idy + 1][idx - 1] != region_label # -. corner, inside
          sides += 1 if @region_map[idy + 1][idx] == region_label && @region_map[idy][idx + 1] == region_label && @region_map[idy + 1][idx + 1] != region_label # _| corner, inside
        end
      end
      sides
    end

    def y_size
      @y_size ||= @plots.size
    end

    def x_size
      @x_size ||= @plots.first.size
    end
  end
  class << self
  end
end
