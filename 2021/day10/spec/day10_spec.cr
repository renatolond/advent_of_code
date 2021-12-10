require "./spec_helper"

describe Day10 do
  # TODO: Write tests

  it "with the sample input, risk should be 15" do
    sample_input = ["[({(<(())[]>[[{[]{<()<>>",
                    "[(()[<>])]({[<{<<[]>>(",
                    "{([(<{}[<>[]}>{[]{[(<()>",
                    "(((({<>}<{<{<>}{[]{[]{}",
                    "[[<[([]))<([[{}[[()]]]",
                    "[{[{({}]{}}([{[{{{}}([]",
                    "{<[[]]>}<{[{[{[]{()[[[]",
                    "[<(<(<(<{}))><([]([]()",
                    "<{([([[(<>()){}]>(<<{{",
                    "<{([{{}}[<[[[<>{}]]]>[]]"]
    syntax_checker = Day10::SyntaxChecker.new
    sample_input.each do |line|
      syntax_checker.check(line)
    end

    syntax_checker.illegal_chars.should eq ['}', ')', ']', ')', '>']
    syntax_checker.illegal_score.should eq 26397
    syntax_checker.incomplete_missing.should eq ["}}]])})]", ")}>]})", "}}>}>))))", "]]}}]}]}>", "])}>"]
    syntax_checker.incomplete_points.should eq [288957, 5566, 1480781, 995444, 294]
    syntax_checker.incomplete_score.should eq 288957
  end
end
