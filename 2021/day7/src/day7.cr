# TODO: Write documentation for `Day7`
module Day7
  VERSION = "0.1.0"

  class CrabPosition
    @crab_positions = [] of Int64

    def initial_state(line)
      @crab_positions = line.split(",").map { |v| v.to_i64 }.sort
      puts @crab_positions
    end

    def alignment_pos
      return 0 if @crab_positions.size == 0

      idx = (@crab_positions.size / 2).to_i64
      @crab_positions[idx]
    end

    def fuel_for_alignment
      fuel = 0
      @crab_positions.each do |pos|
        fuel += (pos - alignment_pos).abs
      end
      fuel
    end

    def fuel_for_alignment_v2(alignment_pos)
      fuel = 0
      @crab_positions.each do |pos|
        distance = (pos - alignment_pos).abs
        (1..distance).each do |count|
          fuel += count
        end
      end
      fuel
    end

    def min_fuel
      min_fuel = nil
      pos = nil

      (@crab_positions.first..@crab_positions.last).each do |curr_pos|
        fuel = fuel_for_alignment_v2(curr_pos)
        if min_fuel.nil? || min_fuel > fuel
          min_fuel = fuel
          pos = curr_pos
        end
      end

      raise "oh no" if min_fuel.nil?
      return pos, min_fuel
    end
  end

  def self.part_1()
    cp = CrabPosition.new
    while (line = gets())
      cp.initial_state(line)
    end
    puts cp.alignment_pos
    puts cp.fuel_for_alignment
  end

  def self.part_2()
    cp = CrabPosition.new
    while (line = gets())
      cp.initial_state(line)
    end

    pos, fuel = cp.min_fuel
    puts pos
    puts fuel
  end
end
