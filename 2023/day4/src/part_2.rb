# frozen_string_literal: true

require_relative "common"

cards = []
idx = 0
while (line = $stdin.gets)
  card = Common.read_card(line)
  cards[idx] ||= 0
  cards[idx] += 1
  matches = Common.matching(card)
  matches.times do |pos|
    new_card_idx = idx + pos + 1
    cards[new_card_idx] ||= 0
    cards[new_card_idx] += cards[idx]
  end

  idx += 1
end
puts cards.sum
