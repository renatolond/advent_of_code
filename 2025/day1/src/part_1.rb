# frozen_string_literal: true

require_relative "common"

dial = 50
times_at_zero = 0
while (line = $stdin.gets)
  direction = line[0].to_sym
  clicks = Integer(line[1..])
  if direction == :L
    dial -= clicks
    while (dial < 0)
      dial += 100
    end
  elsif direction == :R
    dial += clicks
    while (dial >= 100)
      dial -= 100
    end
  end
  times_at_zero += 1 if dial.zero?
end
puts times_at_zero
