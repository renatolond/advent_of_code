# frozen_string_literal: true

module Common
  class << self
    # @param els [Array<Integer>] An array to find the derived elements for
    # @return [Array<Integer>] An array with the derived elements, one element smaller than the input
    def derive(els)
      derived = Array.new(els.size - 1)
      idx = 0
      els.each_cons(2).each do |a, b|
        derived[idx] = b - a
      ensure
        idx += 1
      end
      derived
    end

    # @param sequences [Array<Array<Integer>>] An array containing all sequences up to the sequence of all zeroes, in order
    # @return [Integer] The next value of the top sequence
    def predict(sequences)
      next_value = 0
      current_increase = 0
      sequences.reverse_each do |seq|
        current_increase = seq.last
        next_value += current_increase
      end

      next_value
    end

    # @param sequences [Array<Array<Integer>>] An array containing all sequences up to the sequence of all zeroes, in order
    # @return [Integer] The previous value of the top sequence
    def rpredict(sequences)
      prev_value = 0
      current_increase = 0
      sequences.reverse_each do |seq|
        current_increase = seq.first
        prev_value = current_increase - prev_value
      end

      prev_value
    end
  end
end
