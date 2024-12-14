# frozen_string_literal: true

require_relative "common"

sim = Common::Simulation.new
while (line = $stdin.gets)
  line.strip!
  p, v = line.split(" ", 2)
  _, p = p.split("=")
  _, v = v.split("=")
  pos_x, pos_y = p.split(",")
  vel_x, vel_y = v.split(",")

  sim.add_robot(pos_y, pos_x, vel_y, vel_x)
end

100.times do |i|
  sim.move
end
pp sim.count_quadrants
