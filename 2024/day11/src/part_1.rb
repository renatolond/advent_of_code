# frozen_string_literal: true

require_relative "common"

while (line = $stdin.gets)
  line.strip!
  numbers = line.split
end

pp numbers
new_numbers = nil
6.times do |i|
  new_numbers = []
  numbers.each do |number|
    if number == "0"
      new_numbers << "1"
    elsif number.size.even?
      left = number[0..((number.size / 2) - 1)]
      right = number[number.size / 2..]
      new_numbers << left.to_i.to_s
      new_numbers << right.to_i.to_s
    else
      new_numbers << (number.to_i * 2024).to_s
    end
  end
  numbers = new_numbers
  puts "Loop #{i}: #{new_numbers.size}"
  pp new_numbers.join(" ")
end
pp new_numbers.size
