# frozen_string_literal: true

require_relative "common"

sum = 0
while (line = $stdin.gets)
  new_line = Common.preprocessor(line)
  sum += Common.calibration_value(new_line)
end
puts sum
