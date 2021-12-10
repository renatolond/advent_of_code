# TODO: Write documentation for `Day9`
module Day10
  VERSION = "0.1.0"

  class SyntaxChecker
    @incomplete_lines = [] of String
    @invalid_lines = [] of String
    @incomplete_missing = [] of String
    @illegal_chars = [] of Char
    @illegal_score : Int64 | Nil
    @incomplete_points : Array(Int64) | Nil

    CLOSING_CHARS = [']', '}', ')', '>']
    MATCHING_CHARS = {
      '[' => ']',
      ']' => '[',
      '{' => '}',
      '}' => '{',
      '(' => ')',
      ')' => '(',
      '<' => '>',
      '>' => '<'
    }

    def matching_char(closing, opening)
      MATCHING_CHARS[closing] == opening
    end

    def check(line)
      char_stack = [] of Char
      line.chars.each do |char|
        if CLOSING_CHARS.includes?(char)
          if matching_char(char, char_stack.last)
            char_stack.pop
          else
            @invalid_lines << line
            @illegal_chars << char
            char_stack = [] of Char
            break
          end
        else
          char_stack.push(char)
        end
      end
      if !char_stack.empty?
        @incomplete_lines << line
        str = ""
        while !char_stack.empty?
          str += MATCHING_CHARS[char_stack.pop]
        end
        @incomplete_missing << str
      end
    end

    def illegal_chars
      @illegal_chars
    end

    SCORING_HASH = {
      ')' => 3_i64,
      ']' => 57_i64,
      '}' => 1197_i64,
      '>' => 25137_i64
    }
    def illegal_score
      @illegal_score ||= @illegal_chars.map { |v| SCORING_HASH[v] }.sum
    end

    def incomplete_missing
      @incomplete_missing
    end

    INCOMPLETE_SCORING_HASH = {
      ')' => 1_i64,
      ']' => 2_i64,
      '}' => 3_i64,
      '>' => 4_i64
    }
    def incomplete_points
      @incomplete_points ||= @incomplete_missing.map do |missing_str|
        score = 0_i64
        missing_str.chars.each do |chr|
          score = (score * 5) + INCOMPLETE_SCORING_HASH[chr]
        end
        score
      end
    end

    def incomplete_score
      incomplete_points.sort[(incomplete_points.size / 2).to_i]
    end
  end

  def self.part_1()
    syntax_checker = SyntaxChecker.new
    while (line = gets())
      syntax_checker.check(line)
    end

    puts syntax_checker.illegal_score
  end

  def self.part_2()
    syntax_checker = SyntaxChecker.new
    while (line = gets())
      syntax_checker.check(line)
    end

    puts syntax_checker.incomplete_score
  end
end
