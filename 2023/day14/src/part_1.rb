# frozen_string_literal: true

require_relative "common"

map = []
while (line = $stdin.gets)
  map << line.strip
end
puts map

result = nil
loop do
  result, changed = Common.tick(map)
  break unless changed
  puts "======="
  puts result
  sleep 1
end

puts "======="
puts result
