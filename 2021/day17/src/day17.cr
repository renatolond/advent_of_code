# TODO: Write documentation for `Day17`
module Day17
  VERSION = "0.1.0"

  class ProbeLaunchSimulator
    @min_x : Int64
    @max_x : Int64
    @min_y : Int64
    @max_y : Int64
    def initialize(line)
      @min_y, @max_y, @min_x, @max_x = self.class.parse_input(line)
      @distinct_velocities = 0
      @max_y_reached = -99999999
    end

    getter distinct_velocities, max_y_reached

    def self.parse_input(line)
      _, coords = line.split(": ", 2)
      x, y = line.split(", ", 2)
      _, x = x.split("=", 2)
      _, y = y.split("=", 2)
      x1, x2 = x.split("..", 2)
      y1, y2 = y.split("..", 2)
      xs = [x1.to_i64, x2.to_i64]
      ys = [y1.to_i64, y2.to_i64]
      return ys.min, ys.max, xs.min, xs.max
    end

    def simulate
      # Well, not sure this it the way to go, buuuut let us try it
      biggest_x = [@min_x.abs, @max_x.abs].max
      biggest_y = [@min_y.abs, @max_y.abs].max * 10
      min_x = 1
      if @min_x < 0 || @max_y < 0
        min_x = -biggest_x
      end
      min_y = 1
      if @min_y < 0 || @max_y < 0
        min_y = -biggest_y
      end
      (min_x..biggest_x).each do |vel_x|
        (min_y..biggest_y).each do |vel_y|
          got_target, max_y = simulate_for(vel_x, vel_y)
          if max_y && max_y > @max_y_reached
            @max_y_reached = max_y
          end
          @distinct_velocities += 1 if got_target
        end
      end
    end

    def simulate_for(vel_x, vel_y)
      x = 0
      y = 0
      runs = 10
      max_y = -9999999
      initial_vel_x = vel_x
      initial_vel_y = vel_y
      loop do
        x += vel_x
        y += vel_y
        if y > max_y
          max_y = y
        end
        if vel_x > 0
          vel_x -= 1
        elsif vel_x < 0
          vel_x += 1
        end
        vel_y -= 1
        #puts "#{x} #{y}, #{vel_x} #{vel_y}"
        if x == 0 && x < @min_x || x > @max_x
          # puts "Missed the target on the x axis: #{@min_x} < #{x} < #{@max_x}"
          return false, nil
        end
        if y < @min_y
          # puts "Missed the target on the y axis: #{@min_y} > #{y}"
          return false, nil
        end
        if x >= @min_x && x <= @max_x && y >= @min_y && y <= @max_y
          # puts "In the target!"
          puts "#{initial_vel_x} #{initial_vel_y}"
          return true, max_y
        end
      end
      raise "Wut?"
    end

    def distinct_velocities
      @distinct_velocities
    end
  end

  def self.part_1()
    pls = if (line = gets())
      Day17::ProbeLaunchSimulator.new(line)
    else
      raise "Wrong input!"
    end
    pls.simulate
    puts pls.max_y_reached
  end

  def self.part_2()
    pls = if (line = gets())
      Day17::ProbeLaunchSimulator.new(line)
    else
      raise "Wrong input!"
    end
    pls.simulate
    puts pls.distinct_velocities
  end
end
