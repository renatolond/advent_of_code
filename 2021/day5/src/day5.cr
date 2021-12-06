# TODO: Write documentation for `Day5`
module Day5
  VERSION = "0.1.0"

  class VentDetectionSystem
    def initialize(ignore_diagonal = true)
      @ignore_diagonal = ignore_diagonal
      @points_touched = {} of String => Int64
    end

    def add_vent(line)
      point1, point2 = line.split(" -> ")
      x1, y1 = point1.split(",")
      x1 = Int64.new(x1)
      y1 = Int64.new(y1)
      x2, y2 = point2.split(",")
      x2 = Int64.new(x2)
      y2 = Int64.new(y2)
      if x1 != x2 && y1 != y2 && @ignore_diagonal
        puts "Ignoring #{line} because it's not straight"
        return
      end

      walk_the_line(x1, y1, x2, y2)
    end

    def most_danger_qty
      @points_touched.select { |_k, v| v > 1 }.size
    end

      def mark(x, y)
        key = "#{x},#{y}"
        @points_touched[key] ||= 0
        @points_touched[key] += 1
      end

      def walk_the_line(x1, y1, x2, y2)
        if x1 == x2
          min = [y1, y2].min
          max = [y1, y2].max

          curr_y = min
          while (curr_y <= max)
            mark(x1, curr_y)
            curr_y += 1
          end
        elsif y1 == y2
          min = [x1, x2].min
          max = [x1, x2].max

          curr_x = min
          while (curr_x <= max)
            mark(curr_x, y1)
            curr_x += 1
          end
        else
          direction_x = x2 - x1
          direction_y = y2 - y1
          common = direction_x.gcd(direction_y)
          direction_x = direction_x / common
          direction_y = direction_y / common

          curr_x = x1
          curr_y = y1

          while curr_x != x2 && curr_y != y2
            if curr_x - curr_x.to_i64 > Float64::EPSILON ||
                curr_y - curr_y.to_i64 > Float64::EPSILON
              puts "Ignoring #{curr_x}, #{curr_y}, seems out of the grid"
            else
              mark(curr_x.to_i64, curr_y.to_i64)
            end
            curr_x += direction_x
            curr_y += direction_y
          end
          mark(curr_x.to_i64, curr_y.to_i64)
        end
      end
  end

  def self.part_1()
    vds = VentDetectionSystem.new
    while (line = gets())
      vds.add_vent(line)
    end
    puts vds.most_danger_qty
  end

  def self.part_2()
    vds = VentDetectionSystem.new(ignore_diagonal: false)
    while (line = gets())
      vds.add_vent(line)
    end
    puts vds.most_danger_qty
  end
end
