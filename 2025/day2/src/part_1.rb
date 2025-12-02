# frozen_string_literal: true

require_relative "common"

ranges = []
while (line = $stdin.gets)
  str_ranges = line.split(",")
  str_ranges.each do |str|
    a, b = str.split("-")
    a = Integer(a)
    b = Integer(b)
    ranges << (a..b)
  end
end
ranges.sort_by!(&:last)

max_number = ranges.map { |v| v.last if v.last.to_s.size.even? }.compact.max
max_digits = (max_number.to_s.size) / 2

i = 0
max_number = 10**max_digits - 1
curr_range = 0
total = 0
while i < max_number
  number = Integer("#{i}#{i}")
  while ranges[curr_range].last < number
    curr_range += 1
    break if curr_range >= ranges.size
  end
  break if curr_range >= ranges.size
  if ranges[curr_range].cover?(number)
    total += number
  end
  i += 1
end
pp total
