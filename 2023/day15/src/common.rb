# frozen_string_literal: true

module Common
  class << self
    # @param str [String] The string to calculate the HASH for
    # @return [Integer] The HASH
    def holiday_ascii_string_helper(str)
      str = str.encode(Encoding::ASCII_8BIT)
      sum = 0
      str.each_char do |chr|
        sum += chr.ord
        sum *= 17
        sum %= 256
      end
      sum
    end
  end
end
