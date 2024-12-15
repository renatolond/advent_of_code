# frozen_string_literal: true

require_relative "common"

warehouse = []
robot = nil
idy = 0
# f = File.open("full.in")
f = $stdin
while (line = f.gets)
  line.strip!
  if line.empty?
    # Warehouse over
    break
  end

  new_line = ""
  line.chars do |c|
    case c
    when "#"
      new_line += "##"
    when "."
      new_line += ".."
    when "O"
      new_line += "[]"
    when "@"
      new_line += "@."
    end
  end
  line = new_line

  robot_x = line.index("@")
  if robot_x
    robot = Common::Robot.new(idy, robot_x)
    line[robot_x] = "."
  end
  warehouse << line
  idy = idy.succ
end

instructions = ""
while (line = f.gets)
  line.strip!
  instructions += line
end

# require "tty-cursor"
# cursor = TTY::Cursor
# print cursor.clear_screen
robot.consume_instructions(instructions, warehouse)
gps = 0
idx = 0
while idx < warehouse.size
  idy = 0
  while idy < warehouse[idx].size
    gps += (100 * idx) + idy if warehouse[idx][idy] == "["
    idy = idy.succ
  end
  idx = idx.succ
end
pp gps
