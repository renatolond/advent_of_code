# frozen_string_literal: true

require_relative "common"

seeds = $stdin.gets
$stdin.gets # get empty line
_, seeds = seeds.split(": ")
seeds = seeds.split.map(&:to_i)

maps = []
drop_header = true
while (line = $stdin.gets)
  if drop_header
    drop_header = false
    next
  end

  if line.strip.empty?
    seeds = Common.convert(maps, seeds)
    pp maps
    pp seeds
    maps = []
    drop_header = true
  else
    maps << Common.read_map_line(line)
  end
end
seeds = Common.convert(maps, seeds)
pp maps
pp seeds
puts seeds.min
