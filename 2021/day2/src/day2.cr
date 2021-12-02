# TODO: Write documentation for `Day2`
module Day2
  VERSION = "0.1.0"

  class Submarine
    def initialize
      @depth = 0
      @position = 0
    end

    def move(instruction)
      direction, qty = instruction.split(" ", 2)
      qty = Int64.new(qty)
      case direction
      when "up"
        @depth -= qty
      when "down"
        @depth += qty
      when "forward"
        @position += qty
      else
        raise "Oh no!"
      end
    end

    def multiply_pos()
      @depth * @position
    end
  end

  class SubmarineV2
    def initialize
      @depth = 0
      @position = 0
      @aim = 0
    end

    def move(instruction)
      direction, qty = instruction.split(" ", 2)
      qty = Int64.new(qty)
      case direction
      when "up"
        @aim -= qty
      when "down"
        @aim += qty
      when "forward"
        @position += qty
        @depth += @aim * qty
      else
        raise "Oh no!"
      end
    end

    def multiply_pos()
      @depth * @position
    end
  end

  def self.read_from_input()
    depths = [] of Int64
    while (depth = gets)
      depths << Int64.new(depth)
    end
    depths
  end

  def self.part_1()
    submarine = Submarine.new

    while (instruction = gets)
      submarine.move(instruction)
    end

    puts submarine.multiply_pos()
    submarine.multiply_pos()
  end

  def self.part_2()
    submarine = SubmarineV2.new

    while (instruction = gets)
      submarine.move(instruction)
    end

    puts submarine.multiply_pos()
    submarine.multiply_pos()
  end
end

