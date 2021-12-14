# TODO: Write documentation for `Day9`
module Day14
  VERSION = "0.1.0"

  class PolymerCreator
    @polymer : String = "Z"
    @rules = {} of String => NamedTuple(i: Int32, o: String)
    @preprocessed_rules : Array(Array(Int32)) = [] of Array(Int32)
    @step = 0
    @polymer_parts = [] of Int64
    # @full_rules = {} of String => String
    getter polymer
    getter polymer_parts
    setter polymer

    def add_rule(rule)
      rule_idx = @rules.size
      input, output = rule.split(" -> ")
      @rules[input] = {i: rule_idx, o: output}
      # @full_rules[input] = "#{input[0]}#{output}#{input[1]}"
    end

    def preprocess_rules
      @preprocessed_rules = Array(Array(Int32)).new(@rules.size, [] of Int32)
      @rules.each do |k, v|
        resulting_pairs = ["#{k[0]}#{v[:o]}", "#{v[:o]}#{k[1]}"].map { |v| @rules[v][:i] }
        @preprocessed_rules[v[:i]] = resulting_pairs
        @polymer_parts << 0_i64
      end
    end

    def preprocess(polymer)
      new_polymer = [] of Int32
      idx = 0
      if polymer.is_a?(String)
        while idx < polymer.size - 1
          substr = polymer[idx..idx+1]
          new_polymer << @rules[substr][:i]
          idx += 1
        end
      end
      polymer = new_polymer
    end

    def prestep
      preprocess_rules
      polymer_parts = preprocess(@polymer)
      polymer_parts.each do |p|
        @polymer_parts[p] += 1
      end
      @last_pair = @polymer[-2..-1]
    end

    def step
      if @step == 0
        prestep
      end
      polymer_increase = Array(Int64).new(@polymer_parts.size, 0)
      @polymer_parts.size.times do |p|
        @preprocessed_rules[p].each do |r|
          polymer_increase[r] += @polymer_parts[p]
        end
      end
      @polymer_parts = polymer_increase
      if @last_pair
        @last_pair = "#{@rules[@last_pair][:o]}#{@last_pair.not_nil!.chars.last}"
      end
      @step += 1
    end

    # v1. works for step 1
    # def step
    #   puts @rules.to_a.sort_by { |v| v.first }
    #   return
    #   idx = 0
    #   while idx < @polymer.size - 1
    #     pair = @polymer[idx..idx+1]
    #     @polymer = @polymer.insert(idx+1, @rules[pair])
    #     idx += 2 # 1 for the step, 1 for the newly inserted char
    #   end
    # end

    # v2. Failed attempt at reducing processing time, still too big on memory
    # def polymer_processing(str)
    #   return @full_rules[str] if @full_rules.has_key?(str)
    #   if str.size == 3
    #     @full_rules[str] = polymer_processing(str[0..1]) + @rules[str[1..2]] + str[2]
    #     return @full_rules[str]
    #   end
    #   raise "#{str}" if str.size < 2
    #   size = (str.size / 2).to_i64
    #   res = polymer_processing(str[0..size-1]) + @rules[str[size-1..size]] + polymer_processing(str[size..-1])
    #   @full_rules[str] = res if res.size < 1024
    #   res
    # end

    # def step
    #   @polymer = polymer_processing(@polymer)
    # end

    def elements_tally
      tally = {} of Char => Int64
      @rules.each do |k, v|
        k.chars.first(1).each do |chr|
          tally[chr] ||= 0_i64
          tally[chr] += @polymer_parts[v[:i]]
        end
      end
      if @last_pair
        tally[@last_pair.not_nil!.chars.last] ||= 0_i64
        tally[@last_pair.not_nil!.chars.last] += 1
      end
      tally
    end

    def first_answer
      tally = elements_tally
      tally = tally.to_a.sort_by { |v| v[1] }
      tally.last.last - tally.first.last
    end
  end

  def self.part_1()
    pc = Day14::PolymerCreator.new
    line = gets
    pc.polymer = line if line
    gets # empty line between polymer and rules

    while (line = gets)
      pc.add_rule line
    end

    10.times do
      pc.step
    end
    puts pc.first_answer
  end

  def self.part_2()
    pc = Day14::PolymerCreator.new
    line = gets
    pc.polymer = line if line
    gets # empty line between polymer and rules

    while (line = gets)
      pc.add_rule line
    end

    40.times do
      pc.step
    end
    puts pc.first_answer
  end
end
