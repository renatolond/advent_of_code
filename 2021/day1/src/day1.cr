# TODO: Write documentation for `Day1`
module Day1
  VERSION = "0.1.0"

  def self.read_from_input()
    depths = [] of Int64
    while (depth = gets)
      depths << Int64.new(depth)
    end
    depths
  end

  def self.part_1()
    depths = read_from_input
    looking_at = 0
    prev_value = nil

    increased = 0

    while looking_at < depths.size
      if prev_value == nil
        puts "(N/A - no previous measurement)"
      elsif prev_value && prev_value > depths[looking_at]
        puts "(decreased)"
      elsif prev_value && prev_value < depths[looking_at]
        puts "(increased)"
        increased += 1
      else
        puts "(same old)"
      end
      prev_value = depths[looking_at]
      looking_at += 1
    end

    puts increased
    increased
  end

  def self.part_2()
    depths = read_from_input
    prev_window = nil
    curr_window = nil

    looking_at = 2

    increased = 0

    while looking_at < depths.size
      curr_window = depths[looking_at - 2] + depths[looking_at - 1] + depths[looking_at]
      if prev_window == nil
        puts "(N/A - no previous sum)"
      elsif prev_window && prev_window > curr_window
        puts "(decreased)"
      elsif prev_window && prev_window < curr_window
        puts "(increased)"
        increased += 1
      else
        puts "(no change)"
      end
      prev_window = curr_window
      looking_at += 1
    end

    puts increased
    increased
  end
end

