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

ratios = 0
idx = 0
map.each do |map_line|
  pos = 0
  map_line.each do |c|
    next unless c == "*"

    touching = []

    (idx - 1..idx + 1).each do |l|
      next if l.negative? || l >= map.size

      number_positions[l].each do |number|
        start = number.start - 1
        start = number.start if start.negative?
        fin = number.end + 1
        fin = number.end if fin >= map[idx].size
        next unless pos.between?(start, fin)

        touching << number.number
      end
    end
    next if touching.size != 2

    ratios += touching[0] * touching[1]
  ensure
    pos += 1
  end
ensure
  idx += 1
end

puts ratios
