# frozen_string_literal: true

require_relative "common"

safe_levels = 0
while (line = $stdin.gets)
  safe_levels += 1 if Common.level_safe?(line.split.map(&:to_i))
end
pp safe_levels
