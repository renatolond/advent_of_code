# frozen_string_literal: true

module Common
  class Gate
    def initialize(name, type: :equal, parent1: nil, parent2: nil)
      @name = name
      @type = type
      @parent1 = parent1
      @parent2 = parent2
    end

    attr_writer :result
    attr_reader :name, :type, :parent1, :parent2

    def result
      @result ||= case @type
                  when :and
                    Common.gates[@parent1].result & Common.gates[@parent2].result
                  when :or
                    Common.gates[@parent1].result | Common.gates[@parent2].result
                  when :xor
                    Common.gates[@parent1].result ^ Common.gates[@parent2].result
      end
    end

    def reset!
      return unless @type != :equal

      @result = nil
    end

    def as_mermaid
      return unless @type != :equal

      if Common.gates[@parent1].type == :equal
        puts "N#{Common.gates[@parent1].object_id}[#{Common.gates[@parent1].name}] --> N#{object_id}[#{@type.upcase} - #{@name}]"
      else
        puts "N#{Common.gates[@parent1].object_id} --> N#{object_id}[#{@type.upcase} - #{@name}]"
      end
      if Common.gates[@parent2].type == :equal
        puts "N#{Common.gates[@parent2].object_id}[#{Common.gates[@parent2].name}] --> N#{object_id}"
      else
        puts "N#{Common.gates[@parent2].object_id} --> N#{object_id}"
      end
    end
  end
  class << self
    attr_accessor :gates

    def reset_gates!
      gates.each_value do |value|
        value.reset!
      end
    end
  end
end
