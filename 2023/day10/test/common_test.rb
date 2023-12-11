# frozen_string_literal: true

require_relative "../src/common"

require "minitest/autorun"

describe "common test" do
  make_my_diffs_pretty!

  describe "read line" do
    it "reads a line without a previous line" do
      expected_nodes = [nil,
                        Node.new("F"),
                        Node.new("-"),
                        Node.new("7"),
                        nil]
      expected_nodes[1].right = expected_nodes[2]
      expected_nodes[2].left = expected_nodes[1]
      expected_nodes[2].right = expected_nodes[3]
      expected_nodes[3].left = expected_nodes[2]

      line_read = Common.read_line(".F-7.\n")
      assert_equal expected_nodes, line_read
      refute_nil line_read[1].right
      refute_nil line_read[2].right
    end
    it "reads a line with a previous line" do
      previous_line = [nil,
                       Node.new("F"),
                       Node.new("-"),
                       Node.new("7"),
                       nil]
      expected_nodes = [nil, Node.new("|"), nil, Node.new("|"), nil]
      expected_nodes[1].up = previous_line[1]
      expected_nodes[3].up = previous_line[3]

      assert_equal expected_nodes, Common.read_line(".|.|.\n", north_nodes: previous_line)
      refute_nil previous_line[1].down
      refute_nil previous_line[3].down
    end
  end
end
