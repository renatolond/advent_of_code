# frozen_string_literal: true

require_relative "common"

sum = 0
while (line = $stdin.gets)
  sum += Common.calibration_value(line)
end
puts sum
