# frozen_string_literal: true

require_relative "common"

trail = []
trailends = []
idy = 0
while (line = $stdin.gets)
  line.strip!
  line = line.chars
  line.map!(&:to_i)
  trail << line
  trailends += Common.find_trailends(line, idy)
  idy = idy.succ
end

_score_map, ratings_map = Common.traverse_peaks(trailends, trail)

sum = 0
idy = 0
while idy < trail.size
  idx = 0
  while idx < trail[idy].size
    sum += ratings_map[idy][idx] if trail[idy][idx].zero?
    idx = idx.succ
  end
  idy = idy.succ
end
pp sum
