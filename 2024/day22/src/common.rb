# frozen_string_literal: true

module Common
  class SecretNumber
    PRUNE_NUMBER = 16_777_216
    def initialize(seed)
      @seed = seed
      @current_number = seed
    end

    def next
      @current_number = ((@current_number * 64) ^ @current_number) % PRUNE_NUMBER
      @current_number = ((@current_number / 32) ^ @current_number) % PRUNE_NUMBER
      @current_number = ((@current_number * 2048) ^ @current_number) % PRUNE_NUMBER
    end

    def current
      @current_number
    end
  end
  class << self
    def count_bananas(monkeys)
      sequence_count = Hash.new { |h, k| h[k] = {} }
      idx = 0
      while idx < monkeys.size
        monkey_sequences = monkeys[idx]

        monkey_sequences.each do |bananas_m0, v|
          v.each do |seq|
            sequence_count[seq][idx] = bananas_m0 if sequence_count[seq][idx].nil?
          end
        end
        idx = idx.succ
      end

      max_banana_count = -Float::INFINITY
      sequence_count.each do |seq, banana_count|
        curr_count = 0
        banana_count.each_value do |v|
          curr_count += v
        end
        if curr_count > max_banana_count
          pp seq
          max_banana_count = curr_count
        end
      end

      pp max_banana_count
    end
  end
end
