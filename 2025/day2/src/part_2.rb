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

i = 1
max_number = 10**max_digits - 1
total = 0
viewed = Set.new
while i < max_number
  number = Integer("#{i}#{i}")
  loop do
      is_smaller = false
      ranges.each do |range|
        is_smaller |= (number < range.last)
        if range.cover?(number) && !viewed.include?(number)
          total += number
          viewed << number
        end
      end
      break if !is_smaller
    number = Integer("#{i}#{number}")
  end
  i += 1
end
pp total
