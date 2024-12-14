# frozen_string_literal: true

require_relative "common"

sim = Common::Simulation.new
f = File.open("full.in")
# f = File.open("test2.in")
while (line = f.gets)
  line.strip!
  p, v = line.split(" ", 2)
  _, p = p.split("=")
  _, v = v.split("=")
  pos_x, pos_y = p.split(",")
  vel_x, vel_y = v.split(",")

  sim.add_robot(pos_y, pos_x, vel_y, vel_x)
end

idx = 1
loop do
  sim.move
  possible = sim.robots(idx)
  $stdin.gets if possible
  idx += 1
end
pp sim.count_quadrants
