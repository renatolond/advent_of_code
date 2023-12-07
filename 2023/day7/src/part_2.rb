# frozen_string_literal: true

require_relative "common"

cards = []
while (line = $stdin.gets)
  cards << Common.read_line(line, joker: true)
end
cards.sort! { |a, b| Common.card_order_func(a, b) }
# pp cards
sum = 0
idx = 1
cards.reverse_each do |c|
  sum += idx * c.bid
ensure
  idx += 1
end
puts sum
