# frozen_string_literal: true

require_relative "common"

locks = []
keys = []
next_schematic = []
while (line = $stdin.gets)
  line.strip!
  if line.empty?
    heights = Common.convert_schematic(next_schematic)
    if next_schematic[0]["."] # key
      keys << heights
    else
      locks << heights
    end
    next_schematic = []
  else
    next_schematic << line
  end
end
unless next_schematic.empty?
  heights = Common.convert_schematic(next_schematic)
  if next_schematic[0]["."] # key
    keys << heights
  else
    locks << heights
  end
end

fits = 0

idx = 0
while idx < locks.size
  idy = 0
  while idy < keys.size
    fit = true
    locks[idx].size.times do |i|
      if keys[idy][i] + locks[idx][i] >= 6
        fit = false
        break
      end
    end
    if fit
      fits = fits.succ
    end
    idy = idy.succ
  end
  idx = idx.succ
end

pp fits
