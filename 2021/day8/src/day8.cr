# TODO: Write documentation for `Day8`
module Day8
  VERSION = "0.1.0"

  class SevenSegmentDisplayGuesser
    @cumulated : Array(Int64)

    def initialize
      @cumulated = Array(Int64).new(10, 0)
      @local = Array(Int64).new(10, 0)
      @numbers = Array(Array(Char)).new(10, [] of Char)
      @digits = Array(Char).new(7, 'Z')
      @output = 0
    end

    def guess_harder(input_numbers_per_length)
      @digits = Array(Char).new(7, 'Z')
      n_2_or_5 = Array(Array(Char)).new
      n_2_or_5_minus_1 = Array(Array(Char)).new
      input_numbers_per_length[5].each do |number|
        number = number.chars.sort
        possible_3 = number - @numbers[7]
        if possible_3.size == 2
          @numbers[3] = number
          next
        end

        n_2_or_5_minus_1 << number - @numbers[1]
        n_2_or_5 << number
      end
      n_0_or_6 = Array(Array(Char)).new
      input_numbers_per_length[6].each do |number|
        number = number.chars.sort
        possible_9 = number - @numbers[3]
        if possible_9.size == 1
          @numbers[9] = number
          next
        end

        n_0_or_6 << number
      end

      n_2_or_5.each do |number|
        if (@numbers[9] - number).size == 1
          @numbers[5] = number
        else
          @numbers[2] = number
        end
      end

      n_0_or_6.each do |number|
        if ((@numbers[8] - number) & @numbers[1]).size == 1
          @numbers[6] = number
        else
          @numbers[0] = number
        end
      end

      @digits[0] = (@numbers[7] - @numbers[1]).first
      d_1_or_3 = @numbers[4] - @numbers[1]
      d_0_4_or_6 = @numbers[8] - @numbers[4]
      d_0_or_6 = @numbers[3] - @numbers[4]
      d_1_or_4 = (n_2_or_5_minus_1[1] | n_2_or_5_minus_1[0]) - (n_2_or_5_minus_1[0] & n_2_or_5_minus_1[1])
      @digits[1] = (d_1_or_4 & d_1_or_3).first
      @digits[2] = (@numbers[8] - @numbers[6]).first
      @digits[3] = (d_1_or_3 - [digits[1]]).first
      d_2_or_5 = @numbers[1]
      @digits[4] = (d_1_or_4 & d_0_4_or_6).first
      @digits[5] = (d_2_or_5 - [@digits[2]]).first
      @digits[6] = (d_0_or_6 - [@digits[0]]).first
    end

    def digits
      @digits
    end

    def guess(line)
      @local = Array(Int64).new(10, 0)
      input, output = line.split(/ *\| */)
      input_numbers = input.split(/ +/)
      output_numbers = output.split(/ +/)

      input_numbers_per_length = {} of Int32 => Array(String)
      input_numbers.each do |i|
        input_numbers_per_length[i.size] ||= [] of String
        input_numbers_per_length[i.size] << i
      end

      @numbers[1] = input_numbers_per_length[2].first.chars.sort
      @numbers[4] = input_numbers_per_length[4].first.chars.sort
      @numbers[7] = input_numbers_per_length[3].first.chars.sort
      @numbers[8] = input_numbers_per_length[7].first.chars.sort

      guess_harder(input_numbers_per_length)

      output_number = [] of String
      output_numbers.each do |number|
        number = number.chars.sort
        @numbers.each_with_index do |ref_number, i|
          if number == ref_number
            @local[i] += 1
            output_number << i.to_s
            break
          end
        end
      end
      @output += output_number.join.to_i64
      10.times do |i|
        @cumulated[i] += @local[i]
      end
    end

    def output
      @output
    end

    def easy_numbers
      @cumulated[1] + @cumulated[4] + @cumulated[7] + @cumulated[8]
    end
  end

  def self.part_1()
    ssdg = SevenSegmentDisplayGuesser.new
    while (line = gets())
      ssdg.guess(line)
    end
    puts ssdg.easy_numbers
  end

  def self.part_2()
    ssdg = SevenSegmentDisplayGuesser.new
    while (line = gets())
      ssdg.guess(line)
    end
    puts ssdg.output
  end
end
