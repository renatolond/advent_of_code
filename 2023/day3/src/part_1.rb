# frozen_string_literal: true

require_relative "common"

map = []
number_positions = {}
while (line = $stdin.gets)
  line = line.strip
  numbers = Common.number_detector(line)
  number_positions[map.size] = numbers
  map << line.chars
end

SYMBOL_RE = /[^0-9.]/

sum = 0
number_positions.each do |line_number, positions|
  positions.each do |number|
    symbol_adjacent = false

    start = number.start - 1
    start = number.start if start.negative?
    fin = number.end + 1
    fin = number.end if fin >= map[line_number].size

    (line_number - 1..line_number + 1).each do |l|
      next if l.negative? || l >= map.size

      map[l][start..fin].each do |c|
        if c.match?(SYMBOL_RE)
          symbol_adjacent = true
          break
        end
      end
      break if symbol_adjacent
    end
    sum += number.number if symbol_adjacent
  end
end
puts sum
