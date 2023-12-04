# frozen_string_literal: true

Card = Data.define(:id, :winning, :having)

require "scanf"

module Common
  class << self
    # @param line [String] A line, coming from the terminal
    # @return [Card]
    def read_card(line)
      game_id, line = line.split(/\s*:\s*/, 2)
      game_id, = game_id.scanf("Card %d")
      winning, having = line.split(/\s*\|\s/)
      winning = winning.split(/\s+/).map(&:to_i).sort
      having = having.split(/\s+/).map(&:to_i).sort
      Card.new(id: game_id, having:, winning:)
    end

    # @param card [Card] A card to give points to
    # @return [Integer] how many points its worth
    def points(card)
      points = 0
      card.having.each do |having|
        if card.winning.include?(having)
          if points.positive?
            points *= 2
          else
            points = 1
          end
        end
      end
      points
    end

    def matching(card)
      matching = 0
      card.having.each do |having|
        matching += 1 if card.winning.include?(having)
      end
      matching
    end
  end
end
