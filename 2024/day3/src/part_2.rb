# frozen_string_literal: true

require_relative "common"
sum = 0
multiplication_enabled = true
while (line = $stdin.gets)
  instructions, multiplication_enabled = Common.find_instructions_with_conditions(line, multiplication_enabled:)
  sum += Common.sum_of_instructions(instructions)
end
pp sum
