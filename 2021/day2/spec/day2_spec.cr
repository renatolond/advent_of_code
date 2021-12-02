require "./spec_helper"

require "mocks/spec"

Mocks.create_module_mock Day2 do
  mock self.read_from_input()
end

describe Day2 do
  it "With the sample input, gives out 150" do
    instructions = ["forward 5", "down 5", "forward 8", "up 3", "down 8", "forward 2"]
    submarine = Day2::Submarine.new
    instructions.each { |i| submarine.move(i); }
    submarine.multiply_pos().should eq(150)
  end

  it "With the sample input, gives out 150" do
    instructions = ["forward 5", "down 5", "forward 8", "up 3", "down 8", "forward 2"]
    submarine = Day2::SubmarineV2.new
    instructions.each { |i| submarine.move(i); }
    submarine.multiply_pos().should eq(900)
  end

end
