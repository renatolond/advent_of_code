# frozen_string_literal: true

require_relative "common"

BUTTON_RE = /Button (?<name>\w): X\+(?<X>\d+), Y\+(?<Y>\d+)/
buttons = {}
sum = 0
# @type [String]
while (line = $stdin.gets)
  line.strip!
  if line.start_with?("Button")
    match = BUTTON_RE.match(line)
    raise "oh no" if match.nil?

    name = match[:name]
    x = match[:X].to_i
    y = match[:Y].to_i
    buttons[name] = Common::Button.new(name, x, y)
  elsif line.start_with?("Prize")
    _, line = line.split(":", 2)
    x, y = line.split(", ")
    _, x = x.split("=")
    _, y = y.split("=")
    cost = Common.solve_for(x.to_i, y.to_i, buttons)
    next if cost.nil?

    sum += cost
  else
    buttons = {}
  end
end
pp sum
