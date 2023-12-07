# frozen_string_literal: true

FIVE_OF_A_KIND = 1
FOUR_OF_A_KIND = 2
FULL_HOUSE = 3
THREE_OF_A_KIND = 4
TWO_PAIR = 5
ONE_PAIR = 6
HIGH_CARD = 7

CARD_MAP = {
  "A" => "0",
  "K" => "1",
  "Q" => "2",
  "J" => "3",
  "T" => "4",
  "9" => "5",
  "8" => "6",
  "7" => "7",
  "6" => "8",
  "5" => "9",
  "4" => ":",
  "3" => ";",
  "2" => "<"
}.freeze

CARD_MAP_WITH_JOKER = {
  "A" => "0",
  "K" => "1",
  "Q" => "2",
  "T" => "3",
  "9" => "4",
  "8" => "5",
  "7" => "6",
  "6" => "7",
  "5" => "8",
  "4" => "9",
  "3" => ":",
  "2" => ";",
  "J" => "<"
}.freeze

CardSet = Data.define(:cards, :bid, :type, :cards_for_comparison) do
  def initialize(cards:, bid:, type: nil, cards_for_comparison: nil)
    raise ArgumentError, "cards hand error" if cards.size != 5

    t = cards.chars.tally

    type = case t.values.sort.reverse
           when [5]
             FIVE_OF_A_KIND
           when [4, 1]
             FOUR_OF_A_KIND
           when [3, 2]
             FULL_HOUSE
           when [3, 1, 1]
             THREE_OF_A_KIND
           when [2, 2, 1]
             TWO_PAIR
           when [2, 1, 1, 1]
             ONE_PAIR
           when [1, 1, 1, 1, 1]
             HIGH_CARD
           else
             puts t
             raise "UNKNOWN SET!!"
    end
    cards_for_comparison = cards.chars.map { |c| CARD_MAP[c] }.join
    super
  end
end

CardSetWithJoker = Data.define(:cards, :bid, :type, :cards_for_comparison) do
  def initialize(cards:, bid:, type: nil, cards_for_comparison: nil)
    raise ArgumentError, "cards hand error" if cards.size != 5

    cards_for_comparison ||= cards.chars.map { |c| CARD_MAP_WITH_JOKER[c] }.join

    type ||= begin
      t = cards.chars.tally
      t = t.sort do |a, b|
        next b[1] <=> a[1] if a[1] != b[1]

        CARD_MAP_WITH_JOKER[a[0]] <=> CARD_MAP_WITH_JOKER[b[0]]
      end.to_h
      k = t.first[0]
      k = t.keys[1] if k == "J" && t.size > 1
      t[k] += t.delete("J") if t["J"] && k != "J"

      case t.values.sort.reverse
      when [5]
        FIVE_OF_A_KIND
      when [4, 1]
        FOUR_OF_A_KIND
      when [3, 2]
        FULL_HOUSE
      when [3, 1, 1]
        THREE_OF_A_KIND
      when [2, 2, 1]
        TWO_PAIR
      when [2, 1, 1, 1]
        ONE_PAIR
      when [1, 1, 1, 1, 1]
        HIGH_CARD
      else
        puts cards
        puts t
        raise "UNKNOWN SET!!"
      end
    end
    super
  end
end

module Common
  class << self
    # @param line [String] The line read from the CLI
    # @return [CardSet] A cardset
    # @param [Object] joker
    def read_line(line, joker: false)
      cards, bid = line.strip.split
      if joker
        CardSetWithJoker.new(cards, bid.to_i)
      else
        CardSet.new(cards, bid.to_i)
      end
    end

    def card_order_func(a, b)
      return a.type <=> b.type if a.type != b.type

      return a.cards_for_comparison[0] <=> b.cards_for_comparison[0] if a.cards_for_comparison[0] != b.cards_for_comparison[0]
      return a.cards_for_comparison[1] <=> b.cards_for_comparison[1] if a.cards_for_comparison[1] != b.cards_for_comparison[1]
      return a.cards_for_comparison[2] <=> b.cards_for_comparison[2] if a.cards_for_comparison[2] != b.cards_for_comparison[2]
      return a.cards_for_comparison[3] <=> b.cards_for_comparison[3] if a.cards_for_comparison[3] != b.cards_for_comparison[3]

      a.cards_for_comparison[4] <=> b.cards_for_comparison[4]
    end
  end
end
