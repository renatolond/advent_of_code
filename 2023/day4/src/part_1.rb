# frozen_string_literal: true

require_relative "common"

points = 0
while (line = $stdin.gets)
  card = Common.read_card(line)
  points += Common.points(card)
end
puts points
