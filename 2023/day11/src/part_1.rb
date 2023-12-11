# frozen_string_literal: true

require_relative "common"

universe = Common.read_input($stdin)
expansion_paths = Common.find_expansion_paths(universe)
pp expansion_paths
galaxies = Common.find_galaxies(universe)

sum = 0
galaxies.combination(2).each do |g1, g2|
  sum += Common.manhattan_distance(g1, g2, expansion_paths:)
end

puts sum
