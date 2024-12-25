# frozen_string_literal: true

module Common
  class << self
    def convert_schematic(schematic)
      heights = []
      idx = 0
      while idx < schematic[0].size
        heights << (schematic.sum { |v| v[idx] == "#" ? 1 : 0 } - 1)
        idx = idx.succ
      end

      heights
    end
  end
end
