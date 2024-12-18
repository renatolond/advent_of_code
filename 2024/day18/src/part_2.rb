# frozen_string_literal: true

require_relative "common"

MAZE_SIZE = 71
# MAZE_SIZE = 7

falling_bytes = []
while (line = $stdin.gets)
  line.strip!
  x, y = line.split(",")
  falling_bytes << Common::Point.new(y.to_i, x.to_i)
end

r = 0...falling_bytes.size
i = r.bsearch do |fallen_bytes|
  maze = Array.new(MAZE_SIZE) { "." * MAZE_SIZE }

  Common.bytes_have_fallen!(fallen_bytes, falling_bytes, maze)

  cost = Common.min_path(Common::Point.new(0, 0), maze)
  cost == Float::INFINITY
end
puts "#{falling_bytes[i - 1].x},#{falling_bytes[i - 1].y}"
