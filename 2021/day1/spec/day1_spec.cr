require "./spec_helper"

require "mocks/spec"

Mocks.create_module_mock Day1 do
  mock self.read_from_input()
end

describe Day1 do
  it "With the sample input, gives out 7" do
    input = [199, 200, 208, 210, 200, 207, 240, 269, 260, 263] of Int64
    allow(Day1).to receive(self.read_from_input()).and_return(input)
    Day1.part_1().should eq(7)
  end

  it "With the sample input, gives out 5" do
    input = [199, 200, 208, 210, 200, 207, 240, 269, 260, 263] of Int64
    allow(Day1).to receive(self.read_from_input()).and_return(input)
    Day1.part_2().should eq(5)
  end
end
