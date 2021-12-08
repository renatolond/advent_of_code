require "./spec_helper"

describe Day8 do
  # TODO: Write tests

  it "with the other sample input, digits should match" do
    sample_input = ["acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf"]
    ssdg = Day8::SevenSegmentDisplayGuesser.new

    sample_input.each do |line|
      ssdg.guess(line)
    end

    ssdg.digits.should eq(['d', 'e', 'a', 'f', 'g', 'b', 'c'])
    ssdg.easy_numbers.should eq(0)
    ssdg.output.should eq(5353)
  end

  it "with the sample input, easy numbers should eq 26" do
    sample_input = ["be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe",
                    "edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc",
                    "fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg",
                    "fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb",
                    "aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea",
                    "fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb",
                    "dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe",
                    "bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef",
                    "egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb",
                    "gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce"]
    ssdg = Day8::SevenSegmentDisplayGuesser.new

    sample_input.each do |line|
      ssdg.guess(line)
    end

    ssdg.easy_numbers.should eq(26)
    ssdg.output.should eq(61229)
  end
end
