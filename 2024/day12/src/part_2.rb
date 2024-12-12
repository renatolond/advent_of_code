# frozen_string_literal: true

require_relative "common"

garden = Common::Garden.new

while (line = $stdin.gets)
  line.strip!
  garden.add_line(line)
end

pp garden.fence_cost_bulk
