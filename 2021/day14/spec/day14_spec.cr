require "./spec_helper"

describe Day14 do
  # TODO: Write tests

  it "with sample input 1, there should be 10 paths" do
    sample_input = ["NNCB",
"",
"CH -> B",
"HH -> N",
"CB -> H",
"NH -> C",
"HB -> C",
"HC -> B",
"HN -> C",
"NN -> C",
"BH -> H",
"NC -> B",
"NB -> B",
"BN -> B",
"BB -> N",
"BC -> B",
"CC -> N",
"CN -> C"]

    pc = Day14::PolymerCreator.new
    pc.polymer = sample_input.shift
    sample_input.shift

    sample_input.each do |line|
      pc.add_rule line
    end

    pc.step
    # pc.polymer.should eq("NCNBCHB")
    pc.polymer_parts.should eq([1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 1])
    pc.elements_tally.should eq({ 'B' => 2, 'C' => 2, 'H' => 1, 'N' => 2})
    pc.step
    # pc.polymer.should eq("NBCCNBBBCBHCB")
    pc.elements_tally.should eq({ 'B' => 6, 'C' => 4, 'H' => 1, 'N' => 2})
    pc.step
    # pc.polymer.should eq("NBBBCNCCNBBNBNBBCHBHHBCHB")
    pc.step
    # pc.polymer.should eq("NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB")

    pc.step
    # pc.polymer.size.should eq(97)
    (10 - 5).times do
      pc.step
    end
    # pc.polymer.size.should eq(3073)
    pc.elements_tally.should eq({ 'B' => 1749, 'C' => 298, 'H' => 161, 'N' => 865})
    pc.first_answer.should eq(1588)

    (40 - 10).times do
      pc.step
    end
    pc.first_answer.should eq(2188189693529_i64)
  end
end
