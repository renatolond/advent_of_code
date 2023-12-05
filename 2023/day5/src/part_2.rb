# frozen_string_literal: true

require_relative "common"

seed_ranges = $stdin.gets
$stdin.gets # get empty line
_, seed_ranges = seed_ranges.split(": ")
seed_ranges = seed_ranges.split.map(&:to_i)
seeds = []
seed_ranges.each_slice(2) do |slice|
  seeds << (slice[0]...(slice[0] + slice[1]))
end
# pp seeds
maps = []
drop_header = true
while (line = $stdin.gets)
  if drop_header
    drop_header = false
    next
  end

  if line.strip.empty?
    seeds = Common.convert_ranges(maps, seeds)
    # pp maps
    # pp seeds
    maps = []
    drop_header = true
  else
    maps << Common.read_map_line(line)
  end
end
seeds = Common.convert_ranges(maps, seeds)
# pp maps
# pp seeds
puts(seeds.min_by(&:begin).begin)
