# frozen_string_literal: true

require_relative "common"

sum = 0
while (line = $stdin.gets)
  record = Common.read_line(line)
  v = Common.calculate_permutations(Common.expand_record(record))
  sum += v
end
puts sum
