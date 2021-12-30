# TODO: Write documentation for `Day22`
module Day25
  VERSION = "0.1.0"

  class SeaCucumberSimulator
    def initialize
      @sea_cucumbers = [] of Array(Char)
      @steps = 0
      @no_movement_h = false
      @no_movement_v = false
      @no_movement = false
    end
    getter steps

    def read_line(line)
      @sea_cucumbers << line.chars
    end

    def cucumber_map
      @sea_cucumbers.map { |v| v.join("") }
    end

    def step
      step_east
      step_south
      @no_movement = @no_movement_h && @no_movement_v
      @steps += 1
    end

    def step_until_no_movements
      loop do
        step
        break if @no_movement
      end
    end

    def step_east
      new_map = [] of Array(Char)
      @sea_cucumbers.size.times do |idx|
        new_map << Array(Char).new(@sea_cucumbers.first.size, '.')
        new_map[idx].size.times do |jdx|
          new_map[idx][jdx] = 'v' if @sea_cucumbers[idx][jdx] == 'v'
        end
      end
      idx = 0
      loop do
        break if idx >= @sea_cucumbers.size
        jdx = 0
        loop do
          break if jdx >= @sea_cucumbers[idx].size
          if @sea_cucumbers[idx][jdx] == '>'
            next_jdx = jdx + 1
            if next_jdx >= @sea_cucumbers[idx].size
              next_jdx = 0
            end
            if @sea_cucumbers[idx][next_jdx] == '.'
              new_map[idx][next_jdx] = '>'
            else
              new_map[idx][jdx] = '>'
            end
          end
          jdx += 1
        end
        idx += 1
      end
      @no_movement_h = new_map == @sea_cucumbers
      @sea_cucumbers = new_map
    end

    def step_south
      new_map = [] of Array(Char)
      @sea_cucumbers.size.times do |idx|
        new_map << Array(Char).new(@sea_cucumbers.first.size, '.')
        new_map[idx].size.times do |jdx|
          new_map[idx][jdx] = '>' if @sea_cucumbers[idx][jdx] == '>'
        end
      end
      jdx = 0
      loop do
        break if jdx >= @sea_cucumbers.first.size
        idx = 0
        loop do
          break if idx >= @sea_cucumbers.size
          if @sea_cucumbers[idx][jdx] == 'v'
            next_idx = idx + 1
            if next_idx >= @sea_cucumbers.size
              next_idx = 0
            end
            if @sea_cucumbers[next_idx][jdx] == '.'
              new_map[next_idx][jdx] = 'v'
            else
              new_map[idx][jdx] = 'v'
            end
          end
          idx += 1
        end
        jdx += 1
      end
      @no_movement_v = new_map == @sea_cucumbers
      @sea_cucumbers = new_map
    end
  end

  def self.part_1()
    scs = Day25::SeaCucumberSimulator.new
    while (line = gets)
      scs.read_line(line)
    end

    scs.step_until_no_movements
    puts scs.cucumber_map.join("\n")
    puts scs.steps
  end
end
