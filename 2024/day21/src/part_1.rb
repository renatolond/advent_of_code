# frozen_string_literal: true

require_relative "common"

Common.optimized_numeric_path
Common.optimized_directional_path


complexity = 0
while (line = $stdin.gets)
  line.strip!
  # pp line
  first_robot = Common.convert_from_numeric(line)
  pp first_robot
  second_robot = Common.convert_from_directional(first_robot)
  pp second_robot
  final = Common.convert_from_directional(second_robot)
  pp final
  final = final.min_by(&:length)
  pp "#{final.size} * #{line.to_i}"
  complexity += line.to_i * final.size
end
pp complexity
