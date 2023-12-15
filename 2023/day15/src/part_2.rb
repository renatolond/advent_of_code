# frozen_string_literal: true

require_relative "common"

line = $stdin.gets
boxes = Array.new(256) { {} }
line.strip.split(",").each do |str|
  if str["="]
    label, lens = str.split("=", 2)
    box = Common.holiday_ascii_string_helper(label)
    boxes[box][label] = lens
  elsif str["-"]
    label, = str.split("-")
    box = Common.holiday_ascii_string_helper(label)
    boxes[box].delete(label)
  end
end

idx = 1
focusing_power = 0
boxes.each do |box|
  jdx = 1
  box.each do |_k, v|
    focusing_power += idx * jdx * v.to_i
  ensure
    jdx += 1
  end
ensure
  idx += 1
end
puts focusing_power
