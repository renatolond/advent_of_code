# TODO: Write documentation for `Day20`
module Day20
  VERSION = "0.1.0"

  class TrenchMap
    @algorithm : String
    @width : Int32
    @current_image = [] of String
    @current_boundaries = 0
    getter current_image

    def initialize(algorithm)
      @algorithm = algorithm
      @width = 0
    end

    def read_line(line)
      @width = line.size
      @current_image << line
    end

    def enhance!
      output_image = [] of String
      new_width = @width + 2
      height = @current_image.size
      new_height = @current_image.size + 2
      new_height.times do |idx|
        curr_line = ""
        new_width.times do |jdx|
          algo_idx = 0
          (-1..1).each do |incr_i|
            (-1..1).each do |incr_j|
              algo_idx <<= 1
              new_i = incr_i + idx
              new_j = incr_j + jdx
              old_i = new_i - 1
              old_j = new_j - 1
              if old_i < 0 || old_j < 0 || old_i >= height || old_j >= @width
                algo_idx += @current_boundaries
              else
                if @current_image[old_i][old_j] == '#'
                  algo_idx += 1
                else
                  # no-op
                end
              end
            end
          end
          curr_line += @algorithm[algo_idx]
        end
        output_image << curr_line
      end
      @current_boundaries = if @current_boundaries == 0
                              @current_boundaries = @algorithm[0] == '#' ? 1 : 0
                            else
                              @current_boundaries = 0
                            end
      @current_image = output_image
      @width = new_width
    end
    def lit_pixels
      lit_pixels = 0
      @current_image.each do |lines|
        lines.chars.each do |c|
          lit_pixels += 1 if c == '#'
        end
      end
      lit_pixels
    end
    def print_current_image
      @current_image.each do |line|
        puts line
      end
    end
  end

  def self.part_1()
    algorithm = gets()
    raise "Wrong input" unless algorithm
    tm = Day20::TrenchMap.new(algorithm)
    _blank_line = gets()

    while (line = gets())
      tm.read_line(line)
    end

    tm.print_current_image
    tm.enhance!
    tm.print_current_image
    tm.enhance!
    tm.print_current_image
    puts tm.lit_pixels
  end

  def self.part_2()
    algorithm = gets()
    raise "Wrong input" unless algorithm
    tm = Day20::TrenchMap.new(algorithm)
    _blank_line = gets()

    while (line = gets())
      tm.read_line(line)
    end

    50.times do
      tm.enhance!
    end
    puts tm.lit_pixels
  end
end
