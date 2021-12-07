require "./spec_helper"

describe Day7 do
  # TODO: Write tests

  it "with the sample input, fuel should be 37, pos 2" do
    sample_input = "16,1,2,0,4,2,7,1,2,14"

    cp = Day7::CrabPosition.new

    cp.initial_state(sample_input)

    cp.alignment_pos.should eq(2)
    cp.fuel_for_alignment.should eq(37)
  end
  it "with the another input, should eq 1" do
    sample_input = "0,1"

    cp = Day7::CrabPosition.new

    cp.initial_state(sample_input)

    cp.alignment_pos.should eq(1)
    cp.fuel_for_alignment.should eq(1)
  end
  it "with the sample input, should eq 2" do
    sample_input = "0,1,2"

    cp = Day7::CrabPosition.new

    cp.initial_state(sample_input)

    cp.alignment_pos.should eq(1)
    cp.fuel_for_alignment.should eq(2)
  end

  it "with the sample input, fuel should be 168, pos 5" do
    sample_input = "16,1,2,0,4,2,7,1,2,14"

    cp = Day7::CrabPosition.new

    cp.initial_state(sample_input)

    pos, fuel = cp.min_fuel
    pos.should eq(5)
    fuel.should eq(168)
  end
end
