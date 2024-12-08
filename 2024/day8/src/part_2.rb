# frozen_string_literal: true

require_relative "common"

antenas = Hash.new { |h, k| h[k] = [] }
map = []
idx = 0
while (line = $stdin.gets)
  line.strip!
  map << line
  jdx = 0
  while jdx < line.size
    antenas[line[jdx]] << Common::Point.new(idx, jdx) if line[jdx] != "."
    jdx = jdx.succ
  end
  puts line
  idx = idx.succ
end

antinodes = Common.calculate_resonant_antinodes(antenas, map.size, map.first.size)
pp antinodes.size
