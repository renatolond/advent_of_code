# frozen_string_literal: true

module Common
  class StoneSimulator
    def initialize
      @stone_counter = Hash.new(0)
    end
    def initialize_stones(stones)
      stones.each do |n|
        @stone_counter[n] += 1
      end
    end

    def tick
      @new_stone_counter = Hash.new(0)
      @stone_counter.each do |k, n|
        k_s = k.to_s
        if k_s == "0"
          @new_stone_counter[1] += n
        elsif k_s.size.even?
          left = k_s[0..((k_s.size / 2) - 1)]
          right = k_s[k_s.size / 2..]
          @new_stone_counter[left.to_i] += n
          @new_stone_counter[right.to_i] += n
        else
          @new_stone_counter[k_s.to_i * 2024] += n
        end
      end
      @stone_counter = @new_stone_counter
    end

    def stones
      @stone_counter.values.sum
    end
  end

  class << self
  end
end
