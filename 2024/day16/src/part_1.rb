# frozen_string_literal: true

require_relative "common"

maze = []
start_pos = nil
idx = 0
# @type [String]
while (line = $stdin.gets)
  line.strip!
  maze << line
  if (pos = line.index("S"))
    start_pos = Common::Point.new(idx, pos, :right)
  end
  idx = idx.succ
end

cost = Common.min_path(start_pos, maze)
pp cost
