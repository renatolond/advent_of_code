# frozen_string_literal: true

require_relative "common"

maze = []
guard = nil
idx = 0
while (line = $stdin.gets)
  line.strip!
  guard ||= Common::Guard.find(line, idx)
  maze << line
  idx += 1
end

Common.maze_walk!(maze, guard)
n = maze.sum do |m|
  m.count("X")
end
pp n
