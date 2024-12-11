# frozen_string_literal: true

require_relative "common"

TURNS_LEFT = 75

stone_sim = Common::StoneSimulator.new

while (line = $stdin.gets)
  line.strip!
  numbers = line.split
  stone_sim.initialize_stones(numbers)
end

TURNS_LEFT.times do
  stone_sim.tick
end

pp stone_sim.stones
