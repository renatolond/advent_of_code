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
    start_pos = Common::Point.new(idx, pos)
  end
  idx = idx.succ
end

#DELTA = 20
DELTA = 100
Common.cheat_picoseconds = 2

_, path = Common.min_path(start_pos, maze)

cheats = Common.find_cheats(path)
pp(cheats.values.count { |v| v > DELTA })
