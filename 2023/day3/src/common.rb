# frozen_string_literal: true

Interval = Data.define(:start, :end, :number)

module Common
  class << self
    # @param line [String] The line, read from the terminal
    # @return [Array<Interval>] Intervals of numbers in the line
    def number_detector(line)
      intervals = []

      idx = 0
      current_start = nil
      current_end = nil
      line.each_char do |char|
        if char.between?("0", "9")
          if current_start
            current_end += 1
          else
            current_start = current_end = idx
          end
        elsif current_start
          intervals << Interval.new(start: current_start, end: current_end, number: Integer(line[current_start..current_end]))
          current_start = current_end = nil
        end
      ensure
        idx += 1
      end
      intervals << Interval.new(start: current_start, end: current_end, number: Integer(line[current_start..current_end])) if current_start

      intervals
    end
  end
end
