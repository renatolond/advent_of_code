# frozen_string_literal: true

require_relative "common"

total_sum = 0
while (line = $stdin.gets)
  line.strip!
  result, numbers = line.split(":")
  result = result.to_i
  numbers = numbers.split
  numbers.map!(&:to_i)

  accum = [numbers.first]
  numbers[1..].each do |n|
    new_accum = []
    accum.each do |x|
      sum = (x + n)
      mul = (x * n)
      concat = "#{x}#{n}".to_i
      new_accum << sum if sum <= result
      new_accum << mul if mul <= result
      new_accum << concat if concat <= result
    end
    accum = new_accum
  end

  total_sum += result if accum.include?(result)
end
pp total_sum
