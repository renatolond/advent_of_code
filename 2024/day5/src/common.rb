# frozen_string_literal: true

module Common
  class OrderRules
    def initialize
      @rules = Hash.new { |h, k| h[k] = Hash.new(false) }
    end

    # @param rule [String] A rule in the format "a|b"
    # @return [void]
    def add(rule)
      a, b = rule.split("|")
      a = a.to_i
      b = b.to_i
      rules[a][b] = true
    end
    attr_reader :rules
  end
  class << self
    # @param order_rules [OrderRules]
    # @param update [Array<Integer>]
    # @return [Boolean]
    def valid_update?(update, order_rules)
      idx = 0
      jdx = idx + 1
      while idx < update.size
        while jdx < update.size
          if idx == jdx
            jdx += 1
            next
          end

          return false if order_rules.rules[update[jdx]][update[idx]]

          jdx += 1
        end
        idx += 1
        jdx = idx + 1
      end

      true
    end

    def order_update(update, order_rules)
      update.sort do |a, b|
        if order_rules.rules[b][a]
          1
        elsif order_rules.rules[a][b]
          -1
        else
          0
        end
      end
    end
  end
end
