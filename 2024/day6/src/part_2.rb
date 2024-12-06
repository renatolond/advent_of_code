# frozen_string_literal: true

require_relative "common"

maze = []
guard = nil
idx = 0
while (line = $stdin.gets)
  line.strip!
  guard ||= Common::Guard.find(line, idx)
  maze << line
  idx = idx.succ
end

solve_maze = maze.dup
solve_maze.map!(&:dup)
dup_guard = guard.dup
Common.maze_walk!(solve_maze, dup_guard)
possible_loops = Common.loop_detecting_maze_walk(solve_maze, guard)
# possible_loops.each { |m| pp m }
possible_loops.map! do |p|
  test_maze = maze.dup
  test_maze.map!(&:dup)
  # test_maze[p[0]][p[1]] = "O"
  # puts "===="
  # test_maze.each { |m| puts m }
  test_maze[p[0]][p[1]] = "#"
  test_guard = guard.dup
  Common.maze_walk_did_i_loop(test_maze, test_guard)
rescue
  # puts "Loop detected! #{e}"
  p
end
possible_loops.compact!

possible_loops.each do |p|
  maze[p[0]][p[1]] = "O"
end
maze.each { |m| puts m }
pp possible_loops.size
