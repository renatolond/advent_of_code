# frozen_string_literal: true

require_relative "common"

times = $stdin.gets
_, times = times.split(/\s*:\s*/)
times = [times.tr(" ", "").to_i]
distances = $stdin.gets
_, distances = distances.split(/\s*:\s*/)
distances = [distances.tr(" ", "").to_i]

pp times
pp distances
total_ways = 1
idx = 0
while idx < times.size
  min, max = Common.solve_for_x(times[idx], distances[idx])
  ways = max - min + 1
  total_ways *= ways
  idx += 1
end

puts total_ways
