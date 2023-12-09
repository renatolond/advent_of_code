# frozen_string_literal: true

Node = Data.define(:name, :left, :right)

module Common
  class << self
    # @param line [String] A line read from the terminal
    def read_node(line)
      name, directions = line.strip.split(/\s*=\s*/)
      left, right = directions[1..-2].split(/\s*,\s*/)
      Node.new(name:, left:, right:)
    end
  end
end
