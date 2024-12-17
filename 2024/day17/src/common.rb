# frozen_string_literal: true

require "logger"
module Common
  class HistorianComputer
    attr_writer :a, :b, :c
    attr_accessor :instructions, :output

    def run_instructions
      @output = []
      @instruction_pointer = 0
      # pp instructions
      # puts "A=#{@a}, B=#{@b}, C=#{@c}, #{@instruction_pointer}, #{instructions.size}"
      l = Logger.new(File::NULL)
      while @instruction_pointer < instructions.size
        instruction = instructions[@instruction_pointer]
        @instruction_pointer = @instruction_pointer.succ
        break if @instruction_pointer >= instructions.size

        case instruction
        when 0 # adv
          opr = combo_operand
          l.debug { "a = #{@a} / #{2**opr} = #{truncate_to_integer(@a / (2**opr))}" }
          @a >>= opr
          @a = truncate_to_integer(@a)
        when 1 # bxl
          opr = literal_operand
          l.debug { "b = #{@b & 7} XOR #{opr & 7} = #{(@b ^ opr) & 7}" }
          @b ^= opr
        when 2 # bst
          opr = combo_operand
          l.debug { "b = #{opr} % 8 = #{opr % 8}" }
          @b = opr & 7
        when 3 # jnz
          l.debug { "jump" }
          @instruction_pointer = literal_operand if @a != 0
        when 4 # bxc
          literal_operand # not used, intentional
          l.debug { "b = #{@b} XOR #{@c & 7} = #{(@b ^ @c) & 7}" }
          @b ^= @c
        when 5 # out
          opr = combo_operand
          l.debug { "output: #{opr % 8}" }
          output << (opr & 7)
        when 6 # bdv
          opr = combo_operand
          l.debug { "b = #{@a} / #{2**opr} = #{truncate_to_integer(@a / (2**opr))}" }
          @b = @a >> opr
          @b = truncate_to_integer(@b)
        when 7 # cdv
          opr = combo_operand
          l.debug { "c = #{@a} / #{2**opr} = #{truncate_to_integer(@a / (2**opr))}" }
          @c = @a >> opr
          @c = truncate_to_integer(@c)
        end
        l.debug { "A=#{@a.to_s(8)}, B=#{@b.to_s(8)}, C=#{@c.to_s(8)}, #{@instruction_pointer}, #{instructions.size}" }
      end
    end

    def truncate_to_integer(opr)
      opr # & (4_294_967_295)
    end

    def literal_operand
      l = instructions[@instruction_pointer]
      @instruction_pointer = @instruction_pointer.succ
      l
    end

    def combo_operand
      opr = literal_operand
      if opr >= 0 && opr <= 3
        opr
      elsif opr == 4
        @a
      elsif opr == 5
        @b
      elsif opr == 6
        @c
      elsif opr == 7
        raise "not implemented"
      end
    end
  end
  class << self
  end
end
