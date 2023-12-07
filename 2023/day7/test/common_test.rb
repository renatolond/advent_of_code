# frozen_string_literal: true

require_relative "../src/common"

require "minitest/autorun"

describe "common test" do
  describe "card type definition" do
    it "gets defined as five of a kind" do
      c = CardSet.new(cards: "AAAAA", bid: 1)

      assert_equal FIVE_OF_A_KIND, c.type
    end
    it "gets defined as four of a kind" do
      c = CardSet.new(cards: "AA8AA", bid: 1)

      assert_equal FOUR_OF_A_KIND, c.type
    end
    it "gets defined as full house" do
      c = CardSet.new(cards: "23332", bid: 1)

      assert_equal FULL_HOUSE, c.type
    end
    it "gets defined as three of a kind" do
      c = CardSet.new(cards: "TTT98", bid: 1)

      assert_equal THREE_OF_A_KIND, c.type
    end
    it "gets defined as two pair" do
      c = CardSet.new(cards: "23432", bid: 1)

      assert_equal TWO_PAIR, c.type
    end
    it "gets defined as one pair" do
      c = CardSet.new(cards: "A23A4", bid: 1)

      assert_equal ONE_PAIR, c.type
    end
    it "gets defined as high card" do
      c = CardSet.new(cards: "23456", bid: 1)

      assert_equal HIGH_CARD, c.type
    end
  end
  describe "read line" do
    it "reads the right card set" do
      assert_equal CardSet.new("T55J5", 684, THREE_OF_A_KIND), Common.read_line("T55J5 684")
    end
    it "reads the right card set with joker" do
      assert_equal CardSetWithJoker.new("T55J5", 684, FOUR_OF_A_KIND), Common.read_line("T55J5 684", joker: true)
    end
  end
  describe "order func" do
    it "order with type" do
      assert_equal(-1, Common.card_order_func(CardSet.new(cards: "AA8AA", bid: 1), CardSet.new(cards: "23332", bid: 1)))
    end
    it "order with card 0" do
      assert_equal(-1, Common.card_order_func(CardSet.new(cards: "AA8AA", bid: 1), CardSet.new(cards: "8AAAA", bid: 1)))
    end
    it "order with card 1" do
      assert_equal(-1, Common.card_order_func(CardSet.new(cards: "AA8AA", bid: 1), CardSet.new(cards: "A8AAA", bid: 1)))
    end
    it "order with card 2" do
      assert_equal(-1, Common.card_order_func(CardSet.new(cards: "AAA8A", bid: 1), CardSet.new(cards: "AA8AA", bid: 1)))
    end
    it "order with card 3" do
      assert_equal(-1, Common.card_order_func(CardSet.new(cards: "AAAA8", bid: 1), CardSet.new(cards: "AAA8A", bid: 1)))
    end
  end
end
