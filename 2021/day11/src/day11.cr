# TODO: Write documentation for `Day9`
module Day11
  VERSION = "0.1.0"

  class OctopusFlashDetector
    @octopuses_energy_readings : Array(Array(Int64))
    @width : Nil | Int32
    def initialize
      @lines = 0
      @flash_count = 0_i64
      @width = nil
      @octopuses_energy_readings = [] of Array(Int64)
      @full_flash = false
    end

    def read(line)
      @octopuses_energy_readings << line.split("").map(&.to_i64)
      @width = @octopuses_energy_readings[@lines].size if @width.nil?
      raise "Wrong width!" if @width != @octopuses_energy_readings[@lines].size
      @lines += 1
    end

    def step
      flashing_octopuses = [] of NamedTuple(i: Int32, j: Int32)

      @lines.times do |idx|
        @width.not_nil!.times do |jdx|
          @octopuses_energy_readings[idx][jdx] += 1
          flashing_octopuses << {i: idx, j: jdx} if @octopuses_energy_readings[idx][jdx] == 10
        end
      end
      loop do
        new_flashing_octopuses = [] of NamedTuple(i: Int32, j: Int32)
        flashing_octopuses.each do |flashing|
          @flash_count += 1
          idx = flashing[:i]
          jdx = flashing[:j]

          (-1..1).each do |ii|
            (-1..1).each do |jj|
              next if ii == 0 && jj == 0

              if idx + ii >= 0 && jdx + jj >= 0 && idx + ii < @lines && jdx + jj < @width.not_nil!
                @octopuses_energy_readings[idx+ii][jdx+jj] += 1
                new_flashing_octopuses << {i: idx+ii, j: jdx+jj} if @octopuses_energy_readings[idx+ii][jdx+jj] == 10
              end
            end
          end
        end

        break if new_flashing_octopuses.empty?
        flashing_octopuses = new_flashing_octopuses
      end
      @full_flash = true

      @lines.times do |idx|
        @width.not_nil!.times do |jdx|
          if @octopuses_energy_readings[idx][jdx] > 9
            @octopuses_energy_readings[idx][jdx] = 0
          else
            @full_flash = false
          end
        end
      end
    end

    def full_flash
      @full_flash
    end

    def octopuses_energy_readings
      @octopuses_energy_readings.map { |l| l.map(&.to_s).join }
    end

    def flash_count
      @flash_count
    end
  end

  def self.part_1()
    ofd = OctopusFlashDetector.new
    while (line = gets())
      ofd.read(line)
    end

    100.times do
      ofd.step
    end
    puts ofd.flash_count
  end

  def self.part_2()
    ofd = OctopusFlashDetector.new
    while (line = gets())
      ofd.read(line)
    end

    step = 1
    loop do
      ofd.step
      break if ofd.full_flash
      step += 1
    end
    puts step
  end
end
