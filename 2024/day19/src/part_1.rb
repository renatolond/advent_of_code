# frozen_string_literal: true

require_relative "common"

line = $stdin.gets
towel_types = Hash.new { |h, k| h[k] = [] }
line.strip.split(", ").each do |towel|
  towel_types[towel[0]] << towel
end
$stdin.gets
possible_designs = 0
Common.initialize_possible_designs
while (line = $stdin.gets)
  line.strip!
  possible_designs += 1 if Common.design_possible?(line, towel_types)
end

pp possible_designs
