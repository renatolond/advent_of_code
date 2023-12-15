# frozen_string_literal: true

require_relative "common"

line = $stdin.gets
puts line
sum = 0
line.strip.split(",").each do |str|
  sum += Common.holiday_ascii_string_helper(str)
end
puts sum
