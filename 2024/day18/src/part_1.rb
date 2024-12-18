# frozen_string_literal: true

require_relative "common"

MAZE_SIZE = 71
# MAZE_SIZE = 7
FALLEN_BYTES = 1024
# FALLEN_BYTES = 12

falling_bytes = []
while (line = $stdin.gets)
  line.strip!
  x, y = line.split(",")
  falling_bytes << Common::Point.new(y.to_i, x.to_i)
end

maze = Array.new(MAZE_SIZE) { "." * MAZE_SIZE }

Common.bytes_have_fallen!(FALLEN_BYTES, falling_bytes, maze)

# maze.each { |m| puts m }

pp Common.min_path(Common::Point.new(0, 0), maze)
