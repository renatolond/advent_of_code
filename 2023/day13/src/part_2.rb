# frozen_string_literal: true

require_relative "common"
map = []
summary = 0
while (line = $stdin.gets)
  if line.strip.empty?
    direction, place = Common.process_map_with_smudge(map)
    if direction == :horizontal
      summary += place
    else
      summary += 100 * place
    end
    map = []
  else
    map << line.strip
  end
end
direction, place = Common.process_map_with_smudge(map)
if direction == :horizontal
  summary += place
else
  summary += 100 * place
end

puts summary
