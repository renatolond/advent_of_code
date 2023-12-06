# frozen_string_literal: true

module Common
  class << self
    # @param time [Integer] The time to race
    # @param distance [Integer] The distance to race
    # @return [List(Integer,Integer)] Two values: the min value for winning and the max value for winning
    def solve_for_x(time, distance)
      # -x^2 + time * x - distance = 0
      delta = (time * time) - (4 * distance)
      pos1 = (- time + Math.sqrt(delta)) / -2
      pos2 = (- time - Math.sqrt(delta)) / -2
      values = [pos1, pos2]
      min_value = values.min
      max_value = values.max

      min_value = if (min_value - min_value.ceil).abs < Float::EPSILON
        min_value.ceil + 1
      else
        min_value.ceil
      end

      max_value = if (max_value - max_value.floor).abs < Float::EPSILON
        max_value.floor - 1
      else
        max_value.floor
      end

      return min_value, max_value
    end
  end
end
