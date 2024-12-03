# frozen_string_literal: true

module Common
  class << self
    INSTRUCTION_RE = /(?<instruction>mul)\((?<X>\d+),(?<Y>\d+)\)/

    def find_instructions(line)
      instructions = []
      m = INSTRUCTION_RE.match(line)
      while m
        instructions << { instruction: m[:instruction].to_sym, values: [m[:X].to_i, m[:Y].to_i]}
        line = m.post_match
        m = INSTRUCTION_RE.match(line)
      end
      instructions
    end

    INSTRUCTION_COND_RE = /(?<instruction>(?:do|don't|mul))\((?:(?<X>\d+),(?<Y>\d+))?\)/
    def find_instructions_with_conditions(line, multiplication_enabled: true)
      instructions = []
      m = INSTRUCTION_COND_RE.match(line)
      while m
        curr_instruction = { instruction: m[:instruction].to_sym, values: [m[:X].to_i, m[:Y].to_i]}
        case curr_instruction[:instruction]
        when :do
          multiplication_enabled = true
        when :"don't"
          multiplication_enabled = false
        when :mul
          if multiplication_enabled
            instructions << curr_instruction
          else
          end
        else
          raise "not implemented"
        end
        line = m.post_match
        m = INSTRUCTION_COND_RE.match(line)
      end
      return instructions, multiplication_enabled
    end

    def sum_of_instructions(instructions)
      instructions.sum do |v|
        case v[:instruction]
        when :mul
          v[:values][0] * v[:values][1]
        else
          raise "not implemented"
        end
      end
    end
  end
end
