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

min_cost = Common.min_path(start_pos, maze)

best_places = Common.best_places(start_pos, maze, min_cost)
pp best_places
