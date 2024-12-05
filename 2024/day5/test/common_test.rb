# frozen_string_literal: true

require_relative "../src/common"

require "minitest/autorun"

describe "common test" do
  before do
    @ordering_rules = Common::OrderRules.new
    orders = %w[47|53
                97|13
                97|61
                97|47
                75|29
                61|13
                75|53
                29|13
                97|29
                53|29
                61|53
                97|53
                61|29
                47|13
                75|47
                97|75
                47|61
                75|61
                47|29
                75|13
                53|13]
    orders.each { |o| @ordering_rules.add(o) }
  end
  describe "valid_update?" do
    it "refutes invalid rules" do
      refute Common.valid_update?([75, 97, 47, 61, 53], @ordering_rules)
      refute Common.valid_update?([61, 13, 29], @ordering_rules)
      refute Common.valid_update?([97, 13, 75, 29, 47], @ordering_rules)
    end
    it "assert valid rules" do
      assert Common.valid_update?([75, 47, 61, 53, 29], @ordering_rules)
      assert Common.valid_update?([97, 61, 53, 29, 13], @ordering_rules)
      assert Common.valid_update?([75, 29, 13], @ordering_rules)
    end
  end
  describe "order_update" do
    it "order invalid rules" do
      assert_equal [97, 75, 47, 61, 53], Common.order_update([75, 97, 47, 61, 53], @ordering_rules)
      assert_equal [61, 29, 13], Common.order_update([61, 13, 29], @ordering_rules)
      assert_equal [97, 75, 47, 29, 13], Common.order_update([97, 13, 75, 29, 47], @ordering_rules)
    end
  end
end
