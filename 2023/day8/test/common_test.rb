# frozen_string_literal: true

require_relative "../src/common"

require "minitest/autorun"

describe "common test" do
  describe "read node" do
    it "reads the first sample node" do
      assert_equal Node.new(name: "AAA", left: "BBB", right: "CCC"), Common.read_node("AAA = (BBB, CCC)\n")
    end
  end
end
