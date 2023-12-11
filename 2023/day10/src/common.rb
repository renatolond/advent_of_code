# frozen_string_literal: true

class Node
  VERTICAL = "|"
  HORIZONTAL = "-"
  UP_TO_RIGHT = "L"
  UP_TO_LEFT = "J"
  DOWN_TO_RIGHT = "F"
  DOWN_TO_LEFT = "7"
  UNKNOWN = "S"
  TYPES = [VERTICAL, HORIZONTAL, UP_TO_RIGHT, UP_TO_LEFT, DOWN_TO_RIGHT, DOWN_TO_LEFT, UNKNOWN].freeze
  PIPES_CONNECTING_LEFT = [HORIZONTAL, UP_TO_LEFT, DOWN_TO_LEFT, UNKNOWN].freeze
  PIPES_CONNECTING_RIGHT = [HORIZONTAL, UP_TO_RIGHT, DOWN_TO_RIGHT, UNKNOWN].freeze
  PIPES_CONNECTING_UP = [VERTICAL, UP_TO_RIGHT, UP_TO_LEFT, UNKNOWN].freeze
  PIPES_CONNECTING_DOWN = [VERTICAL, DOWN_TO_RIGHT, DOWN_TO_LEFT, UNKNOWN].freeze

  def initialize(pipe_type, is_start: false)
    @left = nil
    @up = nil
    @right = nil
    @down = nil
    @pipe_type = pipe_type
    @is_start = is_start
  end

  attr_accessor :left, :up, :right, :down
  attr_reader :pipe_type, :is_start

  def correctly_connected?
    case pipe_type
    when VERTICAL
      up && down && !left && !right
    when HORIZONTAL
      !up && !down && left && right
    when UP_TO_LEFT
      up && !down && left && !right
    when UP_TO_RIGHT
      up && !down && !left && right
    when DOWN_TO_LEFT
      !up && down && left && !right
    when DOWN_TO_RIGHT
      !up && down && !left && right
    when UNKNOWN
      true
    end
  end

  def adjust_type!
    raise ArgumentError unless pipe_type == "S"

    @pipe_type = if up && down
      VERTICAL
    elsif left && right
      HORIZONTAL
    elsif up && left
      UP_TO_LEFT
    elsif up && right
      UP_TO_RIGHT
    elsif down && left
      DOWN_TO_LEFT
    elsif down && right
      DOWN_TO_RIGHT
    end
  end

  def pipe_type_for_display
    case pipe_type
    when "7"
      "╗"
    when "J"
      "╝"
    when "L"
      "╚"
    when "F"
      "╔"
    when "-"
      "═"
    when "|"
      "║"
    else
      pipe_type.to_s
    end
  end

  def inspect
    "#<#{self.class}:#{object_id} @pipe_type=#{pipe_type}, @left=#{left&.object_id}, @right=#{right&.object_id}, @up=#{up&.object_id}, @down=#{down&.object_id}>"
  end

  def to_s
    "pipe_type: #{pipe_type}; is_start?: #{is_start}; #{left ? "<" : nil} #{up ? "^" : nil} #{down ? "v" : nil} #{right ? ">" : nil}"
  end

  def ==(other)
    raise ArgumentError unless other.is_a? Node
    to_s == other.to_s &&
      pipe_type == other.pipe_type &&
      is_start == other.is_start
  end
end

module Common
  class << self
    # @param line [String] A line, read from the terminal
    # @return [Array<Node>] An array of nodes
    # @param [Object] north_nodes
    def read_line(line, north_nodes: nil)
      idx = 0
      nodes = []

      line.strip.each_char do |chr|
        if chr == "."
          nodes << nil
          next
        end

        is_start = chr == "S"
        node = Node.new(chr, is_start:)

        if [Node::VERTICAL, Node::UP_TO_LEFT, Node::UP_TO_RIGHT, Node::UNKNOWN].include?(chr)
          upper_node = north_nodes[idx] if north_nodes
          if Node::PIPES_CONNECTING_DOWN.include?(upper_node&.pipe_type)
            node.up = upper_node
            node.up.down = node
          end
        end

        if [Node::HORIZONTAL, Node::DOWN_TO_LEFT, Node::UP_TO_LEFT, Node::UNKNOWN].include?(chr)
          node_to_the_left = nodes[idx - 1] if idx.positive?
          if Node::PIPES_CONNECTING_RIGHT.include?(node_to_the_left&.pipe_type)
            node.left = node_to_the_left
            node.left.right = node
          end
        end

        nodes << node
      ensure
        idx += 1
      end

      nodes
    end

    def print_current_pos(nodes, idx, jdx)
      nodes.each_with_index do |node_line, i|
        j = 0
        while j < node_line.size
          if i == idx && j == jdx
            print "X"
          else
            print(nodes[i][j] ? nodes[i][j].pipe_type_for_display[0] : ".")
          end
          j += 1
        end
        puts ""
      end
      puts "(#{idx}, #{jdx})\\\\\\\\\\\\\\"
    end
  end
end
