# frozen_string_literal: true

require_relative "common"
sum = 0
while (line = $stdin.gets)
  instructions = Common.find_instructions(line)
  sum += Common.sum_of_instructions(instructions)
end
pp sum
