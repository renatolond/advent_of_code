# frozen_string_literal: true

require_relative "common"

sum = 0
while (line = $stdin.gets)
  game = Common.parse_game(line)
  sum += game.id if Common.valid_game?(game)
end
puts sum
