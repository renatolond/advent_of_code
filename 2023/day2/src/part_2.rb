# frozen_string_literal: true

require_relative "common"

sum = 0
while (line = $stdin.gets)
  game = Common.parse_game(line)
  min_set = Common.fewest_cubes(game)
  sum += Common.handful_power(min_set)
end
puts sum
