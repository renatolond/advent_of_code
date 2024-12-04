# frozen_string_literal: true

require_relative "common"

xmas_finder = Common::XmasFinder.new
while (line = $stdin.gets)
  xmas_finder.add_line(line)
end

puts xmas_finder.find_xmas
