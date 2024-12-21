# frozen_string_literal: true

require_relative "common"

Common.optimized_numeric_path
Common.optimized_directional_path

complexity = 0
DIRECTIONAL_DEPTH = 1 + 25 # numeric + robots + you
Common.max_depth = DIRECTIONAL_DEPTH
while (line = $stdin.gets)
  line.strip!
  size = 0
  idx = 0
  while idx < line.size
    a = if idx.zero?
      "A"
    else
      line[idx - 1]
    end
    b = line[idx]
    size += Common.recursive_convert(a, b, depth: 0)
    idx = idx.succ
  end
  pp "#{size} * #{line.to_i} = #{line.to_i * size}"
  complexity += line.to_i * size
end
pp complexity
