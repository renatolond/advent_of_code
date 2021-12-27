# TODO: Write documentation for `Day24`
module Day24
  VERSION = "0.1.0"

  class ALU
    @x : Int64
    @y : Int64
    @w : Int64
    @z : Int64
    def initialize
      @x = @y = @w = @z = 0
      @instructions = [] of Proc(Proc(Int64) | Proc(Int64, Int64)) | Proc(Int64)
      @inputs = [] of Int64
      oh_well
    end

    getter instructions, x, y, w, z
    setter instructions, x, y, w, z

    DEBUG = false
    @conversion_table = {} of String => Proc(Int64, Int64)
    macro add_vars(var1, var2)
      def add_{{var1}}_{{var2}}(fake : Int64) : Int64
        tmp = self.{{var1}} + self.{{var2}}
        puts "{{var1}} = {{var1}} + {{var2}}: #{tmp}" if DEBUG
        self.{{var1}} = tmp
      end
    end

    macro mul_vars(var1, var2)
      def mul_{{var1}}_{{var2}}(fake : Int64) : Int64
        tmp = self.{{var1}} * self.{{var2}}
        puts "{{var1}} = {{var1}} * {{var2}}: #{tmp}" if DEBUG
        self.{{var1}} = tmp
      end
    end

    macro div_vars(var1, var2)
      def div_{{var1}}_{{var2}}(fake : Int64) : Int64
        raise "No, bad boy!" if self.{{var2}} == 0
        tmp = self.{{var1}} / self.{{var2}}
        puts "{{var1}} = {{var1}} / {{var2}}: #{tmp}" if DEBUG
        self.{{var1}} = tmp.to_i64
      end
    end

    macro mod_vars(var1, var2)
      def mod_{{var1}}_{{var2}}(fake : Int64) : Int64
        raise "No, bad boy!" if self.{{var2}} == 0
        tmp = self.{{var1}} % self.{{var2}}
        puts "{{var1}} = {{var1}} % {{var2}}: #{tmp}" if DEBUG
        self.{{var1}} = tmp.to_i64
      end
    end

    macro eql_vars(var1, var2)
      def eql_{{var1}}_{{var2}}(fake : Int64) : Int64
        tmp = if self.{{var1}} == self.{{var2}}
          1.to_i64
        else
          0.to_i64
        end
        puts "{{var1}} = {{var1}} == {{var2}}: #{tmp}" if DEBUG
        self.{{var1}} = tmp
      end
    end

    macro add_num(var1)
      def addn_{{var1}}(num) : Int64
        tmp = self.{{var1}} + num
        puts "{{var1}} = {{var1}} + #{num}: #{tmp}" if DEBUG
        self.{{var1}} = tmp
      end
    end

    macro mul_num(var1)
      def muln_{{var1}}(num) : Int64
        tmp = self.{{var1}} * num
        if num == 0
          puts "{{var1}} = 0" if DEBUG
        else
          puts "{{var1}} = {{var1}} * #{num}: #{tmp}" if DEBUG
        end
        self.{{var1}} = tmp
      end
    end

    macro div_num(var1)
      def divn_{{var1}}(num) : Int64
        raise "No, bad boy!" if num == 0
        tmp = self.{{var1}} / num
        puts "{{var1}} = {{var1}} / #{num}: #{tmp}" if DEBUG
        self.{{var1}} = tmp.to_i64
      end
    end

    macro mod_num(var1)
      def modn_{{var1}}(num) : Int64
        raise "No, bad boy!" if num == 0
        tmp = self.{{var1}} % num
        puts "{{var1}} = {{var1}} % #{num}: #{tmp}" if DEBUG
        self.{{var1}} = tmp.to_i64
      end
    end
    macro eql_num(var1)
      def eqln_{{var1}}(num) : Int64
        tmp = if self.{{var1}} == num
          1.to_i64
        else
          0.to_i64
        end
        puts "{{var1}} = {{var1}} == #{num}: #{tmp}" if DEBUG
        self.{{var1}} = tmp
      end
    end

    macro input_var(var)
      add_num({{var}})
      mul_num({{var}})
      div_num({{var}})
      mod_num({{var}})
      eql_num({{var}})
      def input_{{var}}
        puts "x=#{self.x} y=#{self.y} w=#{self.w} z=#{self.z}" if DEBUG
        tmp = @inputs.shift
        puts "{{var}} = #{tmp}" if DEBUG
        self.{{var}} = tmp
      end
    end

    macro combine_operations(var1, var2)
      add_vars({{var1}}, {{var2}})
      add_vars({{var2}}, {{var1}})
      mul_vars({{var1}}, {{var2}})
      mul_vars({{var2}}, {{var1}})
      div_vars({{var1}}, {{var2}})
      div_vars({{var2}}, {{var1}})
      mod_vars({{var1}}, {{var2}})
      mod_vars({{var2}}, {{var1}})
      eql_vars({{var1}}, {{var2}})
      eql_vars({{var2}}, {{var1}})
    end

    input_var(x)
    input_var(y)
    input_var(w)
    input_var(z)
    combine_operations(x, y)
    combine_operations(x, w)
    combine_operations(x, z)
    combine_operations(x, y)
    combine_operations(y, w)
    combine_operations(y, z)
    combine_operations(w, z)

    macro finished
      def oh_well
      {% for name in @type.methods.map &.name %}
        {% if name.includes?("add_") || name.includes?("mul_") || name.includes?("mod_") || name.includes?("div_") || name.includes?("eql_") %}
          @conversion_table["{{name}}"] = ->{{name}}(Int64)
        {% elsif name.includes?("addn_") || name.includes?("muln_") || name.includes?("modn_") || name.includes?("divn_") || name.includes?("eqln_") %}
          @conversion_table["{{name}}"] = ->{{name}}(Int64)
        {% end %}
      {% end %}
      end
    end

    def load_instruction(line)
      split_results = line.split(" ", 3)

      if split_results.size == 3
        instruction, op1, op2 = split_results
        if @conversion_table.has_key?("#{instruction}_#{op1}_#{op2}")
          func = @conversion_table["#{instruction}_#{op1}_#{op2}"]
          if func.is_a? Proc(Int64, Int64)
            execute = -> { func.call(-999_i64) }
          else
            raise "oh no"
          end
        else
          func = @conversion_table["#{instruction}n_#{op1}"]
          raise "wrong func" if func.is_a? Proc(Int64)
          execute = -> { func.call(op2.to_i64) }
        end

        @instructions << execute
      else
        instruction, op1 = split_results
        case op1
        when "x"
          execute = ->{ input_x }
        when "y"
          execute = ->{ input_y }
        when "w"
          execute = ->{ input_w }
        when "z"
          execute = ->{ input_z }
        else
          raise "oh no"
        end
        @instructions << execute
        return
      end
    end

    def execute(inputs)
      @inputs = inputs
      @instructions.each do |instruction|
        instruction.call
      end
    end

    def reset
      @x = @y = @w = @z = 0
    end
  end

  def self.part_1()
  end

  def self.part_2()
  end
end
