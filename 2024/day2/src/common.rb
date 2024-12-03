# frozen_string_literal: true

module Common
  class << self
    # @param level [Array<Integer>]
    # @return [Boolean]
    def level_safe?(level)
      direction = nil
      level.each_cons(2) do |a, b|
        if direction.nil?
          if a < b
            direction = :increasing
          elsif b < a
            direction = :decreasing
          else
            return false
          end
        end

        return false if direction == :increasing && a >= b
        return false if direction == :decreasing && b >= a

        diff = (a - b).abs
        return false if diff < 1 || diff > 3

        true
      end
    end

    def problem_dampened_level_safe?(level)
      return true if level_safe?(level)

      idx = 0
      while idx < level.size
        new_level = level.dup
        new_level.delete_at(idx)
        idx += 1
        return true if level_safe?(new_level)
      end
      false
    end
  end
end
