# TODO: Write documentation for `Day9`
module Day13
  VERSION = "0.1.0"

  class OrigamiFolder
    @points = [] of NamedTuple(x: Int64, y: Int64)
    @max_width = -1_i64
    @max_height = -1_i64
    def add_point(line)
      x, y = line.split(",").map(&.to_i64)

      @max_width = x + 1 if x + 1 > @max_width
      @max_height = y + 1 if y + 1 > @max_height
      @points << { x: x, y: y }
    end

    def instruction(line)
      real_instruction = line.split(" ").last
      axis, pos = real_instruction.split("=")
      pos = pos.to_i64
      if axis == "x"
        fold_x(pos)
      else
        fold_y(pos)
      end
    end

    def fold_y(pos)
      before_fold, after_fold = @points.partition { |v| v[:y] <= pos }
      @points = before_fold

      idx = pos + 1
      reverse_idx = pos - 1
      while idx < @max_height && reverse_idx >= 0
        line = after_fold.select { |v| v[:y] == idx }
        line.each do |point|
          @points << { x: point[:x], y: reverse_idx }
        end
        idx += 1
        reverse_idx -= 1
      end

      @max_height = pos
      true
    end

    def fold_x(pos)
      before_fold, after_fold = @points.partition { |v| v[:x] <= pos }
      @points = before_fold

      idy = pos + 1
      reverse_idy = pos - 1
      while idy < @max_width && reverse_idy >= 0
        line = after_fold.select { |v| v[:x] == idy }
        line.each do |point|
          @points << { y: point[:y], x: reverse_idy }
        end
        idy += 1
        reverse_idy -= 1
      end

      @max_width = pos
      true
    end

    def print_board
      the_board = [] of String
      @max_height.times do |jdx|
        line = @points.select { |v| v[:y] == jdx }
        to_print = ""
        @max_width.times do |idx|
          if line.find { |v| v[:x] == idx }
            to_print += "#"
          else
            to_print += "."
          end
        end
        the_board << to_print
      end
      the_board
    end

    def visible
      @points.uniq.size
    end
  end

  def self.part_1()
    ofold = Day13::OrigamiFolder.new
    reading_coords = true
    while (line = gets)
      if line.empty?
        reading_coords = false
        next
      end
      if reading_coords
        ofold.add_point(line)
      else
        ofold.instruction(line)
        break
      end
    end
    ofold.print_board.each do |line|
      puts line
    end
    puts ofold.visible
  end

  def self.part_2()
    ofold = Day13::OrigamiFolder.new
    reading_coords = true
    while (line = gets)
      if line.empty?
        reading_coords = false
        next
      end
      if reading_coords
        ofold.add_point(line)
      else
        ofold.instruction(line)
      end
    end
    ofold.print_board.each do |line|
      puts line
    end
    puts ofold.visible
  end
end
