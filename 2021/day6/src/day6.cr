# TODO: Write documentation for `Day6`
module Day6
  VERSION = "0.1.0"
  class LanternFishSimulation
    @fishes = Array(Int64).new(9, 0)

    def initial_state(line)
      line.split(",").each do |f|
        @fishes[f.to_i64] += 1
      end
    end

    def fishes
      @fishes
    end

    def fish_count
      @fishes.sum
    end

    def simulate
      old_fishes = @fishes.shift
      @fishes << old_fishes
      @fishes[6] += old_fishes
    end
  end

  def self.part_1()
    lfs = LanternFishSimulation.new
    while (line = gets())
      lfs.initial_state(line)
    end
    80.times do
      lfs.simulate
    end
    puts lfs.fish_count
  end

  def self.part_2()
    lfs = LanternFishSimulation.new
    while (line = gets())
      lfs.initial_state(line)
    end
    256.times do
      lfs.simulate
    end
    puts lfs.fish_count
  end
end
