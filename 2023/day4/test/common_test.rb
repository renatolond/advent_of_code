# frozen_string_literal: true

require_relative "../src/common"

require "minitest/autorun"

describe "common test" do
  describe "scratchcard reader" do
    it "reads from a card" do
      expected_card = Card.new(id: 1, winning: [17, 41, 48, 83, 86], having: [6, 9, 17, 31, 48, 53, 83, 86])

      assert_equal expected_card, Common.read_card("Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53")
    end
    it "reads from another card" do
      expected_card = Card.new(id: 6, winning: [13, 18, 31, 56, 72], having: [10, 11, 23, 35, 36, 67, 74, 77])

      assert_equal expected_card, Common.read_card("Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11")
    end
  end

  describe "scratchcard points" do
    it "calculates the points for card 1" do
      assert_equal 8, Common.points(Card.new(id: 1, winning: [17, 41, 48, 83, 86], having: [6, 9, 17, 31, 48, 53, 83, 86]))
    end

    it "calculates the points for card 6" do
      assert_equal 0, Common.points(Card.new(id: 6, winning: [13, 18, 31, 56, 72], having: [10, 11, 23, 35, 36, 67, 74, 77]))
    end
  end

  describe "matching" do
    it "calculates the points for card 1" do
      assert_equal 4, Common.matching(Card.new(id: 1, winning: [17, 41, 48, 83, 86], having: [6, 9, 17, 31, 48, 53, 83, 86]))
    end
  end
end
